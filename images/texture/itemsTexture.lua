--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:b96bbf13ce55739dac65008d44f9f239:aacd9e80235f128b30c20decee9ddf9e:24e4eb0fb33b646fc21874bb6fc8fecb$
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
            x=1,
            y=515,
            width=300,
            height=300,

        },
        {
            -- btnMenu
            x=515,
            y=1,
            width=300,
            height=300,

        },
        {
            -- btnPause
            x=1,
            y=817,
            width=300,
            height=300,

        },
        {
            -- btnPlay
            x=1,
            y=1,
            width=512,
            height=512,

        },
        {
            -- btnRestart
            x=1,
            y=1119,
            width=300,
            height=300,

        },
        {
            -- btnSound
            x=303,
            y=515,
            width=300,
            height=300,

        },
        {
            -- character_1
            x=303,
            y=817,
            width=270,
            height=270,

            sourceX = 14,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_2
            x=303,
            y=1089,
            width=270,
            height=270,

            sourceX = 14,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_3
            x=575,
            y=817,
            width=270,
            height=270,

            sourceX = 14,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_4
            x=575,
            y=1089,
            width=270,
            height=270,

            sourceX = 15,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- hook
            x=303,
            y=1361,
            width=432,
            height=141,

        },
        {
            -- tileBg
            x=605,
            y=303,
            width=254,
            height=254,

        },
        {
            -- wallLeftDown
            x=605,
            y=559,
            width=124,
            height=124,

        },
        {
            -- wallLeftMiddle
            x=737,
            y=1361,
            width=102,
            height=124,

            sourceX = 8,
            sourceY = 0,
            sourceWidth = 124,
            sourceHeight = 124
        },
        {
            -- wallLeftTop
            x=605,
            y=685,
            width=124,
            height=124,

        },
    },

    sheetContentWidth = 860,
    sheetContentHeight = 1503
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
    ["hook"] = 11,
    ["tileBg"] = 12,
    ["wallLeftDown"] = 13,
    ["wallLeftMiddle"] = 14,
    ["wallLeftTop"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
