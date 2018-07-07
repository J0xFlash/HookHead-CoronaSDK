module(..., package.seeall);
-- greenLang 1.0

local function loadFile(fname)
	local path =  system.pathForFile(fname, system.DocumentsDirectory);
	local file = io.open( path, "r" );
	if (file) then
		local contents = file:read( "*a" );
		if(contents and #contents>0)then
			return contents;
		end
	end
	return nil
end
local function saveFile(fname, save_str)
	local path = system.pathForFile( fname, system.DocumentsDirectory);
	local file = io.open(path, "w+b");
	if file then
		file:write(save_str);          
		io.close( file )
		-- print("Saving("..fname.."): ok!")
	else
		-- print("Saving("..fname.."): fail!")
	end
end

function new()
	local localGroup = display.newGroup();
	localGroup.langObj = nil;
	localGroup.current_id = nil;
	
	localGroup.langs_list = {};
	localGroup.langs_obj = {};
	
	function localGroup:saveSettings()
		local settings = {};
		settings.current_id = localGroup.current_id;
		saveFile("lang.settings", json.encode(settings));
	end
	function localGroup:loadSettings(def)
		local tdata = loadFile("lang.settings");
		if(tdata)then
			local settings = json.decode(tdata);
			if(settings)then
				if(settings.current_id == "br")then
					settings.current_id = "pt";
				end
				localGroup:setLanguage(settings.current_id);
				return
			end
		end
		if(def==nil)then
			def = 'en';
		end
		
		localGroup:setLanguage(def);
		return
	end
	
	function localGroup:add_lang_xml(id, fontName)
		local lang_obj = {};
		lang_obj.id = id;
		lang_obj.font=fontName;
		table.insert(localGroup.langs_list, lang_obj);
		localGroup.langs_obj[id] = lang_obj;
	end
	
	function localGroup:addEnWord(attr, val)
		localGroup.langObjEn[attr] = val;
	end
	function localGroup:addCurWord(attr, val)
		if(localGroup.langObj[attr] == nil)then
			localGroup.langObj[attr] = val;
		end
	end
	
	function localGroup:getList()
		return localGroup.langs_list;
	end
	
	local lang_names ={}
	lang_names.en="English";
	lang_names.es="Espanol";
	lang_names.ru="Russian";
	lang_names.jp="Japanese"
	lang_names.pt="Portuguese"
	lang_names["zh_tw"]="Chinese-Traditional"
	lang_names["zh_cn"]="Chinese-Simplified"
	localGroup.lang_names = lang_names;
	
	local function touchHandler(evt)
			local phase = evt.phase;
			local mouse_xy = {x=evt.x - localGroup.list_mc.x, y=evt.y - localGroup.list_mc.y};
			if(phase=='began' or phase=='moved')then
				local someoneSelected = false;
				for i=1, localGroup.items_mc.numChildren do 
					local item_mc = localGroup.items_mc[i];
					local dd = get_dd(item_mc, mouse_xy);
					if(dd<localGroup._item_rr)then
						someoneSelected = true;
						if(lang_names[item_mc.obj.id])then
							addHint(lang_names[item_mc.obj.id]);
						else
							addHint(item_mc.obj.id);
						end
						if(item_mc._selected == false)then
							item_mc._selected = true;
							transition.to(item_mc._over, {time=180, alpha=0.3});
						end
					else
						if(item_mc._selected == true)then
							removeHint();
							item_mc._selected = false;
							transition.to(item_mc._over, {time=280, alpha=0.0});
						end
					end
				end
			else
				for i=1, localGroup.items_mc.numChildren do 
					local item_mc = localGroup.items_mc[i];
					if(item_mc._selected == true)then
						localGroup:setLanguage(item_mc.obj.id);
						item_mc._selected = false;
						transition.to(item_mc._over, {time=280, alpha=0.0});
					end
				end
			end
	end
	
	localGroup._open = false;
	function localGroup:closeList()
		localGroup._open = false;
		if(localGroup.list_mc)then
			if(localGroup.list_mc.removeSelf)then
				localGroup.list_mc:removeEventListener("touch", touchHandler);
				localGroup.list_mc:removeSelf();
				localGroup.list_mc.removeSelf = nil;
				localGroup.list_mc = nil;
			end
		end
	end
	localGroup._item_rr = 26*26;
	
	function localGroup:getPrevLangId()
		for i=1,#localGroup.langs_list do
			local item_obj = localGroup.langs_list[i];
			if(localGroup.current_id == item_obj.id)then
				if(i>1)then
					return localGroup.langs_list[i-1];
				else
					return localGroup.langs_list[#localGroup.langs_list];
				end
			end
		end
	end
	
	function localGroup:getNextLangId()
		for i=1,#localGroup.langs_list do
			local item_obj = localGroup.langs_list[i];
			if(localGroup.current_id == item_obj.id)then
				if(i<#localGroup.langs_list)then
					return localGroup.langs_list[i+1];
				else
					return localGroup.langs_list[1];
				end
			end
		end
	end
	
	function localGroup:showList(sx, sy, dx, dy, scale)
		localGroup:closeList();
		localGroup._open = true;
		
		local list_mc = display.newGroup();
		localGroup.list_mc = list_mc;
		
		local bg_w = 100;
		local bg_h = -(dy*(#localGroup.langs_list+0.5)+sy);
		
		local items_mc = display.newGroup();
		list_mc:insert(items_mc);
		localGroup.items_mc = items_mc;
		
		for i=1,#localGroup.langs_list do
			local item_obj = localGroup.langs_list[i];
			local item_mc = display.newGroup();
			local item_bg_w, item_bg_h = 80, 50;
			local body_mc = display.newImage(item_mc, "gfx/langs/lang_"..item_obj.id..".png");
			item_mc._selected = false;
			if(body_mc)then
				body_mc.x, body_mc.y = 0,0;
				body_mc.xScale, body_mc.yScale = scale/2, scale/2;
				item_mc._over = display.newRect(item_mc, 0, 0, body_mc.width, body_mc.height);
				item_mc._over.blendMode = "add";
				item_mc._over.alpha = 0;
				item_mc._over.x, item_mc._over.y = 0,0;
				item_mc._over.xScale, item_mc._over.yScale = scale/2, scale/2;
			end
			
			item_obj.mc = item_mc;
			item_mc.obj = item_obj;
			items_mc:insert(item_mc);
			item_mc.x, item_mc.y = sx+dx*(i-1), sy+dy*(i-1);
			
			item_mc.w, item_mc.h = item_bg_w*scale, item_bg_h*scale;
		end
		
		list_mc:removeEventListener("touch", touchHandler);
		list_mc:addEventListener("touch", touchHandler);
		return list_mc;
	end
	
	local en_xml = xml:loadFile('data/lang_'..'en'..'.xml');
	localGroup.langObjEn = en_xml.properties;
	
	function localGroup:addEnWord(attr, val)
		localGroup.langObjEn[attr] = val;
	end
	function localGroup:setLanguage(id)
		local obj=localGroup.langs_obj[id];
		if(obj == nil)then
			id = "en";
			obj=localGroup.langs_obj["en"]
		end
		if(obj.font)then
			if(setMainFont)then
				setMainFont(obj.font);
			end
		end
		
		local xml = xml:loadFile('data/lang_'..id..'.xml');
		localGroup.langObj = xml.properties;
		localGroup.current_id = id;
		
		localGroup:saveSettings();
		
		if(options_debug and id~='en')then
			local untranslated_words ={};
			for key, val in pairs(localGroup.langObjEn) do  -- Table iteration.
				if(localGroup.langObj[key] == nil)then
					if(val ~= "")then 
						table.insert(untranslated_words, key..'="'..val..'"');
					end
				end
			end
			table.sort(untranslated_words);
			local save_str = table.concat(untranslated_words, "\r");
			saveFile('lang_un_'..id..'.txt', save_str);
		end
	end
	
	function localGroup:get_txt(txt)
		if(localGroup.langObj[txt] == nil)then
			if(localGroup.langObjEn[txt] == nil)then
				return txt;
			else
				return localGroup.langObjEn[txt]
			end
		else
			return localGroup.langObj[txt];
		end
	end
	
	function localGroup:get_bol(txt)
		return (localGroup.langObj[txt] ~= nil)
	end
	
	return localGroup;
end