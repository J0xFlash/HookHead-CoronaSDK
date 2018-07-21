--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:de9a1e66367a3ab1a0301c6920284822:5daf832fcff7c25e568b8638c119c698:24e4eb0fb33b646fc21874bb6fc8fecb$
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
            -- btnExit
            x=1597,
            y=1,
            width=300,
            height=300,

        },
        {
            -- btnMenu
            x=1597,
            y=303,
            width=300,
            height=300,

        },
        {
            -- btnPause
            x=1073,
            y=515,
            width=300,
            height=300,

        },
        {
            -- btnPlay
            x=1083,
            y=1,
            width=512,
            height=512,

        },
        {
            -- btnRestart
            x=1575,
            y=605,
            width=300,
            height=300,

        },
        {
            -- btnSound
            x=1,
            y=625,
            width=300,
            height=300,

        },
        {
            -- character_1
            x=303,
            y=625,
            width=270,
            height=270,

            sourceX = 14,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_2
            x=847,
            y=817,
            width=266,
            height=266,

            sourceX = 16,
            sourceY = 16,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_3
            x=1115,
            y=817,
            width=266,
            height=266,

            sourceX = 16,
            sourceY = 16,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_4
            x=575,
            y=625,
            width=270,
            height=270,

            sourceX = 15,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- floor
            x=1,
            y=1,
            width=1080,
            height=404,

        },
        {
            -- hook
            x=809,
            y=1085,
            width=432,
            height=141,

        },
        {
            -- Score
            x=1,
            y=407,
            width=870,
            height=216,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 870,
            sourceHeight = 222
        },
        {
            -- tileBg
            x=303,
            y=897,
            width=254,
            height=254,

        },
        {
            -- wallLeftDown
            x=559,
            y=897,
            width=248,
            height=248,

        },
        {
            -- wallLeftMiddle
            x=873,
            y=407,
            width=198,
            height=248,

            sourceX = 17,
            sourceY = 0,
            sourceWidth = 248,
            sourceHeight = 248
        },
        {
            -- wallLeftTop
            x=1,
            y=927,
            width=248,
            height=248,

        },
        {
            -- wallRightDown
            x=1383,
            y=907,
            width=248,
            height=248,

        },
        {
            -- wallRightMiddle
            x=1375,
            y=515,
            width=198,
            height=248,

            sourceX = 32,
            sourceY = 0,
            sourceWidth = 248,
            sourceHeight = 248
        },
        {
            -- wallRightTop
            x=1633,
            y=907,
            width=248,
            height=248,

        },
    },

    sheetContentWidth = 1898,
    sheetContentHeight = 1227
}

SheetInfo.frameIndex =
{

    ["btnExit"] = 1,
    ["btnMenu"] = 2,
    ["btnPause"] = 3,
    ["btnPlay"] = 4,
    ["btnRestart"] = 5,
    ["btnSound"] = 6,
    ["character_1"] = 7,
    ["character_2"] = 8,
    ["character_3"] = 9,
    ["character_4"] = 10,
    ["floor"] = 11,
    ["hook"] = 12,
    ["Score"] = 13,
    ["tileBg"] = 14,
    ["wallLeftDown"] = 15,
    ["wallLeftMiddle"] = 16,
    ["wallLeftTop"] = 17,
    ["wallRightDown"] = 18,
    ["wallRightMiddle"] = 19,
    ["wallRightTop"] = 20,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
