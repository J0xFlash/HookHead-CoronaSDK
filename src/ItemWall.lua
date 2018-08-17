----------
-- @author: Sergey Pomorin
-- @skype: j0xflash
----------
module(..., package.seeall);

function new(_id, _count, _type)
	local movieclip = display.newGroup();
	local blockGroup = display.newGroup();
	local scale = 0.5;
	local side = "Left";
	if(_type == 0)then
		side = "Right";
	end
	local size = 248*scale;
	local invert = false;
	local exposure = 1.2;
	
	movieclip:insert(blockGroup);
	
	local rect = display.newRect( 0, 0, size, size*(_count-1) )
	rect:setFillColor(1,0,0, 0.5);
	rect.isVisible = false;
	movieclip:insert(rect);
	movieclip.rect = rect;
	movieclip.id = _id;
	
	function movieclip:setSize(value)
		_count = value;
		while (blockGroup.numChildren>0) do
			blockGroup[1]:removeSelf();
		end
		
		local wallTop = addObj("wall"..side.."Top");
		wallTop.xScale = scale;
		wallTop.yScale = scale;
		wallTop.y = - size*(_count + 1)/2; 
		blockGroup:insert(wallTop);
		for i=1, _count do
			local wallMiddle = addObj("wall"..side.."Middle");
			wallMiddle.xScale = scale;
			wallMiddle.yScale = scale;
			wallMiddle.y = wallTop.y + size*i; 
			blockGroup:insert(wallMiddle);
			if(invert)then
				wallMiddle.fill.effect = "filter.exposure"
				wallMiddle.fill.effect.exposure = exposure
			end
		end
		local wallDown = addObj("wall"..side.."Down");
		wallDown.xScale = scale;
		wallDown.yScale = scale;
		wallDown.y = wallTop.y + size*(_count + 1); 
		blockGroup:insert(wallDown);
		
		if(invert)then
			wallTop.fill.effect = "filter.exposure"
			wallTop.fill.effect.exposure = exposure
			wallDown.fill.effect = "filter.exposure"
			wallDown.fill.effect.exposure = exposure
		end
		
		rect.height = size*(_count-1);
	end
	
	function movieclip:invertFilter(value)
		invert = value;
		for i=1, blockGroup.numChildren do
			local obj = blockGroup[i];
			if(value)then
				obj.fill.effect = "filter.exposure"
				obj.fill.effect.exposure = exposure
			else
				obj.fill.effect = nil;
			end
		end
	end
	
	movieclip:setSize(_count);
	
	if(options_debug)then
		rect.isVisible = true;
		local point = display.newRect( -5, -5, 10, 10 )
		point:setFillColor(1,1,0, 0.5);
		movieclip:insert(point);
		
		local tfId = createText(_id, 80, {1,1,1})
		tfId.x = 0;
		tfId.y = 0;
		movieclip:insert(tfId);
	end
	
	return movieclip;
end