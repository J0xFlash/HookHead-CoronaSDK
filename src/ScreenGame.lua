----------
-- @author: Sergey Pomorin
-- @skype:
----------
module(..., package.seeall);

function new()
	local localGroup = display.newGroup();
	local backGroup = display.newGroup();
	local gameGroup = display.newGroup();
	local faceGroup = display.newGroup();
	
	local ANGLE = 60;
	local SCORE = 1;
	local TIME_SPEED_MAX = 3000;
	local TIME_TORCH = 15000;
	local TIME_SAW = 9000;
	
	local _arButtons = {};
	local _arWalls = {};
	local _arTiles = {};
	local _arImgTiles = {};
	local _arPlatforms = {};
	local _gameObj = {};
	local _bWindow = false; -- открыто окно или нет
	local _bArrow = false;
	local _bGameOver = false;
	local _character = nil;
	local _posChar = 0;
	local _arrow = nil;
	local _torch = nil;
	local _saw = nil;
	local _floorObj = nil;
	local _wndOptions = nil;
	local _wndGameOver = nil;
	local _oldTime = getTimer();
	local _timeGame = 0;
	local _timeTorch = 0;
	local _timeSaw = 0;
	local _countTileY = 0;
	local _countPlatformY = 6;
	local _score = 0;
	local _closeTime = 0;
	local _levelTileY = 0;
	local _levelPlatformY = 0;
	local _levelWallY = 0;
	local _minCountWall = 4;
	local _speedGame = 1*scaleGraphics;
	local _offsetWallY = 600*scaleGraphics;
	local _offsetPlatformY = 700*scaleGraphics;
	local _offsetFloor = 2500*scaleGraphics;
	
	localGroup:insert(gameGroup);
	localGroup:insert(faceGroup);
	gameGroup:insert(backGroup);
	
	local rect = display.newRect( _W/2, _H/2, _W, _H )
	rect:setFillColor(0,0,0);
	backGroup:insert(rect);
	
	local tfTitle = createText("", 80*scaleGraphics, {1,1,1})
	tfTitle.x = _W/2;
	tfTitle.y = 400*scaleGraphics;
	faceGroup:insert(tfTitle);
	
	local bgScore = addObj("score");
	bgScore.xScale = 0.65*scaleGraphics;
	bgScore.yScale = bgScore.xScale;
	bgScore.x = _W/2; 
	bgScore.y = 120*scaleGraphics; 
	faceGroup:insert(bgScore);
	
	local tfScore = createText(_score, 80*scaleGraphics, {128/255,137/255,137/255})
	tfScore.x = _W/2;
	tfScore.y = 100*scaleGraphics;
	faceGroup:insert(tfScore);
	
	local function restartGame()
		_G.options_pause = false;
		localGroup:removeAllListeners();
		showGame();
	end
	
	local function closeGame()
		_G.options_pause = false;
		localGroup:removeAllListeners();
		showMenu();
	end
	
	local function closeOptions()
		if(_wndOptions)then
			_wndOptions.isVisible = false;
		end
		_G.options_pause = false;
		_closeTime = 100;
	end
	
	local function clickOptions()
		if(_bWindow)then
			return;
		end
		if(_wndOptions == nil)then
			_wndOptions = require("src.WindowOptions").new(restartGame, closeGame);
			_wndOptions.xScale = minScale*mobileScale;
			_wndOptions.yScale = _wndOptions.xScale;
			faceGroup:insert(_wndOptions);
		end
		
		_wndOptions.isVisible = true;
		_wndOptions.x = _W/2;
		_wndOptions.y = _H/2;
		
		_bWindow = true;
		_G.options_pause = true;
	end
	
	local function closeGameOver()
		if(_wndGameOver)then
			_wndGameOver.isVisible = false;
		end
		_G.options_pause = false;
		_closeTime = 100;
	end
	
	local function refreshSkinCharacter(value)
		value = tostring(value);
		_character.skin1.isVisible = false;
		_character.skin2.isVisible = false;
		_character.skin3.isVisible = false;
		_character.skin4.isVisible = false;
		_character["skin" .. value].isVisible = true;
	end
	
	local function submitScoreListener( event )
		
		-- Google Play Games Services score submission
		if ( globalData.gpgs ) then
			if not event.isError then
				local isBest = nil
				if ( event.scores["daily"].isNewBest ) then
					isBest = "a daily"
				elseif ( event.scores["weekly"].isNewBest ) then
					isBest = "a weekly"
				elseif ( event.scores["all time"].isNewBest ) then
					isBest = "an all time"
				end
				if isBest then
					-- Congratulate player on a high score
					-- local message = "You set " .. isBest .. " high score!"
					-- native.showAlert( "Congratulations", message, { "OK" } )
				else
					-- Encourage the player to do better
					-- native.showAlert( "Sorry...", "Better luck next time!", { "OK" } )
				end
			end
	 
		-- Apple Game Center score submission
		elseif ( globalData.gameCenter ) then
	 
			if ( event.type == "setHighScore" ) then
				-- Congratulate player on a high score
				-- native.showAlert( "Congratulations", "You set a high score!", { "OK" } )
			else
				-- Encourage the player to do better
				native.showAlert( "Sorry...", "Better luck next time!", { "OK" } )
			end
		end
	end
	
	local function submitScore( score )
		if ( globalData.gpgs ) then
			-- Submit a score to Google Play Games Services
			globalData.gpgs.leaderboards.submit(
			{
				leaderboardId = "CgkI0POrzdITEAIQDA",
				score = score,
				listener = submitScoreListener
			})
	 
		elseif ( globalData.gameCenter ) then
			-- Submit a score to Apple Game Center
			globalData.gameCenter.request( "setHighScore",
			{
				localPlayerScore = {
					category = "com.yourdomain.yourgame.leaderboard",
					value = score
				},
				listener = submitScoreListener
			})
		end
	end
	
	local function showGameOver()
		if(_wndGameOver and _wndGameOver.isVisible)then
			return;
		end
		if(_bWindow)then
			closeOptions();
		end
		
		setItemCount("score", _score);
		if(_score> getItemCount("scoreRecord"))then
			setItemCount("scoreRecord", _score);
		end
		submitScore(_score);
		addItemCount("countDeath", 1);
		soundPlay("soundDie");
		refreshSkinCharacter(4);
		
		if(_score >= 500)then
			-- itemAchievement:createAchievement(9);
		end
		if(_score >= 2500)then
			-- itemAchievement:createAchievement(10);
		end
		
		if(_wndGameOver == nil)then
			_wndGameOver = require("src.WindowGameOver").new(restartGame, closeGame);
			_wndGameOver.xScale = minScale*mobileScale;
			_wndGameOver.yScale = _wndGameOver.xScale;
			faceGroup:insert(_wndGameOver);
		end
		
		_wndGameOver.isVisible = true;
		_wndGameOver.x = _W/2;
		_wndGameOver.y = _H/2;
		
		saveData();
		
		if(initAppodeal)then
			appodeal.show( "banner", { yAlign="bottom" } )
		end
		
		_bWindow = true;
	end
	
	local function createBackground()
		local size = 254*scaleGraphics;
		local countX = math.ceil(_W/size) + 1;
		local countY = math.ceil(_H/size) + 1;
		local count = countX * countY;
		local posX = 0;
		local posY = _levelTileY;
		_countTileY = countY;
		
		for i=1, countY do
			local tileGroup = display.newGroup();
			posX = 0;
			
			for i=1, countX do
				local tile = addObj("tileBg");
				tile.xScale = scaleGraphics;
				tile.yScale = scaleGraphics;
				tile.w = tile.width*tile.xScale;
				tile.h = tile.height*tile.yScale;
				tile.x = tile.w*posX;
				tile.y = 0;
				tileGroup:insert(tile);
				posX = posX + 1;
				table.insert(_arImgTiles, tile);
			end
			tileGroup.y = tileGroup.height*posY;
			backGroup:insert(tileGroup);
			table.insert(_arTiles, tileGroup);
			posY = posY + 1;
		end
	end
	
	local function createPlatform()
		local posY = _levelPlatformY;
		
		for i=1, _countPlatformY do
			local platform = addObj("floor_0" .. i);
			scaleObjects(platform, scaleGraphics);
			platform.w = platform.width*platform.xScale;
			platform.h = platform.height*platform.yScale;
			platform.x = _W/2;
			platform.y = _H - posY*_offsetPlatformY;
			platform:setFillColor(0.5, 0.5, 0.5, 1)
			backGroup:insert(platform);
			table.insert(_arPlatforms, platform);
			posY = posY + 1;
		end
		
		_floorObj = addObj("floor");
		scaleObjects(_floorObj, scaleGraphics);
		_floorObj.w = _floorObj.width*_floorObj.xScale;
		_floorObj.h = _floorObj.height*_floorObj.yScale;
		_floorObj.x = _W/2;
		_floorObj.y = _H + _floorObj.h/2;
		backGroup:insert(_floorObj);
		
		_levelPlatformY = posY;
	end
	
	local function pauseGame()
		if(options_pause)then
			closeOptions();
		else
			clickOptions();
		end
	end
	
	local function filterGame(value)
		for i=1,#_arImgTiles do
			local obj = _arImgTiles[i];
			if(value)then
				obj.fill.effect = "filter.exposure"
				obj.fill.effect.exposure = 1.2
			else
				obj.fill.effect = nil;
			end
		end
		for i=1,#_arPlatforms do
			local obj = _arPlatforms[i];
			if(value)then
				obj.fill.effect = "filter.exposure"
				obj.fill.effect.exposure = 1.2
			else
				obj.fill.effect = nil;
			end
		end
		for i=1,#_arWalls do
			local obj = _arWalls[i];
			obj:invertFilter(value);
		end
	end
	
	local function addTorch()
		if(_bGameOver)then
			return;
		end
		if(_torch == nil)then
			_torch = addObj("torch");
			scaleObjects(_torch, scaleGraphics);
			gameGroup:insert(_torch);
		end
		
		_torch.x = _W/2;
		_torch.y = _character.y - _H;
		_torch.maxY = _torch.y + 100*scaleGraphics;
		_torch.minY = _torch.y - 100*scaleGraphics;
		_torch.vectorY = 1;
		_torch.speed = 5*scaleGraphics;
		_torch.isVisible = true;
		_torch.enabled = true;
		_timeTorch = TIME_TORCH + math.ceil(math.random()*5000);
		_timeSaw = TIME_SAW + math.ceil(math.random()*2000);
	end
	
	local function hitTorch()
		local targetWall = _arWalls[_character.wall.id+1] or _arWalls[1];
		local angle = math.atan2(targetWall.y-_character.y, targetWall.x-_character.x);
		local cosAngle = math.cos(angle);
		local sinAngle = math.sin(angle);
		_torch.isVisible = false;
		_torch.enabled = false;
		_character.speed = _character.speedMax;
		_character.xMov = (_character.speed)*cosAngle;
		_character.yMov = (_character.speed)*sinAngle;
		_character.timeMax = TIME_SPEED_MAX;
		_gameObj["countTorch"] = _gameObj["countTorch"] + 1;
		soundPlay("soundTorch");
		filterGame(true);
		
		if(_gameObj["countTorch"] >=15)then
			-- itemAchievement:createAchievement(2);
		elseif(_gameObj["countTorch"] >=5)then
			-- itemAchievement:createAchievement(1);
		elseif(_gameObj["countTorch"] >=1)then
			-- itemAchievement:createAchievement(6);
		end
	end
	
	local function gameOver()
		_bGameOver = true;
		_arrow.isVisible = false;
		_levelPlatformY = _levelPlatformY - _countPlatformY + 1;
		_levelTileY = _levelTileY + _countTileY - 1;
		refreshSkinCharacter(2);
		local angle = math.atan2((_character.y - 50*scaleGraphics)-(_character.y), _W/2-(_character.x));
		local cosAngle = math.cos(angle);
		local sinAngle = math.sin(angle);
		_character.status = 1;
		_character.speed = 70*scaleGraphics;
		_character.xMov = (_character.speed)*cosAngle;
		_character.yMov = (_character.speed)*sinAngle;
	end
	
	local function addSaw()
		if(_bGameOver or (_saw and _saw.enabled))then
			return;
		end
		if(_saw == nil)then
			_saw = addObj("saw");
			gameGroup:insert(_saw);
		end
		
		local scale = (math.random()*0.3+ 0.7)*scaleGraphics;
		scaleObjects(_saw, scale);
		_saw.w = _saw.width*_saw.xScale;
		_saw.h = _saw.height*_saw.yScale;
		_saw.r = _saw.w/2;
		_saw.rr = _saw.r*_saw.r;
		
		_saw.x = _W/2;
		_saw.y = _character.y - _H - _saw.h/2;
		_saw.maxY = _saw.y + _H/2;
		_saw.minY = _saw.y - _H/2;
		_saw.vectorY = 1;
		_saw.speed = 15*scaleGraphics;
		_saw.isVisible = true;
		_saw.enabled = true;
		_timeSaw = TIME_SAW + math.ceil(math.random()*2000);
	end
	
	local function hitSaw()
		_gameObj["countSaw"] = _gameObj["countSaw"] + 1;
		if(_gameObj["countSaw"] >= 1)then
			-- itemAchievement:createAchievement(7);
		end
		soundPlay("soundSaw");
		gameOver();
	end
	
	local function createSkinCharacter(value)
		value = tostring(value);
		_character["skin" .. value] = addObj("character_" .. value);
		_character["skin" .. value].xScale = 0.5;
		_character["skin" .. value].yScale = _character["skin" .. value].xScale;
		_character:insert(_character["skin" .. value]);
	end
	
	local function createCharacter()
		_character = display.newGroup();
		createSkinCharacter(1);
		createSkinCharacter(2);
		createSkinCharacter(3);
		createSkinCharacter(4);
		refreshSkinCharacter(3);
		_character.xScale = 1.5*scaleGraphics;
		_character.yScale = _character.xScale;
		_character.x = _W/2;
		_character.y = _H - 600*scaleGraphics - _character.height/2;
		_character.speedMax = 180*scaleGraphics;
		_character.timeMax = 0;
		_character.speedNormal = 90*scaleGraphics;
		_character.speed = _character.speedNormal;
		_character.xMov = 0;
		_character.yMov = 0;
		_character.status = 0;
		_character.move = false;
		_character.w = _character.width*_character.xScale;
		_character.h = _character.height*_character.yScale;
		gameGroup:insert(_character);
		_floorObj.y = _character.y + _offsetFloor;
		_posChar = _character.y;
		
		if(#_arWalls > 0)then
			local wall = _arWalls[1];
			_character.x = wall.x + _character.width/2*_character.xScale;
		end
	end
	
	local function createWall()
		for i=1, 6 do
			local count = _minCountWall + math.floor(math.random()*3);
			local wall = require("src.ItemWall").new(i, count, i % 2);
			wall.xScale = scaleGraphics;
			wall.yScale = wall.xScale;
			wall.w = wall.width*wall.xScale;
			wall.h = wall.height*wall.yScale;
			wall.char = false;
			if(i % 2 == 1)then
				wall.x = wall.w/2;
			else
				wall.x = _W - wall.w/2;
			end
			wall.y = _H - (i)*_offsetWallY;
			gameGroup:insert(wall);
			table.insert(_arWalls, wall);
			
			_levelWallY = i;
		end
	end
	
	local function createArrow()
		_arrow = display.newGroup();
		local scale = scaleGraphics;
		local img = addObj("hook");
		img.xScale = -1*scale;
		img.yScale = scale;
		img.x = img.width/2*math.abs(img.xScale);
		_arrow:insert(img);
		gameGroup:insert(_arrow);
		
		_arrow.speed = 3;
	end
	
	local function createButtons()
		local btnPause = addButtonTexture("btnPause");
		scaleObjects(btnPause, 0.6*scaleGraphics)
		btnPause.x = _W - btnPause.w/2 - 15*scaleGraphics;
		btnPause.y = btnPause.h/2 + 15*scaleGraphics;
		localGroup:insert(btnPause)
		table.insert(_arButtons, btnPause);
	end
	
	local function refreshCharacter()
		local wall = _character.wall;
		if(wall)then
			if(wall.x > _W/2)then
				_character.x = wall.x - _character.width/2*_character.xScale;
			else
				_character.x = wall.x + _character.width/2*_character.xScale;
			end
		end
		refreshSkinCharacter(3);
		_gameObj["countWall"] = _gameObj["countWall"] + 1;
		if(_gameObj["countWall"] >= 50)then
			-- itemAchievement:createAchievement(5);
		elseif(_gameObj["countWall"] >= 25)then
			-- itemAchievement:createAchievement(4);
		elseif(_gameObj["countWall"] >= 1)then
			-- itemAchievement:createAchievement(3);
		end
		
		if(_character.y > wall.y + (wall.rect.height/2-25)*scaleGraphics)then
			-- itemAchievement:createAchievement(11);
		end
		
		_speedGame = math.min((1 + _gameObj["countWall"]/10)*scaleGraphics, 5*scaleGraphics);
	end
	
	local function refreshArrow()
		if(_bGameOver)then
			return;
		end
		_arrow.x = _character.x;
		_arrow.y = _character.y;
		_arrow.isVisible = true;
		_arrow.rotation = 0;
		
		if(_character.x > _W/2)then
			_arrow.xScale = -1;
		else
			_arrow.xScale = 1;
			_arrow.yScale = 1;
		end
	end
	
	local function init()
		_gameObj["countTorch"] = 0;
		_gameObj["countSaw"] = 0;
		_gameObj["countWall"] = 0;
		
		createBackground();
		createPlatform();
		createWall();
		createArrow();
		createCharacter();
		refreshArrow();
		createButtons();
		
		_timeTorch = TIME_TORCH + math.ceil(math.random()*5000);
		_timeSaw = TIME_SAW + math.ceil(math.random()*2000);
	end
	
	init();
	
	local function touchCharacter(event)
		if (options_pause or _bGameOver) then
			return;
		end
		
		local angle = standart.toRadians(_arrow.rotation);
		local cosAngle = math.cos(angle)*_arrow.xScale;
		local sinAngle = math.sin(angle)*_arrow.xScale;
		_character.xMov = (_character.speed)*cosAngle;
		_character.yMov = (_character.speed)*sinAngle;
		_character.move = true;
		_arrow.isVisible = false;
		refreshSkinCharacter(1);
		soundPlay("soundHook");
	end
	
	local function updateTiles()
		for i=1,#_arTiles do
			local tile = _arTiles[i];
			if(_bGameOver)then
				if(tile.y + gameGroup.y < - tile.height)then
					_levelTileY = _levelTileY + 1;
					tile.y = tile.height*_levelTileY;
				end
			else
				if(tile.y + gameGroup.y > _H + tile.height)then
					_levelTileY = _levelTileY - 1;
					tile.y = tile.height*_levelTileY;
				end
			end
		end
	end
	
	local function refreshWalls()
		for i=1,#_arWalls do
			local wall = _arWalls[i];
			wall.char = false;
		end
	end
	
	local function updateWalls()
		local nextWall = nil;
		for i=1,#_arWalls do
			local wall = _arWalls[i];
			
			if(wall.y + gameGroup.y > _H + wall.h)then
				_levelWallY = _levelWallY + 1;
				local addCount = 0;
				if(_gameObj["countWall"] == 15)then
					_minCountWall = 3;
					addCount = 1;
				elseif(_gameObj["countWall"] == 50)then
					_minCountWall = 2;
					addCount = 2;
				end
				local count = _minCountWall + math.floor(math.random()*(3+addCount));
				wall:setSize(count);
				wall.y = _H - _levelWallY*_offsetWallY;
			end
			
			if(standart.hasCollidedRect(wall.rect, _character) and 
			wall.char == false and _bGameOver == false)then
				refreshWalls();
				if(_character.timeMax > 0)then
					nextWall = _arWalls[i+1] or _arWalls[1];
				else
					wall.char = true;
					_character.move = false;
					_character.wall = wall;
					refreshCharacter();
					refreshArrow();
				end
			end
		end
		
		if(_character.timeMax > 0 and nextWall)then
			local angle = math.atan2(nextWall.y-_character.y, nextWall.x-_character.x);
			local cosAngle = math.cos(angle);
			local sinAngle = math.sin(angle);
			_character.xMov = (_character.speed)*cosAngle;
			_character.yMov = (_character.speed)*sinAngle;
			_character.move = true;
			_arrow.isVisible = false;
			refreshSkinCharacter(1);
		end
	end
	
	local function updatePlatforms()
		for i=1,#_arPlatforms do
			local wall = _arPlatforms[i];
			if(_bGameOver)then
				if(wall.y + gameGroup.y < - wall.h)then
					_levelPlatformY = _levelPlatformY - 1;
					wall.y = _H - (_levelPlatformY-1)*_offsetPlatformY;
				end
			else
				if(wall.y + gameGroup.y > _H + wall.h)then
					_levelPlatformY = _levelPlatformY + 1;
					wall.y = _H - (_levelPlatformY-1)*_offsetPlatformY;
				end
			end
		end
	end
	
	local function updateSaw()
		if(_bGameOver)then
			return;
		end
		if(_saw)then
			_saw.rotation = _saw.rotation - 5;
			_saw.y = _saw.y + _saw.speed * _saw.vectorY;
			if(_saw.y > _saw.maxY)then
				_saw.vectorY = -1;
			end
			if(_saw.y < _saw.minY)then
				_saw.vectorY = 1;
			end
			if(_saw.y > _character.y + _H/2)then
				_saw.enabled = false;
				_saw.isVisible = false;
			end
		end
	end
	
	local function updateTorch()
		if(_bGameOver)then
			return;
		end
		if(_torch)then
			_torch.y = _torch.y + _torch.speed * _torch.vectorY;
			if(_torch.y > _torch.maxY)then
				_torch.vectorY = -1;
			end
			if(_torch.y < _torch.minY)then
				_torch.vectorY = 1;
			end
			if(_torch.y > _character.y + _H/2)then
				_torch.enabled = false;
				_torch.isVisible = false;
			end
		end
	end
	
	local function fallCharacter()
		if(_character.status == 1)then
			if (math.abs(standart.mathRound(_character.x) - _W/2) > 50*scaleGraphics)then
				_character.x = _character.x + standart.mathRound(_character.xMov);
				_character.y = _character.y + standart.mathRound(_character.yMov);
			else
				_character.status = 2;
				_character.speed = _character.speedNormal;
				local angle = math.atan2((_H- 200*scaleGraphics)-(_character.y), _W/2-(_character.x));
				local cosAngle = math.cos(angle);
				local sinAngle = math.sin(angle);
				_character.xMov = (_character.speed)*cosAngle;
				_character.yMov = (_character.speed)*sinAngle;
			end
		elseif(_character.status == 2)then
			if (math.abs(standart.mathRound(_character.y) - _floorObj.y) > _character.h - 150*scaleGraphics)then
				_character.x = _character.x + standart.mathRound(_character.xMov);
				_character.y = _character.y + standart.mathRound(_character.yMov);
			else
				showGameOver();
			end
		end
		
		local _x, _y = _floorObj:localToContent(0, 0); -- localToGlobal
		if(_y > _H - _floorObj.h/2 + _character.yMov)then
			gameGroup.y = -_character.y + _posChar;
		end
	end
	
	local function moveCharacter()
		if(_bGameOver)then
			fallCharacter();
			return;
		end
		
		gameGroup.y = gameGroup.y + _speedGame;
		if(_character.move == false)then
			if(math.ceil(_posChar - gameGroup.y - _character.y) < -math.ceil(_H - _posChar + _character.h/2))then
				gameOver();
			end
			return;
		end
		
		_score = _score + SCORE;
		tfScore.text = _score;
		
		_character.x = _character.x + standart.mathRound(_character.xMov);
		_character.y = _character.y + standart.mathRound(_character.yMov);
		
		if(_torch and standart.hasCollidedRect(_torch, _character) and
		_bGameOver == false and _torch.enabled)then
			hitTorch();
		end
		
		if(_saw and standart.hitTest(_saw,_saw.rr,_character.x,_character.y) and
		_bGameOver == false and _saw.enabled and _character.timeMax < 1)then
			hitSaw();
		end
		
		if(math.ceil(_posChar - gameGroup.y) < math.ceil(_character.y))then
			
		else
			gameGroup.y = -_character.y + _posChar;
			_floorObj.y = _character.y + _offsetFloor;
		end
		
		if(_character.x < 0 or _character.x > _W)then
			gameOver();
		end
	end
	
	local function rotationArrow()
		if(_character.move)then
			return;
		end
	
		if(_bArrow)then
			_arrow.rotation = _arrow.rotation + _arrow.speed;
		else
			_arrow.rotation = _arrow.rotation - _arrow.speed;
		end
		
		if(_arrow.xScale == 1)then
			if(_arrow.rotation < -ANGLE)then
				_bArrow = true;
			end
			if(_arrow.rotation > -1)then
				_bArrow = false;
			end
		else
			if(_arrow.rotation < -1)then
				_bArrow = true;
			end
			if(_arrow.rotation > ANGLE)then
				_bArrow = false;
			end
		end
	end
	
	local function update()
		if (options_pause) then
			return;
		end
		
		local diffTime = getTimer() - _oldTime;
		
		_timeGame = _timeGame + diffTime;
		
		updateTiles();
		updateWalls();
		updatePlatforms();
		updateSaw();
		updateTorch();
		rotationArrow();
		moveCharacter();
		
		if(_character.timeMax > 0)then
			_character.timeMax = _character.timeMax - diffTime;
			if(_character.timeMax < 0)then
				_character.speed = _character.speedNormal;
				filterGame(false);
			end
		end
		
		if(_timeTorch > 0)then
			_timeTorch = _timeTorch- diffTime;
			if(_timeTorch < 0)then
				addTorch();
			end
		end
		
		if(_timeSaw > 0 and _character.timeMax < 1)then
			_timeSaw = _timeSaw- diffTime;
			if(_timeSaw < 0)then
				addSaw();
			end
		end
		
		if(_closeTime > 0)then
			_closeTime = _closeTime - diffTime;
			if(_closeTime < 1)then
				_bWindow = false;
			end
		end
		
		_oldTime = getTimer();
	end
	
	-------------- touchHandler ----------------
	local function checkButtons(event)
		if(_bWindow)then
			-- return;
		end
		for i=1,#_arButtons do
			local item_mc = _arButtons[i];
			local _x, _y = item_mc:localToContent(0, 0); -- localToGlobal
			local dx = event.x - _x;
			local dy = event.y - _y;
			local w = item_mc.w;
			local h = item_mc.h;

			if(math.abs(dx)<w/2 and math.abs(dy)<h/2 and item_mc.isVisible)then
				if(item_mc._selected and event.isPrimaryButtonDown)then
					if(item_mc.img)then
						item_mc.img:stopAtFrame(2);
					end
				elseif(item_mc._selected == false)then
					item_mc._selected = true;
					if(item_mc._over)then
						item_mc._over.alpha = 0.3;
					elseif(item_mc.img)then
						item_mc.img:stopAtFrame(2);
					end
				end
			else
				if(item_mc._selected)then
					item_mc._selected = false;
					if(item_mc._over)then
						item_mc._over.alpha = 0;
					elseif(item_mc.img)then
						item_mc.img:stopAtFrame(1);
					end
				end
			end
		end
	end
	
	local function touchHandler(event)
		local phase = event.phase;
		if(phase=='began')then
			checkButtons(event);
		elseif(phase=='moved')then
			checkButtons(event);
		else
			for i=1,#_arButtons do
				local item_mc = _arButtons[i];
				if(item_mc._selected)then
					item_mc._selected = false;
					if(item_mc._over)then
						item_mc._over.alpha = 0;
					elseif(item_mc.img)then
						item_mc.img:stopAtFrame(1);
						if(item_mc.tf)then
							item_mc.tf.y = item_mc.tf.tgY;
						end
					end
					if(item_mc.onRelease)then
						item_mc:onRelease();
						soundPlay("click_approve");
						return true;
					elseif(item_mc.act == "btnPause")then
						soundPlay("click_approve");
						pauseGame();
						return true;
					end
				end
			end
			
			touchCharacter(event);
		end
	end
	
	local function onKeyEvent(event)
		local phase = event.phase
		local keyName = event.keyName
		local nativeKeyCode = event.nativeKeyCode;
		local isShiftDown = event.isShiftDown;
		if(phase == 'up') then
			if(keyName == "escape" or keyName == "back") then
				if(_bWindow)then
					if(_wndOptions and _wndOptions.isVisible)then
						closeOptions();
						return true;
					end
				else
					if(_wndOptions and _wndOptions.isVisible == false)then
						clickOptions();
						return true;
					end
				end
			end
		end
		return false;
	end
	
	function localGroup:removeAllListeners()
		Runtime:removeEventListener( "enterFrame", update );
		Runtime:removeEventListener("touch", touchHandler);
		Runtime:removeEventListener( "key", onKeyEvent )
		if(_wndOptions)then
			_wndOptions:removeAllListeners();
			_wndOptions = nil;
		end
		if(_wndGameOver)then
			_wndGameOver:removeAllListeners();
			_wndGameOver = nil;
		end
		if(initAppodeal)then
			appodeal.hide("banner")
		end
	end
	
	Runtime:addEventListener( "enterFrame", update );
	Runtime:addEventListener( "touch", touchHandler );
	Runtime:addEventListener( "key", onKeyEvent )
	
	return localGroup;
end