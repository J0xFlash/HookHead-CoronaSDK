--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:4bce12aacd6caed2adf474c45667adfe:8dea6e66699409c0c2fe55d675d8b771:5af89b11c7b92e08352cad89e8b071ed$
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
            -- floor_01
            x=1,
            y=599,
            width=1080,
            height=486,

            sourceX = 0,
            sourceY = 118,
            sourceWidth = 1080,
            sourceHeight = 604
        },
        {
            -- floor_02
            x=1,
            y=1,
            width=1080,
            height=596,

            sourceX = 0,
            sourceY = 48,
            sourceWidth = 1080,
            sourceHeight = 644
        },
        {
            -- floor_03
            x=1,
            y=1087,
            width=1080,
            height=474,

            sourceX = 0,
            sourceY = 179,
            sourceWidth = 1080,
            sourceHeight = 654
        },
    },

    sheetContentWidth = 1082,
    sheetContentHeight = 1562
}

SheetInfo.frameIndex =
{

    ["floor_01"] = 1,
    ["floor_02"] = 2,
    ["floor_03"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
