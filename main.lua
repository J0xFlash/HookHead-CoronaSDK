----------
-- v 1.00
-- @author: Sergey Pomorin
-- @skype: j0xflash
-- @project: The Floor is Lava The Game
----------

_W = display.contentWidth;
_H = display.contentHeight;
_WO = 1080;
_HO = 1920;

optionsBuild = "android";-- "ios"/"android"/"windows"/"osx"

options_debug = false;
options_pause = false;
options_save = true;
options_demo = false;
options_controls = "touch"; -- touch, cursor, console
optionsMobile = (optionsBuild == "ios" or optionsBuild == "android");
options_save_fname = "dataUser";

encrypt_password = '12345678test'

-- groups
mainGroup = display.newGroup();
cursorGroup = display.newGroup();
mainGroup.parent:insert(mainGroup);
cursorGroup.parent:insert(cursorGroup);

-- makeup
scaleGraphics = 1;
guiScale = 1;
mobileScale = 1;
minScale = math.min(_W/_WO, _H/_HO);
maxScale = math.max(_W/_WO, _H/_HO);
print("WxH: ".._W.."x".._H);

-- data user
login_obj = {};

---- import source
director = require("director");
json = require("json");

---- framework
movieclip = require("framework.movieclip");
require("framework.lua-enumerable");
require("framework.greenStandart");
greenSounds = require("framework.greenSounds").new();
xml = require("framework.greenXml").newParser();
language = require("framework.greenLang").new();
--spine = require("framework.spine");
greenLS = require 'framework.greenLoadSave';
greenInspect = require 'framework.greenInspect';
greenMsgs = require("framework.greenMsgs").new();
greenMsgs.x = 20;
greenMsgs.y = 20;
greenMsgs.isVisible = options_debug;

---- src
game_art = nil;

-- vars
fontMain = 'FRADM.TTF'; -- 'Franklin Gothic Demi', 'FRADM.TTF'
dataXml = nil;
dataImage = {};
_cursor = nil;
_tooltip = nil;
_bLoadGame = false;

local screenLoader = nil;

function refreshScaleGraphics()
	_W = display.contentWidth;
	_H = display.contentHeight;
	scaleGraphics = 1;
	minScale = math.min(_W/_WO, _H/_HO);
	maxScale = math.max(_W/_WO, _H/_HO);
	guiScale = maxScale;
	scaleGraphics = minScale;
	if(optionsMobile)then
		mobileScale = 2;
	end
	if(_cursor)then
		_cursor.img.xScale = 0.5;
		_cursor.img.yScale = _cursor.img.xScale;
	end
	if(_tooltip)then
		createTooltip()
	end
	if(screenLoader)then
		screenLoader.x = _W/2;
		screenLoader.y = _H/2;
		screenLoader.bg.width = _W/scaleGraphics;
		screenLoader.bg.height = _H/scaleGraphics;
		screenLoader.xScale = scaleGraphics;
		screenLoader.yScale = scaleGraphics;
	end
	-- print("minScale:", minScale, "maxScale:", maxScale, "guiScale:", guiScale);
end
refreshScaleGraphics();

function createTooltip()
	
end

if(optionsBuild == "ios")then
	
elseif(optionsBuild == "android")then
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
elseif(optionsBuild == "windows" or optionsBuild == "osx")then
	options_controls = "cursor";
end

-- methods
function getText(value)
	return language:get_txt(value);
end

-- standart methods
function getTimer()
	return system.getTimer();
end
function sign(x)
  return (x<0 and -1) or 1
end
function top_mc_count_one(val, valTf)
	local ds = val - math.abs(tonumber(valTf));
	local ds_abs = math.abs(ds);

	if(ds_abs>2000)then
		valTf = valTf + sign(ds)*1000;
	elseif(ds_abs>200)then
		valTf = valTf + sign(ds)*100;
	elseif(ds_abs>20)then
		valTf = valTf + sign(ds)*10;
	elseif(ds_abs>0)then
		valTf = valTf + sign(ds);
	end
	
	return valTf;
end

-- save/load data
function clearData()
	login_obj = {};
