module( ..., package.seeall )

local old_mc = nil
function director:changeScene(prs, moduleName)
	if(moduleName==nil)then
		moduleName = prs;
		prs = nil;
	end
	if(old_mc)then
		if(old_mc.removeAllListeners)then
			old_mc:removeAllListeners()
			old_mc.removeAllListeners = nil;
		end
		if(old_mc.removeAll)then
			old_mc:removeAll();
			old_mc.removeAll = nil;
		end
		old_mc:removeSelf();
		old_mc = nil;
	end
	old_mc = require(moduleName).new(prs);
	mainGroup:insert(1, old_mc);
end
function director:getCurrHandler()
	return old_mc;
end