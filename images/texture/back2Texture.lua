--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:2728dc7464d26e051a7e14eb151e6d88:2fe34a3846a3f7d9ca56d0f893f3c8dd:dd700a74250e8101e1f924d07f6ff5ba$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- floor_04
            x=1,
            y=1281,
            width=1536,
            height=380,

            sourceX = 0,
            sourceY = 214,
            sourceWidth = 1536,
            sourceHeight = 594
        },
        {
            -- floor_05
            x=1,
            y=651,
            width=1536,
            height=628,

            sourceX = 0,
            sourceY = 26,
            sourceWidth = 1536,
            sourceHeight = 654
        },
        {
            -- floor_06
            x=1,
            y=1,
            width=1536,
            height=648,

            sourceX = 0,
            sourceY = 70,
            sourceWidth = 1536,
            sourceHeight = 718
        },
    },

    sheetContentWidth = 1538,
    sheetContentHeight = 1662
}

SheetInfo.frameIndex =
{

    ["floor_04"] = 1,
    ["floor_05"] = 2,
    ["floor_06"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