end
function saveData()
	if(options_save)then
		greenLS.save(options_save_fname..'.dat', login_obj)
	end
end
function loadData()
	_bLoadGame = true;
	login_obj = greenLS.load(options_save_fname..'.dat')
	
	if (login_obj == nil) then
		clearData();
		-- print("Loading: fail!");
	end
end

-- language
language:add_lang_xml('en');
language:loadSettings();

profiling = require("framework.greenProfiling").new();
profiling.x = profiling.width/2;
profiling.y = profiling.height/2;
profiling.isVisible = options_debug;

function createLoader()
	if(screenLoader)then
		screenLoader:removeSelf();
		screenLoader = nil;
	end
	screenLoader = display.newGroup();
	mainGroup:insert(screenLoader);
	
	local screen = display.newRect( 0, 0, _WO, _HO );
	screen:setFillColor( 0, 0, 0 );
	screenLoader:insert(screen);
	
	local options = 
	{
		parent = screenLoader,
		text = "", 
		font = nil,
		fontSize = 40,
		width = _W*0.8,
		align = "center"
	}
	
	local tfLoader = display.newText(getText("loading"), 0, 0, nil, 40);
	tfLoader:setTextColor( 1,1,1); 
	tfLoader.y = 200;
	screenLoader:insert(tfLoader);
	screenLoader.tf = tfLoader;
	local tfDesc = display.newText(options);
	tfDesc:setTextColor( 1,1,1); 
	tfDesc.y = 300;
	screenLoader.tfDesc = tfDesc;
	screenLoader.bg = screen;
	screenLoader.bg.width = _W/scaleGraphics;
	screenLoader.bg.height = _H/scaleGraphics;
	
	screenLoader.x = _W/2;
	screenLoader.y = _H/2;
	screenLoader.xScale = scaleGraphics;
	screenLoader.yScale = scaleGraphics;
end
createLoader()

function loaderShow()
	if(screenLoader)then
		screenLoader.tf.text = getText("loading");
		screenLoader.tfDesc.text = "";
		screenLoader.isVisible = true;
	end
end
function loaderClose()
	if(screenLoader)then
		screenLoader.isVisible = false;
	end
end

function show_msg(txt)
	if(options_debug)then
		mainGroup:insert(greenMsgs);
		greenMsgs:show_msg(txt);
	end
end

-- Show scene
function transitionRemoveSelfHandler(obj)
	if(obj)then
		if(obj.removeSelf)then
			obj:removeSelf();
		end
	end
end
function show_fade_gfx(callback)
	local fade_in = display.newRect(mainGroup, _W/2, _H/2, _W, _H);
	fade_in:setFillColor(0,0,0);
	transition.from(fade_in, {time=400, alpha=0, transition=easing.outQuad, onComplete=function(obj)
		callback();
		transition.to(obj, {time=100, alpha=1, onComplete=transitionRemoveSelfHandler});

		local fade_out = display.newRect(mainGroup, _W/2, _H/2, _W, _H);
		fade_out:setFillColor(0,0,0);
		transition.to(fade_out, {time=300, alpha=0, transition=easing.inQuad, 
				onComplete=transitionRemoveSelfHandler});
	end
	});
end
function showMenu()
	show_fade_gfx(function()
		director:changeScene('src.ScreenMenu');
	end)
end
function showGame()
	show_fade_gfx(function()
		director:changeScene('src.ScreenGame');
	end)
end

