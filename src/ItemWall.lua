----------
-- @author: Sergey Pomorin
-- @skype: j0xflash
----------
module(..., package.seeall);

function new(_id, _count, _type)
	local movieclip = display.newGroup();
	local scale = 0.5;
	local side = "Left";
	if(_type == 0)then
		side = "Right";
	end
	local size = 248*scale;
	
	local wallTop = addObj("wall"..side.."Top");
	wallTop.xScale = scale;
	wallTop.yScale = scale;
	wallTop.y = - size*(_count + 1)/2; 
	movieclip:insert(wallTop);
	for i=1, _count do
		local wallMiddle = addObj("wall"..side.."Middle");
		wallMiddle.xScale = scale;
		wallMiddle.yScale = scale;
		wallMiddle.y = wallTop.y + size*i; 
		movieclip:insert(wallMiddle);
	end
	local wallDown = addObj("wall"..side.."Down");
	wallDown.xScale = scale;
	wallDown.yScale = scale;
	wallDown.y = wallTop.y + size*(_count + 1); 
	movieclip:insert(wallDown);
	
	local rect = display.newRect( 0, 0, size/2, size*_count )
	rect:setFillColor(1,0,0, 0.5);
	rect.isVisible = false;
	movieclip:insert(rect);
	movieclip.rect = rect;
	
	if(options_debug)then
		rect.isVisible = true;
		local point = display.newRect( -5, -5, 10, 10 )
		point:setFillColor(1,1,0, 0.5);
		movieclip:insert(point);
	end
	
	return movieclip;
end