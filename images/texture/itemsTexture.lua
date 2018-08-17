--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:ffab12585e7aba724118872806a27197:e208d0231cbb665118088627b670d592:24e4eb0fb33b646fc21874bb6fc8fecb$
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
            -- btnAch
            x=1,
            y=1060,
            width=300,
            height=300,

        },
        {
            -- btnExit
            x=303,
            y=1060,
            width=300,
            height=300,

        },
        {
            -- btnGoogle
            x=1689,
            y=546,
            width=300,
            height=222,

        },
        {
            -- btnLead
            x=515,
            y=625,
            width=300,
            height=300,

        },
        {
            -- btnMenu
            x=605,
            y=927,
            width=300,
            height=300,

        },
        {
            -- btnPause
            x=817,
            y=625,
            width=300,
            height=300,

        },
        {
            -- btnPlay
            x=1,
            y=546,
            width=512,
            height=512,

        },
        {
            -- btnRestart
            x=751,
            y=1229,
            width=300,
            height=300,

        },
        {
            -- btnSound
            x=907,
            y=927,
            width=300,
            height=300,

        },
        {
            -- btnSoundOff
            x=1119,
            y=625,
            width=300,
            height=300,

        },
        {
            -- character_1
            x=1053,
            y=1229,
            width=270,
            height=270,

            sourceX = 14,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_2
            x=1421,
            y=546,
            width=266,
            height=266,

            sourceX = 16,
            sourceY = 16,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_3
            x=1689,
            y=770,
            width=266,
            height=266,

            sourceX = 16,
            sourceY = 16,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_4
            x=1209,
            y=927,
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
            width=1536,
            height=404,

        },
        {
            -- hook
            x=1539,
            y=1,
            width=432,
            height=141,

        },
        {
            -- saw
            x=1539,
            y=144,
            width=400,
            height=400,

        },
        {
            -- score
            x=515,
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
            x=1681,
            y=1038,
            width=254,
            height=254,

        },
        {
            -- torch
            x=1575,
            y=1314,
            width=164,
            height=230,

            sourceX = 32,
            sourceY = 14,
            sourceWidth = 250,
            sourceHeight = 250
        },
        {
            -- wallLeftDown
            x=1,
            y=1362,
            width=248,
            height=248,

        },
        {
            -- wallLeftMiddle
            x=1481,
            y=814,
            width=198,
            height=248,

            sourceX = 17,
            sourceY = 0,
            sourceWidth = 248,
            sourceHeight = 248
        },
        {
            -- wallLeftTop
            x=251,
            y=1362,
            width=248,
            height=248,

        },
        {
            -- wallRightDown
            x=501,
            y=1362,
            width=248,
            height=248,

        },
        {
            -- wallRightMiddle
            x=1481,
            y=1064,
            width=198,
            height=248,

            sourceX = 32,
            sourceY = 0,
            sourceWidth = 248,
            sourceHeight = 248
        },
        {
            -- wallRightTop
            x=1325,
            y=1314,
            width=248,
            height=248,

        },
    },

    sheetContentWidth = 1990,
    sheetContentHeight = 1611
}

SheetInfo.frameIndex =
{

    ["btnAch"] = 1,
    ["btnExit"] = 2,
    ["btnGoogle"] = 3,
    ["btnLead"] = 4,
    ["btnMenu"] = 5,
    ["btnPause"] = 6,
    ["btnPlay"] = 7,
    ["btnRestart"] = 8,
    ["btnSound"] = 9,
    ["btnSoundOff"] = 10,
    ["character_1"] = 11,
    ["character_2"] = 12,
    ["character_3"] = 13,
    ["character_4"] = 14,
    ["floor"] = 15,
    ["hook"] = 16,
    ["saw"] = 17,
    ["score"] = 18,
    ["tileBg"] = 19,
    ["torch"] = 20,
    ["wallLeftDown"] = 21,
    ["wallLeftMiddle"] = 22,
    ["wallLeftTop"] = 23,
    ["wallRightDown"] = 24,
    ["wallRightMiddle"] = 25,
    ["wallRightTop"] = 26,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