-- methods
function addButton(title, tx, ty, fname, onRelease, tfSize, tfColor, ico)
	local item_mc = display.newGroup();
	item_mc.act = title;
	item_mc.onRelease = onRelease;
	item_mc.x, item_mc.y = tx,ty;
	local body_mc = display.newImage(item_mc, fname);
	body_mc.x, body_mc.y = 0,0;
	local over_mc = display.newImage(item_mc, fname);
	over_mc.blendMode = "add";
	over_mc.alpha = 0.0;
	over_mc.x, over_mc.y = 0,0;
	item_mc.r = body_mc.width*body_mc.xScale/2;
	item_mc.rr = item_mc.r*item_mc.r;
	item_mc.w = item_mc.width*item_mc.xScale;
	item_mc.h = item_mc.height*item_mc.yScale;
	item_mc._selected = false;
	item_mc._body = body_mc;
	item_mc._over = over_mc;
	item_mc.enabled = true;

	if(tfSize)then
		item_mc.tf = display.newText( getText(title), 0, 0, fontMain, tfSize );
		if(tfColor)then
			item_mc.tf:setFillColor( tfColor[1]/255, tfColor[2]/255, tfColor[3]/255 );
		else
			item_mc.tf:setFillColor( 1,1,1 );
		end
		item_mc.tf.x = 0;
		item_mc.tf.y = 0;
		item_mc:insert(item_mc.tf);
	end
	if(ico)then
		local body_mc = display.newImage(item_mc, "image/buttons/" .. ico .. ".png");
		item_mc.ico = body_mc;
	end
	
	return item_mc
end

function addButtonTexture(name, title)
	if(title == nil)then
		title = name;
	end
	local item_mc = display.newGroup();
	item_mc.act = title;
	local body_mc = addObj(name);
	item_mc:insert(body_mc)
	local over_mc = addObj(name);
	over_mc.blendMode = "add";
	over_mc.alpha = 0.0;
	item_mc:insert(over_mc)
	item_mc.r = body_mc.width*body_mc.xScale/2;
	item_mc.rr = item_mc.r*item_mc.r;
	item_mc.w = item_mc.width*item_mc.xScale;
	item_mc.h = item_mc.height*item_mc.yScale;
	item_mc._selected = false;
	item_mc._body = body_mc;
	item_mc._over = over_mc;
	item_mc.enabled = true;

	if(tfSize)then
		item_mc.tf = display.newText( getText(title), 0, 0, fontMain, tfSize );
		if(tfColor)then
			item_mc.tf:setFillColor( tfColor[1]/255, tfColor[2]/255, tfColor[3]/255 );
		else
			item_mc.tf:setFillColor( 1,1,1 );
		end
		item_mc.tf.x = 0;
		item_mc.tf.y = 0;
		item_mc:insert(item_mc.tf);
	end
	if(ico)then
		local body_mc = display.newImage(item_mc, "image/buttons/" .. ico .. ".png");
		item_mc.ico = body_mc;
	end
	
	return item_mc
end

function createText(text, size, fillColor, embossColor, font)
	if(size == nil)then
		size = 24*scaleGraphics;
	end
	if(fillColor == nil)then
		fillColor = {1,1,1};
	end
	if(embossColor == nil)then
		embossColor = 
		{
			highlight = { r=0, g=0, b=0 },
			shadow = { r=0, g=0, b=0 }
		}
	end
	if(font == nil)then
		font = fontMain;
	end
	
	local tf = display.newEmbossedText(text, 0, 0, font, size)
	tf:setFillColor(fillColor[1], fillColor[2], fillColor[3]);
	tf:setEmbossColor(embossColor)
	
	return tf;
end

function scaleObjects(obj, scale)
	obj.xScale = scale;
	obj.yScale = scale;
	if(obj.w)then
		obj.w = obj.w*scale;
	end
	if(obj.h)then
		obj.h = obj.h*scale;
	end
end

function addItemCount(item_id, val)
	if(val and login_obj)then
		if(login_obj[item_id])then
			login_obj[item_id] = login_obj[item_id] + tonumber(val);
		else
			login_obj[item_id] = tonumber(val);
		end
	end
end

function setItemCount(item_id, val)
	if(val and login_obj)then
		login_obj[item_id] = tonumber(val);
	end
end

function getItemCount(item_id)
	local count = 0;
	if(login_obj[item_id])then
		count = login_obj[item_id];
	end

	return count;
end

function loadTextureUnit(name)
	game_art:loadData(name);
end

function addObj(name)
	local data = dataImage[name];
	local obj = nil;
	if(data)then
		obj = display.newImage(data.image, data.sheet);
	else
		print("addObj: not found", name);
		obj = display.newRect(0, 0, 100, 100);
		obj:setFillColor(1, 0, 0);
	end
	return obj;
