----------
-- @author: Sergey Pomorin
-- @skype: j0xflash
----------
module(..., package.seeall);

function new(callback)
	local localGroup = display.newGroup();
	
	local _arButtons = {};
	
	local screen = display.newRect(0, 0, _W/minScale, _H/minScale);
	screen:setFillColor( 0, 0, 0 );
	screen.alpha = 0.5;
	localGroup:insert(screen);
	
	local bg = display.newImage("images/back/bgWindow.png");
	bg.xScale = 0.5;
	bg.yScale = 0.5;
	localGroup:insert(bg);
	
	local tfTitle = createText(getText("options"), 40, {1,1,1})
	tfTitle.x = 0;
	tfTitle.y = - 150;
	localGroup:insert(tfTitle);
	
	local function createButtons()
		local btnMenu = addButtonTexture("btnMenu");
		scaleObjects(btnMenu, 0.35)
		btnMenu.x = -80;
		btnMenu.y = -60;
		localGroup:insert(btnMenu)
		table.insert(_arButtons, btnMenu);
		local btnPlay = addButtonTexture("btnPlay");
		scaleObjects(btnPlay, 0.2)
		btnPlay.x = 80;
		btnPlay.y = btnMenu.y;
		localGroup:insert(btnPlay)
		table.insert(_arButtons, btnPlay);
		local btnRestart = addButtonTexture("btnRestart");
		scaleObjects(btnRestart, 0.35)
		btnRestart.x = btnMenu.x;
		btnRestart.y = 60;
		localGroup:insert(btnRestart)
		table.insert(_arButtons, btnRestart);
		local btnSound = addButtonTexture("btnSound");
		scaleObjects(btnSound, 0.35)
		btnSound.x = btnPlay.x;
		btnSound.y = btnRestart.y;
		localGroup:insert(btnSound)
		table.insert(_arButtons, btnSound);
	end
	createButtons();
	
	local function checkButtons(event)
		for i=1,#_arButtons do
			local item_mc = _arButtons[i];
			local _x, _y = item_mc:localToContent(0, 0); -- localToGlobal
			local dx = event.x - _x;
			local dy = event.y - _y;
			local w = item_mc.w*minScale;
			local h = item_mc.h*minScale;

			if(math.abs(dx)<w/2 and math.abs(dy)<h/2)then
				if(item_mc._selected and event.isPrimaryButtonDown)then
					if(item_mc.img)then
						item_mc.img:stopAtFrame(3);
					end
				elseif(item_mc._selected == false)then
					item_mc._selected = true;
					if(item_mc._over)then
						item_mc._over.alpha = 0.3;
					elseif(item_mc.img)then
						if(event.phase=='began')then
							item_mc.img:stopAtFrame(3);
						else
							item_mc.img:stopAtFrame(2);
						end
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
		if(localGroup.isVisible == false)then
			return;
		end
		local phase = event.phase;
		if(phase=='began')then
			if(options_controls ~= "cursor")then
				checkButtons(event);
			end
		elseif(phase=='moved')then
			if(options_controls ~= "cursor")then
				checkButtons(event);
			end
		else
			for i=1,#_arButtons do
				local item_mc = _arButtons[i];
				if(item_mc._selected)then
					item_mc._selected = false;
					if(item_mc._over)then
						item_mc._over.alpha = 0;
					elseif(item_mc.img)then
						item_mc.img:stopAtFrame(1);
					end
					if(item_mc.onRelease)then
						item_mc:onRelease();
						soundPlay("click_approve");
						return true;
					elseif(item_mc.act == "btnPlay")then
						soundPlay("click_approve");
						callback();
						return true;
					end
				end
			end
		end
	end
	
	
	function localGroup:removeAllListener()
		Runtime:removeEventListener("touch", touchHandler);
	end
	
	Runtime:addEventListener( "touch", touchHandler );
	
	return localGroup;
end