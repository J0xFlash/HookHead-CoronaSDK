--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:6a279f290b4e9593a65cbaf25777b3d3:b74376df710dcd3c3a1c83aba9b533bb:dd700a74250e8101e1f924d07f6ff5ba$
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
            width=1080,
            height=380,

            sourceX = 0,
            sourceY = 214,
            sourceWidth = 1080,
            sourceHeight = 594
        },
        {
            -- floor_05
            x=1,
            y=651,
            width=1080,
            height=628,

            sourceX = 0,
            sourceY = 26,
            sourceWidth = 1080,
            sourceHeight = 654
        },
        {
            -- floor_06
            x=1,
            y=1,
            width=1080,
            height=648,

            sourceX = 0,
            sourceY = 70,
            sourceWidth = 1080,
            sourceHeight = 718
        },
    },

    sheetContentWidth = 1082,
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