end

-- music/sound
function musicContinue()
	greenSounds:music_continue();
end
function musicStop()
	greenSounds:music_stop();
end
function musicPlay(val)
	greenSounds:music_play(val);
end
function musicVolume(val)
	greenSounds:setVolumeMusic(val);
end
function soundPlay(val)
	greenSounds:sound_play(val);
end
function soundVolume(val)
	greenSounds:setVolume(val);
end
function setMusic(value)
	greenSounds:setMusicBol(value);
end
function setSound(value)
	greenSounds:setSoundBol(value);
end
function soundSwith()
	greenSounds:switchSound();
end
function musicSwith()
	greenSounds:switchMusic();
	return greenSounds:getMusicBol();
end

suspended_obj = {};
function onSystem(evt)
	print("onSystem type:", evt.type);
    if evt.type == "applicationStart" then

    elseif evt.type == "applicationExit" then
		-- saveData();
    elseif evt.type == "applicationSuspend" then
		if(_bLoadGame)then
			saveData();
		end
		suspended_obj['sound'] = greenSounds:getSoundBol();
		suspended_obj['music'] = greenSounds:getMusicBol();
		greenSounds:setSoundBol(false);
		greenSounds:setMusicBol(false);
    elseif evt.type == "applicationResume" then
		greenSounds:setSoundBol(suspended_obj['sound']);
		greenSounds:setMusicBol(suspended_obj['music']);
    end
end
Runtime:addEventListener("system", onSystem);

local function iniSetArt(set_name)
	local sheetInfo = require('images.texture.'..set_name);
	local data = sheetInfo:getSheet();
	local image = graphics.newImageSheet('images/texture/'.. set_name..".png", data);
	local sequences = {};
	
	for key,value in pairs(sheetInfo.frameIndex) do
		data.frames[value].name = key;
	end
	for i=1,#data.frames do
		local frame_name = data.frames[i].name;
		local texture = sheetInfo:getFrameIndex(frame_name);
		dataImage[frame_name] = {image=image, sheet=texture};
	end
end

local function loadMusic()
	-- greenSounds:add_sound('music', true);
end
local function loadSounds()
	greenSounds:add_sound('click_approve');
end

local function loadTexture()
	iniSetArt("back1Texture");
	iniSetArt("back2Texture");
	iniSetArt("itemsTexture");
end

local function onResize(event)
	refreshScaleGraphics();
	showMenu();
end

-- init game
local function main()
	display.setStatusBar(display.HiddenStatusBar);
	
	local loading_steps = {};
	
	table.insert(loading_steps, function()
		mapsXml = xml:loadFile('data/data.xml');
	end);
	table.insert(loading_steps, function()
		loadTexture();
	end);
	table.insert(loading_steps, function()
		loadMusic();
	end);
	table.insert(loading_steps, function()
		loadSounds();
	end);
	-- table.insert(loading_steps, function()
		-- _G.game_art = require("src.ItemAnima").new();
	-- end);
	table.insert(loading_steps, function()
		loadData();
	end);
	table.insert(loading_steps, function()
		-- musicPlay("musicMap");
	end);
	
	local loading_steps_max = #loading_steps+1;
	local st=getTimer();
	loaderShow();
	
	local function mainHandler(e)
		if(#loading_steps>0)then
			loading_steps[1]();
			table.remove(loading_steps, 1);
			
			if(screenLoader)then
				local id = loading_steps_max - #loading_steps-1;
				local loading_p = math.floor((loading_steps_max - #loading_steps)*100/loading_steps_max);
				screenLoader.tf.text = getText("loading")..': '..loading_p..'%';
				screenLoader.tfDesc.text = getText("loading_"..id);
			end
			return
		end
		loaderClose();
		director:changeScene("src.ScreenMenu");
		print('mainHandler:game loaded in '..(getTimer()-st)..'ms');
		
		Runtime:removeEventListener("enterFrame", mainHandler);
	end
	Runtime:addEventListener("enterFrame", mainHandler);
end

main();

if(options_controls == "cursor")then
	Runtime:addEventListener( "resize", onResize )
end
