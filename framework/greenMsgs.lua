module(..., package.seeall);
-- greenMsgs 1.0

function new()
	local _mc = display.newGroup();
	local _list = {};
	local old_time = system.getTimer();
	
	function _mc:show_msg(txt)
		local bgH = 40*scaleGraphics
		local dtxt = display.newText( txt, 0, 0, nil, 32*scaleGraphics);
		dtxt.x = dtxt.width/2 + 200*scaleGraphics;
		dtxt:setFillColor(1, 1, 1);

		local dark_mc = display.newRect( 0, 0, dtxt.width, bgH);
		dark_mc.x = dark_mc.width/2 + 200*scaleGraphics;
		dark_mc:setFillColor(0,0,0);
		dark_mc.alpha = 0.8;
		
		local msg_mc=display.newGroup();
		msg_mc.ttl = 6000+#_list*500;
		msg_mc.y = #_list*bgH;
		msg_mc:insert(dark_mc);
		msg_mc:insert(dtxt);
		
		--_mc.l = msgs_mc.l + 1;
		table.insert(_list, msg_mc);
		_mc:insert(msg_mc);
		
		if(#_list == 1)then
			old_time = system.getTimer();
			Runtime:removeEventListener("enterFrame", turn);
			Runtime:addEventListener("enterFrame", turn);
		end
	end
	
	function turn(evt)
		local dtime = system.getTimer() - old_time;
		old_time = system.getTimer();
		for i=1,#_list do
			local msg_mc = _list[i];
			msg_mc.ttl = msg_mc.ttl - dtime;
			if(msg_mc.ttl <0)then
				local new_alpha = msg_mc.alpha - dtime/1500;
				if(new_alpha<0)then
					msg_mc.alpha = 0;
				else
					msg_mc.alpha = new_alpha;
				end
			end
		end
		if(#_list>0)then
			if(_list[1].alpha <=0)then
				table.remove(_list, 1);
				
				if(#_list>0)then
					for i=1,#_list do
						local msg_mc = _list[i];
						msg_mc.y = (i-1)*30;
					end
				end
			end
		end
		if(#_list == 0)then
			Runtime:removeEventListener("enterFrame", turn);
		end
	end
	
	old_time = system.getTimer();
	Runtime:removeEventListener("enterFrame", turn);
	Runtime:addEventListener("enterFrame", turn);
	
	return _mc
end