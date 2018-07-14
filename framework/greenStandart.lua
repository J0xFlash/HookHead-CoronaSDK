-- standart methods
standart = {};
standart.split = function(str, pat)
	local t = {};  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pat;
	local last_end = 1;
	local s, e, cap = str:find(fpat, 1);
	while s do
		if (s ~= 1 or cap ~= "") then
			table.insert(t, cap);
		end
		last_end = e + 1;
		s, e, cap = str:find(fpat, last_end);
	end
	if(last_end <= #str) then
		cap = str:sub(last_end);
		table.insert(t, cap);
	end
	return t;
end
standart.splice = function(t,i,length, replaceWith)
	if(i <= 0 and length == nil)then
		for r=0, math.abs(i) do
			table.remove(t);
		end
		return;
	end
	if(length == nil)then
		return;
	end
	if (length > 0) then
		for r=0, length do
			if(r < length) then
				table.remove(t,i + r)
			end
		end
	end
	if(replaceWith) then
		table.insert(t,i,replaceWith)
	end
	local count = 1
	local tempT = {}
	for i=1, #t do
		if t[i] then
			tempT[count] = t[i]
			count = count + 1
		end
	end
	t = tempT
end
standart.slice = function(values,i1,i2)
	local res = {}
	local n = #values
	-- default values for range
	i1 = i1 or 1
	i2 = i2 or n
	if i2 < 0 then
		i2 = n + i2 + 1
	elseif i2 > n then
		i2 = n
	end
	if i1 < 1 or i1 > n then
		return {}
	end
	local k = 1
	for i = i1,i2 do
		res[k] = values[i]
		k = k + 1
	end
	return res
end
standart.hitTest = function(mc,rr,tx,ty)
	if(mc.x and mc.y)then
		local dx, dy = mc.x - tx, mc.y - ty;
		local dd = dx*dx+dy*dy;
		if(dd<rr)then
			return true
		end
	end
	return false
end
standart.hitTestRect = function(mc, w, h, tx, ty)
	if(tx>mc.x-w/2 and tx<mc.x+w/2)then
		if(ty>mc.y-h/2 and ty<mc.y+h/2)then
			return true;
		end
	end
	return false;
end
standart.getDD = function(x1, y1, x2, y2)
	local dx = x2 - x1;
	local dy = y2 - y1;
	return dx*dx+dy*dy;
end
standart.getDDPoint = function(obj1, obj2)
	local dx = obj2.x - obj1.x;
	local dy = obj2.y - obj1.y;
	return dx*dx+dy*dy;
end
standart.hasCollidedRect = function(obj1, obj2)
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return ( left or right ) and ( up or down )
end
standart.hasCollidedCircle = function(obj1, obj2)
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local dx = obj1.x - obj2.x
    local dy = obj1.y - obj2.y
 
    local distance = math.sqrt( dx*dx + dy*dy )
    local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)
 
    if ( distance < objectSize ) then
        return true
    end
    return false
end
standart.isNumber = function(value)
	if(value == tonumber(value))then
		return true;
	else
		return false;
	end
end
standart.isNaN = function(value)
	if(standart.isNumber(value))then
		return false;
	else
		return true;
	end
end
standart.Boolean = function(value)
	if(tonumber(value) == 1)then
		return true;
	else
		return false;
	end
end
standart.mathRound = function(value)
	if(value%1 >= 0.5)then
		return math.ceil(value);
	else
		return math.floor(value);
	end
end
standart.concatTables = function(t1, t2)
	local t0 = {};
	for k,v in ipairs(t1) do
		table.insert(t0, v)
	end
	for k,v in ipairs(t2) do
		table.insert(t0, v)
	end

	return t0
end
standart.tablelength = function(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
standart.toFixed = function(value, precision)
	precision = math.pow(10, precision);
	return standart.mathRound(value * precision) / precision;
end
standart.typeof = function(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end
standart.toDegrees = function(angle)
  return angle * (180 / math.pi);
end
standart.toRadians = function(angle)
  return angle * (math.pi / 180);
end