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
	local _arName = {"Alex", "Boris", "Daniil", "Linda", "Nikitas", "Sergey"}
	local bWindow = false; -- открыто окно или нет
	
	localGroup:insert(backGroup);
	localGroup:insert(faceGroup);
	
	local bg = display.newImage("images/back/bgMenu.jpg");
	bg.xScale = maxScale;
	bg.yScale = maxScale;
	bg.x = _W/2;
	bg.y = _H/2;
	backGroup:insert(bg);

	local btnSoundOff = addButtonTexture("btnSoundOff");
	scaleObjects(btnSoundOff, 0.6*scaleGraphics)
	btnSoundOff.x = _W - btnSoundOff.w/2 - 25*scaleGraphics;
	btnSoundOff.y = _H - btnSoundOff.h/2 - 25*scaleGraphics;
	faceGroup:insert(btnSoundOff)
	table.insert(arButtons, btnSoundOff);
	local btnSound = addButtonTexture("btnSound");
	scaleObjects(btnSound, 0.6*scaleGraphics)
	btnSound.x = btnSoundOff.x;
	btnSound.y = btnSoundOff.y;
	faceGroup:insert(btnSound)
	table.insert(arButtons, btnSound);
	
	local function refreshSound()
		btnSoundOff.isVisible = (greenSounds:getMusicBol() == false);
		btnSound.isVisible = greenSounds:getMusicBol();
	end
	refreshSound();

	local function createBackground()
		local size = 254*scaleGraphics;
		local countX = math.ceil(_W/size) + 1;
		local countY = math.ceil(_H/size) + 1;
		local count = countX * countY;
		local posX = 0;
		local posY = 0;
		_countTileY = countY;
		
		for i=1, countY do
			local tileGroup = display.newGroup();
			posX = 0;
			
			for j=1, countX do
				local tile = addObj("tileBg");
				tile.xScale = scaleGraphics;
				tile.yScale = scaleGraphics;
				tile.w = tile.width*tile.xScale;
				tile.h = tile.height*tile.yScale;
				tile.x = tile.w*posX;
				tile.y = 0;
				tileGroup:insert(tile);
				posX = posX + 1;
			end
			tileGroup.y = tileGroup.height*posY;
			backGroup:insert(tileGroup);
			posY = posY + 1;
		end
	end
	createBackground()

	local function createTeam()
		local tfTitle = createText("Select Hero", 120*scaleGraphics, {255/255,255/255,255/255})
		tfTitle.x = _W/2;
		tfTitle.y = 250*scaleGraphics;
		localGroup:insert(tfTitle);
		print("scaleGraphics:", scaleGraphics)
		local posX = 0
		local posY = 0
		for i=1, #_arName do
			local name = _arName[i]
			local hero = addButtonTexture("qr" .. name);
			hero.name = name
			hero.xScale = scaleGraphics
			hero.yScale = scaleGraphics
			hero.x = _W/2 - 350*scaleGraphics + 350*scaleGraphics*posX
			hero.y = _H/2 - 350*scaleGraphics + 700*scaleGraphics*posY
			localGroup:insert(hero);
			table.insert(arButtons, hero);
			posX = posX + 1
			if(i%3==0)then
				posX = 0
				posY = posY + 1
			end
		end
	end
	createTeam()
	
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
					elseif(item_mc.act == "btnPlay")then
						soundPlay("click_approve");
						showGame();
						return true;
					elseif(item_mc.act == "btnSound" or item_mc.act == "btnSoundOff")then
						soundPlay("click_approve");
						musicSwith();
						refreshSound();
						return true;
					else
						soundPlay("click_approve");
						login_obj["hero"] = item_mc.name
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
		if(phase == 'up' and (keyName == "back" or keyName == "escape")) then
			localGroup:removeAllListeners();
			native.requestExit();
			return true;
		end
		return false;
	end
	
	function localGroup:removeAllListeners()
		Runtime:removeEventListener("touch", touchHandler);
		Runtime:removeEventListener( "key", onKeyEvent )
	end
	
	Runtime:addEventListener( "touch", touchHandler );
	Runtime:addEventListener( "key", onKeyEvent )
	
	return localGroup;
end