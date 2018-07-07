----------
-- @author: Sergey Pomorin
-- @skype:
----------
module(..., package.seeall);

function new()
	local localGroup = display.newGroup();
	local backGroup = display.newGroup();
	local faceGroup = display.newGroup();
	
	local arButtons = {};
	local bWindow = false; -- открыто окно или нет
	
	localGroup:insert(backGroup);
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
	
	
	-------------- touchHandler ----------------
	local function checkButtons(event)
		if(bWindow)then
			return;
		end
		for i=1,#arButtons do
			local item_mc = arButtons[i];
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
			for i=1,#arButtons do
				local item_mc = arButtons[i];
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
				if(bWindow)then
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
				if(bWindow)then
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
	
	Runtime:addEventListener( "touch", touchHandler );
	Runtime:addEventListener( "key", onKeyEvent )
	
	return localGroup;
end