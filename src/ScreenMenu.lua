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
	
	local bg = display.newImage("images/back/bgMenu.jpg");
	bg.xScale = maxScale;
	bg.yScale = maxScale;
	bg.x = _W/2;
	bg.y = _H/2;
	backGroup:insert(bg);
	local logo = display.newImage("images/back/logoGame.png");
	logo.xScale = scaleGraphics;
	logo.yScale = scaleGraphics;
	logo.x = _W/2;
	logo.y = 350*scaleGraphics;
	backGroup:insert(logo);
	
	local btnStart = addButtonTexture("btnPlay");
	scaleObjects(btnStart, 0.75*scaleGraphics);
	btnStart.x = _W/2;
	btnStart.y = _H - 300*scaleGraphics;
	faceGroup:insert(btnStart)
	table.insert(arButtons, btnStart);
	
	local btnExit = addButtonTexture("btnExit");
	scaleObjects(btnExit, 0.6*scaleGraphics)
	btnExit.x = btnExit.w/2 + 25*scaleGraphics;
	btnExit.y = _H - btnExit.h/2 - 25*scaleGraphics;
	faceGroup:insert(btnExit)
	table.insert(arButtons, btnExit);
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
	local btnGoogle = addButtonTexture("btnGoogle");
	scaleObjects(btnGoogle, 0.6*scaleGraphics)
	btnGoogle.x = btnSoundOff.x;
	btnGoogle.y = btnSoundOff.y - btnSoundOff.h/2 - btnGoogle.h/2 - 50*scaleGraphics;
	faceGroup:insert(btnGoogle)
	table.insert(arButtons, btnGoogle);
	
	local function refreshSound()
		btnSoundOff.isVisible = (greenSounds:getMusicBol() == false);
		btnSound.isVisible = greenSounds:getMusicBol();
	end
	refreshSound();
	
	local function gpgsInitListener( event1 )
		if not event1.isError then
			if ( event1.name == "init" ) then  -- Initialization event
				-- Attempt to log in the user
				globalData.gpgs.login(
				{
					userInitiated = true,
					listener = function(event2)
						if (event2.isError) then
							show_msg(event2.errorMessage);
							print("Error on login", event2.errorCode, event2.errorMessage)
						else
							globalData.gpgs.players.load({
								listener = function(event3)
									if not event3.isError then
										_G.login_obj['google_user'] = event3.players[1];
										_G.login_obj['google_user_id'] = event3.players[1].id;
										_G.login_obj['google_user_name'] = event3.players[1].name;
										-- https://docs.coronalabs.com/plugin/gpgs/players/type/Player/index.html
										btnGoogle.isVisible = false;
									else
										show_msg(event3.errorMessage);
										print("could not get player id")
									end
								end
							})
						end
					end
				}
			)
			end
		end
	end
	
	local function initGoogle()
		-- Initialize game network based on platform
		if ( globalData.gpgs ) then
			-- Initialize Google Play Games Services
			globalData.gpgs.init( gpgsInitListener )
		end
	end
	
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
					elseif(item_mc.act == "btnExit")then
						soundPlay("click_approve");
						localGroup:removeAllListeners();
						native.requestExit();
						return true;
					elseif(item_mc.act == "btnGoogle")then
						soundPlay("click_approve");
						initGoogle();
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