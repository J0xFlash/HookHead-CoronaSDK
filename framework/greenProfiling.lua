module(..., package.seeall);

function new()
	local _mc = display.newGroup();
	
	local fps_val =0;
	local fps_t = 0;
	local memUsageMax=0;
	local textureMemMax =0;

	local _this_w = 120;
	local _this_h = 90;
	
	local tfDebug5 = display.newText( "", 0, -30, nil, 20 );
	tfDebug5:setFillColor( 1,1,1); 
	local tfMemory1 = display.newText( "", 0, 0, nil, 20 );
	tfMemory1:setFillColor( 1,1,1); 
	local tfMemory2 = display.newText( "", 0, 30, nil, 20 );
	tfMemory2:setFillColor( 1,1,1); 
	local dark_mc = display.newRect( 0, 0, _this_w, _this_h);
	dark_mc:setFillColor(0,0,0);
	dark_mc.alpha = 0.8;
	
	--[[local fpsss = 0
	local function checkMemory()
		collectgarbage('collect')
		local memUsage_str = string.format('MEMORY = %.3f KB', collectgarbage('count'))
		tfDebug5.text = 'fps: '..fpsss;
		tfMemory2.text='TEXTURE = ' .. (system.getInfo('textureMemoryUsed') / (1024 * 1024));
	end
	local getTimer = system.getTimer
	local last = getTimer()

	local function enterFrame()
		local cur = getTimer()
		local dt = cur - last
		last = cur
		fpsss = 1000 / dt

	end
	Runtime:addEventListener("enterFrame", enterFrame)
	timer.performWithDelay(1000, checkMemory, 0)]]

	local old_time = system.getTimer();
	function turn()
		local dtime = system.getTimer() - old_time;
		old_time = system.getTimer();
		fps_val = fps_val+1;
		fps_t = fps_t + dtime;
		if(fps_t > 1000)then
			fps_t = fps_t - 1000;
			tfDebug5.text = 'fps: '..fps_val;
			fps_val =0;
			-------
			local curUsage = math.floor(collectgarbage("count")/1024);
			memUsageMax = math.max(curUsage,memUsageMax);
			local curTextureMemMax = math.floor(system.getInfo( "textureMemoryUsed" ) / (1024*1024));
			textureMemMax = math.max(curTextureMemMax,textureMemMax);
			tfMemory1.text=( "Mb: " .. curUsage..'/'..memUsageMax );
			tfMemory2.text=( "tex: " .. curTextureMemMax..'/'..textureMemMax );
		end
	end
	
	Runtime:addEventListener( "enterFrame", turn );
	
	_mc:insert(dark_mc);
	_mc:insert(tfMemory1);
	_mc:insert(tfMemory2);
	_mc:insert(tfDebug5);
	return _mc
end