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
	
	local _arButtons = {};
	local _arWalls = {};
	local _bWindow = false; -- открыто окно или нет
	local _bArrow = false;
	local _character = nil;
	local _arrow = nil;
	local _oldTime = getTimer();
	local _timeGame = 0;
	
	localGroup:insert(backGroup);
	localGroup:insert(gameGroup);
	localGroup:insert(faceGroup);
	
	local paint = {
		type = "gradient",
		color1 = { 2/255, 101/255, 120/255, 1 },
		color2 = { 137/255, 19/255, 4/255, 1 },
		direction = "down"
	}
	 
	local rect = display.newRect( _W/2, _H/2, _W, _H )
	rect.fill = paint
	backGroup:insert(rect);
	
	-- local tfTitle = createText("The Game", 80*scaleGraphics, {1,1,1})
	-- tfTitle.x = _W/2;
	-- tfTitle.y = 400*scaleGraphics;
	-- faceGroup:insert(tfTitle);
	
	local function createCharacter()
		_character = display.newImage("images/items/character.png");
		_character.xScale = 0.75;
		_character.yScale = _character.xScale;
		_character.x = _W/2;
		_character.y = _H - 50*scaleGraphics - _character.height/2;
		_character.speed = 30;
		_character.xMov = 0;
		_character.yMov = 0;
		_character.move = false;
		_character.alpha = 0.5;
		gameGroup:insert(_character);
		
		if(#_arWalls > 0)then
			local wall = _arWalls[1];
			_character.x = wall.x + wall.width/2 + _character.width/2*_character.xScale;
		end
	end
	
	local function createWall()
		for i=1, 5 do
			local wall = display.newImage("images/items/wall.png");
			if(i % 2 == 1)then
				wall.x = wall.width/2;
			else
				wall.x = _W - wall.width/2;
			end
			-- wall.yScale = 0.8;
			wall.y = _H - wall.height/2*wall.yScale - (i-1)*(wall.height*wall.yScale - 100);
			wall.w = wall.width*wall.xScale;
			wall.h = wall.height*wall.yScale;
			gameGroup:insert(wall);
			table.insert(_arWalls, wall);
		end
	end
	
	local function createArrow()
		_arrow = display.newGroup();
		local img = display.newImage("images/items/arrow.png");
		img.x = img.width/2;
		_arrow:insert(img);
		gameGroup:insert(_arrow);
		
		_arrow.speed = 2;
	end
	
	local function refreshCharacter()
		local wall = _character.wall;
		if(wall)then
			if(wall.x > _W/2)then
				_character.x = wall.x - wall.w/2 - _character.width/2*_character.xScale;
			else
				_character.x = wall.x + wall.w/2 + _character.width/2*_character.xScale;
			end
		end
	end
	
	local function refreshArrow()
		_arrow.x = _character.x;
		_arrow.y = _character.y;
		_arrow.isVisible = true;
		if(_character.x > _W/2)then
			_arrow.xScale = -1;
		else
			_arrow.xScale = 1;
			_arrow.yScale = 1;
		end
	end
	
	local function init()
		createWall();
		createArrow();
		createCharacter();
		refreshArrow();
	end
	
	init();
	
	local function touchCharacter(event)
		local angle = standart.toRadians(_arrow.rotation);
		local cosAngle = math.cos(angle);
		local sinAngle = math.sin(angle);
		_character.xMov = (_character.speed)*cosAngle;
		_character.yMov = (_character.speed)*sinAngle;
		_character.move = true;
		_arrow.isVisible = false;
	end
	
	local function moveCharacter()
		if(_character.move == false)then
			return;
		end
		
		_character.x = _character.x + standart.mathRound(_character.xMov);
		_character.y = _character.y + standart.mathRound(_character.yMov);
		
		for i=1,#_arWalls do
			local wall = _arWalls[i];
			
			if(standart.hitTestRect(wall, wall.w, wall.h, _character.x, _character.y))then
				_character.move = false;
				_character.wall = wall;
				refreshCharacter();
				refreshArrow();
				break;
			end
		end
	end
	
	local function update()
		if (options_pause) then
			return;
		end
		
		local diffTime = getTimer() - _oldTime;
		
		_timeGame = _timeGame + diffTime;
		if(_bArrow)then
			_arrow.rotation = _arrow.rotation + _arrow.speed;
		else
			_arrow.rotation = _arrow.rotation - _arrow.speed;
		end
		
		if(_arrow.rotation < -60)then
			_bArrow = true;
		end
		if(_arrow.rotation > -1)then
			_bArrow = false;
		end
		
		moveCharacter();
		
		_oldTime = getTimer();
	end
	
	-------------- touchHandler ----------------
	local function checkButtons(event)
		if(_bWindow)then
			return;
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
					elseif(item_mc.act == "start")then
						soundPlay("click_approve");
						showGame();
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
			-- print("nativeKeyCode:", nativeKeyCode, keyName)
			if(isShiftDown and keyName == "`") then
				if(bDebug)then
					closeDebug();
				else
					showDebug();
				end
			elseif(keyName == "escape" or keyName == "back") then
				if(_bWindow)then
					if(wndInfo and wndInfo.isVisible)then
						hideExit();
					elseif(wndSetting and wndSetting.isVisible)then
						closeOptions();
					elseif(wndNew and wndNew.isVisible)then
						hideNewGame();
					elseif(wndDebug and wndDebug.isVisible)then
						closeDebug();
					else
						showExit();
					end
				else
					showExit();
				end
			elseif(keyName == "enter") then
				if(_bWindow)then
					if(wndInfo and wndInfo.isVisible)then
						exitGame();
					elseif(wndSetting and wndSetting.isVisible)then
						closeOptions();
					elseif(wndNew and wndNew.isVisible)then
						newGame();
					elseif(wndDebug and wndDebug.isVisible)then
						closeDebug();
					end
				end
			end
		end
		return false;
	end
	
	function localGroup:removeAllListeners()
		Runtime:removeEventListener("touch", touchHandler);
		Runtime:removeEventListener( "key", onKeyEvent )
		if(wndSetting)then
			wndSetting:removeAllListeners();
			wndSetting = nil;
		end
		if(wndLang)then
			wndLang:removeAllListeners();
			wndLang = nil;
		end
		if(wndInfo)then
			wndInfo:removeAllListeners();
			wndInfo = nil;
		end
		if(wndNew)then
			wndNew:removeAllListeners();
			wndNew = nil;
		end
		if(wndDebug)then
			wndDebug:removeAllListeners();
			wndDebug = nil;
		end
		if(wndDifficulty)then
			wndDifficulty:removeAllListeners();
			wndDifficulty = nil;
		end
	end
	
	Runtime:addEventListener( "enterFrame", update );
	Runtime:addEventListener( "touch", touchHandler );
	Runtime:addEventListener( "key", onKeyEvent )
	
	return localGroup;
end