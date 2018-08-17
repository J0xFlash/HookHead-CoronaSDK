module(..., package.seeall);

function new()
	local localGroup = display.newGroup();
	local unlockAchievments = {};
	local unlockRewardsPer = {};
	local arAchiev = {};
	local gamecenterApple={};
	local gamecenterGoogle={};
	local gamecenterSteam={};
	local rewardsSubmitedSuccess = {};
	local arValue = {};
	local _value = nil;
	local _timerAchiev = nil;
	local _timerNext = nil;
	local _callbackGoogle = nil;
	local _countAchiv = 0;
	local _show = true;
	local _gs_id = nil;	
	local _urlImage = "achievement/image/";
	
	function localGroup:getRewardsSubmitedSuccess()
		return rewardsSubmitedSuccess;
	end
	function localGroup:setRewardsSubmitedSuccess(val)
		rewardsSubmitedSuccess = val;
	end
	
	local function eliteAchievementReqestHandler(evt)
		local gs_id = evt.data.identifier;
		if(unlockRewardsPer[gs_id] == 100)then
			rewardsSubmitedSuccess[gs_id] = true;
			if(options_debug)then
				show_msg('reward_unlocked:'..gs_id)
			end
		end
	end
	
	local function googleAchievementReqestHandler(event)
		show_msg('googleAchievementReqestHandler:')
		if not event.isError then
			local gs_id = event.achievementId;
			if(unlockRewardsPer[gs_id] == 100)then
				rewardsSubmitedSuccess[gs_id] = true;
				if(options_debug)then
					show_msg('reward_unlocked:'..gs_id)
				end
			end
		end
	end
	
	-- Google Play Games Services initialization/login listener		
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
										_G.user_obj['google_login'] = true;
										_G.login_obj['google_user'] = event3.players[1];
										_G.login_obj['google_user_id'] = event3.players[1].id;
										_G.login_obj['google_user_name'] = event3.players[1].name;
										_G.user_obj["userId"] = _G.login_obj['google_user_id'];
										-- https://docs.coronalabs.com/plugin/gpgs/players/type/Player/index.html
										if(_callbackGoogle)then
											_callbackGoogle();
										end
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
	
	-- Apple Game Center initialization/login listener
	local function gcInitListener( event )
		if event.data then  -- Successful login event
			print( Json.prettify(event) )
		end
	end
	
	-- Initialize game network based on platform
	if ( globalData.gpgs ) then
		-- Initialize Google Play Games Services
		-- globalData.gpgs.init( gpgsInitListener )
	elseif ( globalData.gameCenter ) then
		-- Initialize Apple Game Center
		globalData.gameCenter.init( "gamecenter", gcInitListener )
	end
	
	function localGroup:initGoogle(callback)
		-- Initialize game network based on platform
		if ( globalData.gpgs ) then
			_callbackGoogle = callback;
			-- Initialize Google Play Games Services
			globalData.gpgs.init( gpgsInitListener )
		end
	end
	
	local function nextAchievement()
		if(_timerNext ~= nil)then
			timer.cancel(_timerNext);
			_timerNext = nil;
		end
		
		show(arValue[1]);
	end
	
	local function hideAchievement()
		if(_timerAchiev ~= nil)then
			timer.cancel(_timerAchiev);
			_timerAchiev = nil;
		end
		transition.to( arAchiev[_value], { time=500, alpha = 0 } );
		_countAchiv = _countAchiv - 1;
		_show = true;
		table.remove(arValue, 1);
		_timerNext = timer.performWithDelay( 500, nextAchievement, 1);
		
	end
	
	local function showAchievement(_value)
		transition.to( arAchiev[_value], { time=500, alpha = 1 } );
		_timerAchiev = timer.performWithDelay( 2000, hideAchievement, 1);
	end
	
	function show(value)
		if(_show == true and _countAchiv>0)then
			_show = false;
			_value = value;
			showAchievement(_value);
		end
	end
	
	function network_submit_achievement(gs_id, per)		
		if(options_debug)then
			show_msg('reward_sent:'..gs_id..' ('..per..'%)')
		end
		if(globalData.gameCenter)then
			globalData.gameCenter.request( "unlockAchievement",
			{
					achievement =
					{
							identifier=gs_id,
							percentComplete=per,
							showsCompletionBanner=false
					},
					listener=eliteAchievementReqestHandler
			})
		elseif(globalData.gpgs)then
			globalData.gpgs.achievements.unlock( 
			{
				achievementId = gs_id, 
				listener = googleAchievementReqestHandler
			})
		elseif(steamworks)then
			_gs_id = gs_id;
			steamworks.setAchievementUnlocked(gs_id)
		end
	end
	
	function localGroup:progresAchievement(value, per)
		-- to make sure that value is [0..100]
		per = math.max(per,0);
		per = math.min(per,100);
		
		per = math.floor(per*100)/100;
		
		local gs_id = gamecenterApple[value];
		unlockRewardsPer[gs_id] = per;
		if(options_gamecenter)then network_submit_achievement(gs_id, per); end
	end
	
	function localGroup:createAchievement(value)
		if(gamecenterApple[value] and optionsBuild == "ios")then
		elseif(gamecenterGoogle[value] and optionsBuild == "android")then
		elseif(gamecenterSteam[value] and (optionsBuild == "windows" or optionsBuild == "osx"))then
		else
			-- print('ERROR:I DONT HAVE THIS REWARD');
			return false
		end
		local vImg = value;
		if(value < 10)then
			vImg = "0" .. value;
		end
		
		local gs_id = nil;
		if(optionsBuild == "ios")then
			gs_id = gamecenterApple[value];
		elseif(optionsBuild == "android")then
			gs_id = gamecenterGoogle[value];
		elseif(optionsBuild == "windows" or optionsBuild == "osx")then
			gs_id = gamecenterSteam[value];
		end
		
		if(unlockRewardsPer[gs_id])then
			unlockRewardsPer[gs_id] = 100;
		end
		
		local gc = (globalData and (globalData.gpgs or globalData.gameCenter));
		if((gc or 
		optionsBuild == "windows" or 
		optionsBuild == "osx")
		and rewardsSubmitedSuccess[gs_id] ~= true)then
			network_submit_achievement(gs_id, 100);
		end
		
		if(unlockAchievments[value] == 1)then
			return;
		end
		
		unlockAchievments[value] = 1;
		localGroup:setAchievments(unlockAchievments);
		_countAchiv = _countAchiv + 1;
		table.insert(arValue, value);
	end
	
	function localGroup:addItemGCID(item_id, apple_id, google_id, steam_id)
		gamecenterApple[item_id] = apple_id;
		gamecenterGoogle[item_id] = google_id;
		gamecenterSteam[item_id] = steam_id;
		table.insert(unlockAchievments, 0);
	end
	
	function localGroup:setAchievments(value)
		local newAch = #unlockAchievments - #value;
		if(newAch > 0)then
			for i = 1, newAch do
				table.insert(value, 0);
			end
		end
		unlockAchievments = value;
	end
	function localGroup:getAchievments()
		return unlockAchievments;
	end
	function localGroup:getUrl()
		return _urlImage;
	end
	
	function localGroup:onUserProgressUpdated(event)
		for i in pairs(gamecenterSteam) do
			local gs_id = gamecenterSteam[i];
			if(gs_id)then
				local achievementInfo = steamworks.getAchievementInfo(gs_id, event.userSteamId)
				if ( achievementInfo ) then
					if ( achievementInfo.unlocked ) then
						rewardsSubmitedSuccess[gs_id] = true;
					end
				end
			end
		end
	end
	
	return localGroup;
end