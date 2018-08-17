module(..., package.seeall);
-- greenSounds	1.0

local function loadSoundFile(fname)
	local path =  system.pathForFile(fname, system.DocumentsDirectory);
	local file = io.open( path, "r" );
	if (file) then
		local contents = file:read( "*a" );
		io.close(file);
		if(contents and #contents>0)then
			return contents;
		end
	end
	return nil
end
local function saveSoundFile(fname, save_str)
	local path = system.pathForFile( fname, system.DocumentsDirectory);
	local file = io.open(path, "w");
	if file then
		file:write(save_str);          
		io.close(file);
		-- print("Saving("..fname.."): ok!")
	else
		-- print("Saving("..fname.."): fail!")
	end
end

function new()
	local _mc = display.newGroup();
	local _sounds_on = true;
	local _musics_on = true;
	local _sounds_vol = 1;
	local _musics_vol = 0.45;
	local _last_music = nil;
	
	local _sounds = {};
	local _packs = {};
	
	local _sounds_playing = {};
	
	local _loading_sounds = {};
	local loadCallback = nil;
	local idM = 1; -- channel for music
	local idD = 2; -- channel for dialogs
	
	audio.reserveChannels(idD);
	_mc.sounds = _sounds;
	
	function _mc:saveSettings()
		local settings = {};
		settings._sounds_on=_sounds_on;
		settings._musics_on=_musics_on;
		settings._sounds_vol=_sounds_vol;
		settings._musics_vol=_musics_vol;
		local tdata = json.encode(settings);
		saveSoundFile("settings", tdata);
	end
	function _mc:loadSettings()
		local tdata = loadSoundFile("settings");
		if(tdata)then
			local settings = json.decode(tdata);
			if(settings)then
				_sounds_on=settings._sounds_on;
				_musics_on=settings._musics_on;
				_sounds_vol=settings._sounds_vol or 1;
				_musics_vol=--[[settings._musics_vol or]] 0.45;
			end
		else
			if(optionsBuild == "nook")then
				_musics_on = false;
			end
		end
	end
	
	function turn(evt)
		if(#_loading_sounds == 0)then
			Runtime:removeEventListener("enterFrame", turn);
			if(loadCallback)then
				loadCallback();
			end
		end
	end
	function _mc:getSoundBol()
		return _sounds_on;
	end
	function _mc:getMusicBol()
		return _musics_on;
	end
	function _mc:getSoundVol()
		return _sounds_vol;
	end
	function _mc:getMusicVol()
		return _musics_vol;
	end
	function _mc:setSoundBolTemp(val)
		_sounds_on = val;
	end
	function _mc:setMusicBolTemp(val)
		_musics_on = val;
		if(_musics_on)then
			_mc:music_continue();
		else
			_mc:music_stop();
		end
	end
	function _mc:setSoundBol(val)
		_sounds_on = val;
		_mc:saveSettings()
	end
	function _mc:setMusicBol(val)
		_musics_on = val;
		if(_musics_on)then
			_mc:music_continue();
		else
			_mc:music_stop();
		end
		_mc:saveSettings()
	end
	
	function _mc:switchSound()
		local val = (_sounds_on == false);
		_mc:setSoundBol(val)
		return _sounds_on;
	end
	function _mc:switchMusic()
		local val = (_musics_on == false);
		_mc:setMusicBol(val);
		_mc:setSoundBol(val)
		return _musics_on;
	end
	
	function _mc:setLoadCallback(val)
		loadCallback = val;
		Runtime:addEventListener("enterFrame", turn);
	end
	
	function _mc:add_sound(val, asStream, packid)
		-- print("_add_sound:",val,asStream)
		if(asStream)then
			_sounds[val] = audio.loadStream("sounds/"..val..".mp3");
		else
			_sounds[val] = audio.loadSound("sounds/"..val..".mp3");
			--table.insert(_loading_sounds, val);
		end
		if(packid)then
			_mc:add_pack(packid, val)
		end
	end
	
	function _mc:music_play_once(val)
	end
	
	local _backgroundMusic = nil;
	function _mc:music_stop()
		-- print("__music_stop:backgroundMusic:",_backgroundMusic)
		if(_backgroundMusic)then
			audio.stop(_backgroundMusic);
			_backgroundMusic = nil;
		end
	end
	function _mc:music_play(val)
		if(_backgroundMusic)then
			if(val == _last_music)then
				print('ERROR#:this_music_already_playing!')
				return
			end
		end
		_last_music = val;
		if(_musics_on)then
			_mc:music_stop();
			if(_sounds[val])then
				_backgroundMusic = audio.play( _sounds[val], { channel=idM, loops=-1 });
				
				audio.setVolume( _musics_vol, { channel=idM } )
				print("__music_play:_musics_vol:",_musics_vol)
				-- print("__music_play:backgroundMusic:",_backgroundMusic)
			end
		end
	end
	function _mc:music_continue()
		if(_last_music)then
			local val = _last_music;
			if(_musics_on)then
				if(_sounds[val])then
					_backgroundMusic = audio.play( _sounds[val], {channel=idM, loops=-1 });
					-- print("__music_continue:backgroundMusic:",_backgroundMusic)
				end
			end
		end
	end
	function _mc:setVolumeMusic(value)
		_musics_vol = value;
		if(value < 0.05)then
			_musics_on = false;
			_mc:music_stop();
		else
			_musics_on = true;
		end
		if(_backgroundMusic == nil)then
			if(_last_music == nil)then
				_last_music = "musicMenu";
			end
			_mc:music_continue();
		end
		if(_last_music)then
			local val = _last_music;
			if(_musics_on)then
				if(_sounds[val])then
					audio.setVolume( value, { channel=idM } )
				end
			end
		end
	end
	
	function _mc:sound_check(val)
		return _packs[val] or _sounds[val];
	end
	
	function _mc:sound_play(val)
		if(_sounds_on)then
			if(_packs[val])then
				local packid = val;
				local sid = math.floor(#_packs[packid]*math.random()*0.999)+1;
				val = _packs[packid][sid];	
			end
			if(_sounds[val])then
				if(_sounds_playing[val])then
					if(system.getTimer()-_sounds_playing[val]<100)then
						return
					end
				end
				-- print("_sound_play:", val, _sounds[val]);
				audio.play(_sounds[val]);
				_sounds_playing[val] = system.getTimer();
			end
		end
	end
	function _mc:setVolume(value)
		_sounds_vol = value;
		if(value < 0.05)then
			_sounds_on = false;
		else
			_sounds_on = true;
		end
		for i=idD+1,32 do
			audio.setVolume(value, {channel=i})
		end
	end
	function _mc:add_pack(packid, val)
		if(_packs[packid] == nil)then
			_packs[packid] = {};
		end
		table.insert(_packs[packid], val);
	end
	
	_mc:loadSettings();
	
	return _mc
end