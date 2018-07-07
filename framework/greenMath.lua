module(..., package.seeall);

function new()
	local CMathExt = display.newGroup();
	
	function CMathExt:InterLineLine(p1, p2, p3, p4)
		local distAB = nil;
		local theCos = nil;
		local theSin = nil;
		local newX = nil;
		local ABpos = nil;
		--  Fail if either line segment is zero-length.
		local Ax, Ay, Bx, By, Cx, Cy, Dx, Dy = nil, nil, nil, nil, nil, nil, nil, nil;
		Ax = p1.x;
		Ay = p1.y;
		Bx = p2.x;
		By = p2.y;
		Cx = p3.x;
		Cy = p3.y;
		Dx = p4.x;
		Dy = p4.y;
		--  Fail if either line segment is zero-length.
		if (Ax == Bx and Ay == By or Cx == Dx and Cy == Dy) then
			return nil;-- -1;
		end
		--  Fail if the segments share an end-point.                  
		if (Ax == Cx and Ay == Cy or Bx == Cx and By == Cy or 
			Ax == Dx and Ay == Dy or Bx == Dx and By == Dy) then
			return nil;-- -2;
		end
		--  (1) Translate the system so that point A is on the origin.                  
		Bx = Bx - Ax;
		By = By - Ay;
		Cx = Cx - Ax;
		Cy = Cy - Ay;
		Dx = Dx - Ax;
		Dy = Dy - Ay;
		--  Discover the length of segment A-B.
		distAB = math.sqrt(Bx*Bx+By*By);
		--  (2) Rotate the system so that point B is on the positive X axis.
		theCos = Bx/distAB;
		theSin = By/distAB;
		newX = Cx*theCos+Cy*theSin;
		Cy = Cy*theCos-Cx*theSin;
		Cx = newX;
		newX = Dx*theCos+Dy*theSin;
		Dy = Dy*theCos-Dx*theSin;
		Dx = newX;
		--  Fail if segment C-D doesn't cross line A-B.
		if (Cy<0 and Dy<0 or Cy>=0 and Dy>=0) then
			return nil;-- -3;
		end
		-- (3) Discover the position of the intersection point along line A-B.                  
		ABpos = Dx+(Cx-Dx)*Dy/(Dy-Cy);
		--  Fail if segment C-D crosses line A-B outside of segment A-B.
		if (ABpos<0 or ABpos>distAB) then
			return nil;-- -4;
		end
		--  (4) Apply the discovered position to line A-B in the original coordinate system.    
		local oX = Ax+ABpos*theCos;
		local oY = Ay+ABpos*theSin;
		--  Success.
		return {x=oX, y=oY};
	end
	
	function CMathExt:InterLineSqr(p1, p2, p3, r)
		local res = {};
		local x1 = p3.x-r;
		local x2 = p3.x+r;
		local y1 = p3.y-r;
		local y2 = p3.y+r;
		local dx = p1.x-p2.x;
		local dy = p1.y-p2.y;
		local dd = dx*dx+dy*dy;
		
		local inter = nil;
		inter = CMathExt:InterLineLine(p1, p2, {x=x1, y=y1}, {x=x1, y=y2});
		if (inter) then
			table.insert(res, inter);
		end
		inter = CMathExt:InterLineLine(p1, p2, {x=x1, y=y1}, {x=x2, y=y1});
		if (inter) then
			table.insert(res, inter);
		end
		inter = CMathExt:InterLineLine(p1, p2, {x=x2, y=y2}, {x=x2, y=y1});
		if (inter) then
			table.insert(res, inter);
		end
		inter = CMathExt:InterLineLine(p1, p2, {x=x2, y=y2}, {x=x1, y=y2});
		if (inter) then
			table.insert(res, inter);
		end
		
		return res;
	end
	
	local function get_dd(p1, p2)
		local dx=p2.x - p1.x;
		local dy=p2.y - p1.y;
		return dx*dx+dy*dy;
	end
	
	function CMathExt:circleBySegment(p1, p2, sc, radius)
		local a = (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y);
		local b = 2 * ((p2.x - p1.x) * (p1.x - sc.x) + (p2.y - p1.y) * (p1.y - sc.y));
		local c = sc.x * sc.x  + sc.y * sc.y + p1.x * p1.x + p1.y * p1.y - 
					2 * (sc.x * p1.x + sc.y * p1.y) - radius * radius;
		
		-- т.е. если если есть отрицательные корни, то пересечение есть. 
		-- анализируем теорему виета и формулу корней
		-- на предмет отрицательных корней
		if ( - b < 0)then
			return (c < 0);
		end
		
		if ( - b < (2 * a))then
			return (4 * a * c - b * b < 0);
		end
		
		return (a + b + c < 0);
	end
	
	function CMathExt:InterLineCir(p1, p2, sc, sc_r)
		local EPS = 0.00000001;
		
		local rr=sc_r*sc_r;
		local pd1 = get_dd(p1, sc);--inside circe p1
		local pd2 = get_dd(p2, sc);--inside circe p1
		if(pd1>rr and pd2>rr)then
			return {};
		end
		local dp = {};
		
		dp.x = p2.x-p1.x;
		dp.y = p2.y-p1.y;
		local a = dp.x*dp.x+dp.y*dp.y;
		if (math.abs(a)<EPS) then
			return {};
		end
		local b = 2*(dp.x*(p1.x-sc.x)+dp.y*(p1.y-sc.y));
		local c = sc.x*sc.x+sc.y*sc.y;
		c = c + p1.x*p1.x+p1.y*p1.y;
		c = c - 2*(sc.x*p1.x+sc.y*p1.y);
		c = c - sc_r*sc_r;
		local bb4ac = b*b-4*a*c;
		if (bb4ac<0) then
			return {};
		else
			local mu1 = (-b+math.sqrt(bb4ac))/(2*a);
			local mu2 = (-b-math.sqrt(bb4ac))/(2*a);
			
			local r1 = {};
			r1.x = p1.x+mu1*(p2.x-p1.x);
			r1.y = p1.y+mu1*(p2.y-p1.y);
			if (mu1 == mu2) then
				return {r1};
			else
				local r2 = {};
				r2.x = p1.x+mu2*(p2.x-p1.x);
				r2.y = p1.y+mu2*(p2.y-p1.y);
				return {r1, r2};
			end
		end
	end
	
	function CMathExt:InterRayCir(p1, p2, sc, sc_r)
		local EPS = 0.00000001;
		local dp = {};
		
		dp.x = p2.x-p1.x;
		dp.y = p2.y-p1.y;
		local a = dp.x*dp.x+dp.y*dp.y;
		if (math.abs(a)<EPS) then
			return {};
		end
		local b = 2*(dp.x*(p1.x-sc.x)+dp.y*(p1.y-sc.y));
		local c = sc.x*sc.x+sc.y*sc.y;
		c = c + p1.x*p1.x+p1.y*p1.y;
		c = c - 2*(sc.x*p1.x+sc.y*p1.y);
		c = c - sc_r*sc_r;
		local bb4ac = b*b-4*a*c;
		if (bb4ac<0) then
			return {};
		else
			local mu1 = (-b+math.sqrt(bb4ac))/(2*a);
			local mu2 = (-b-math.sqrt(bb4ac))/(2*a);
			
			local r1 = {};
			r1.x = p1.x+mu1*(p2.x-p1.x);
			r1.y = p1.y+mu1*(p2.y-p1.y);
			if (mu1 == mu2) then
				return {r1};
			else
				local r2 = {};
				r2.x = p1.x+mu2*(p2.x-p1.x);
				r2.y = p1.y+mu2*(p2.y-p1.y);
				return {r1, r2};
			end
		end
	end
	
	return CMathExt;
end