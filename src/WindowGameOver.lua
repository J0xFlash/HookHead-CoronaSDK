----------
-- @author: Sergey Pomorin
-- @skype: j0xflash
----------
module(..., package.seeall);

function new(callRestart, callMenu)
	local localGroup = display.newGroup();
	
	local _arButtons = {};
	local btnSoundOff = nil;
	local btnSound = nil;
	
	local screen = display.newRect(0, 0, _W/minScale, _H/minScale);
	screen:setFillColor( 0, 0, 0 );
	screen.alpha = 0.5;
	localGroup:insert(screen);
	
	local bg = display.newImage("images/back/bgWindow.png");
	bg.xScale = 0.5;
	bg.yScale = 0.5;
	localGroup:insert(bg);
	
	local tfTitle = createText(getText("game_over"), 40, {128/255,137/255,137/255})
	tfTitle.x = 0;
	tfTitle.y = - 150;
	localGroup:insert(tfTitle);
	
	local tfTitle = createText(getText("your_score"), 30, {195/255,120/255,91/255})
	tfTitle.x = 0;
	tfTitle.y = 70;
	localGroup:insert(tfTitle);
	local tfTitle = createText(getItemCount("score"), 40, {128/255,137/255,137/255})
	tfTitle.x = 0;
	tfTitle.y = 125;
	localGroup:insert(tfTitle);
	-- local tfTitle = createText(getText("dev_evgeny_titov"), 20, {128/255,137/255,137/255})
	-- tfTitle.x = 0;
	-- tfTitle.y = 130;
	-- localGroup:insert(tfTitle);
	
	local function refreshSound()
		btnSoundOff.isVisible = (greenSounds:getMusicBol() == false);
		btnSound.isVisible = greenSounds:getMusicBol();
	end
	
	local function createButtons()
		local scale = 0.35;
		local btnRestart = addButtonTexture("btnRestart");
		scaleObjects(btnRestart, scale)
		btnRestart.x = -130;
		btnRestart.y = -40;
		localGroup:insert(btnRestart)
		table.insert(_arButtons, btnRestart);
		btnSoundOff = addButtonTexture("btnSoundOff");
		scaleObjects(btnSoundOff, scale)
		btnSoundOff.x = 0;
		btnSoundOff.y = btnRestart.y;
		localGroup:insert(btnSoundOff)
		table.insert(_arButtons, btnSoundOff);
		btnSound = addButtonTexture("btnSound");
		scaleObjects(btnSound, scale)
		btnSound.x = 0;
		btnSound.y = btnRestart.y;
		localGroup:insert(btnSound)
		table.insert(_arButtons, btnSound);
		local btnMenu = addButtonTexture("btnMenu");
		scaleObjects(btnMenu, scale)
		btnMenu.x = 130;
		btnMenu.y = btnRestart.y;
		localGroup:insert(btnMenu)
		table.insert(_arButtons, btnMenu);
		
		refreshSound();
	end
	createButtons();
	
	local function checkButtons(event)
		for i=1,#_arButtons do
			local item_mc = _arButtons[i];
			local _x, _y = item_mc:localToContent(0, 0); -- localToGlobal
			local dx = event.x - _x;
			local dy = event.y - _y;
			local w = item_mc.w*localGroup.xScale;
			local h = item_mc.h*localGroup.xScale;

			if(math.abs(dx)<w/2 and math.abs(dy)<h/2)then
				if(item_mc._selected and event.isPrimaryButtonDown and item_mc.isVisible)then
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
					elseif(item_mc.act == "btnRestart")then
						soundPlay("click_approve");
						callRestart();
						return true;
					elseif(item_mc.act == "btnMenu")then
						soundPlay("click_approve");
						callMenu();
						return true;
					elseif(item_mc.act == "btnSound" or item_mc.act == "btnSoundOff")then
						soundPlay("click_approve");
						musicSwith();
						refreshSound();
						return true;
					end
				end
			end
		end
	end
	
	
	function localGroup:removeAllListeners()
		Runtime:removeEventListener("touch", touchHandler);
	end
	
	Runtime:addEventListener( "touch", touchHandler );
	
	return localGroup;
end