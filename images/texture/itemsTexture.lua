--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:5e84a73929f450c97ba4871b9a78a166:92a4abf84018e2416d3b77583897b548:24e4eb0fb33b646fc21874bb6fc8fecb$
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
            x=1073,
            y=515,
            width=300,
            height=300,

        },
        {
            -- btnGoogle
            x=1447,
            y=1023,
            width=300,
            height=222,

        },
        {
            -- btnMenu
            x=1,
            y=1023,
            width=300,
            height=300,

        },
        {
            -- btnPause
            x=1,
            y=625,
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
            x=303,
            y=625,
            width=300,
            height=300,

        },
        {
            -- btnSound
            x=873,
            y=817,
            width=300,
            height=300,

        },
        {
            -- btnSoundOff
            x=303,
            y=927,
            width=300,
            height=300,

        },
        {
            -- character_1
            x=1575,
            y=751,
            width=270,
            height=270,

            sourceX = 14,
            sourceY = 15,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_2
            x=605,
            y=625,
            width=266,
            height=266,

            sourceX = 16,
            sourceY = 16,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_3
            x=605,
            y=893,
            width=266,
            height=266,

            sourceX = 16,
            sourceY = 16,
            sourceWidth = 300,
            sourceHeight = 300
        },
        {
            -- character_4
            x=1175,
            y=817,
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
            x=303,
            y=1229,
            width=432,
            height=141,

        },
        {
            -- score
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
            x=1175,
            y=1089,
            width=254,
            height=254,

        },
        {
            -- wallLeftDown
            x=1597,
            y=1,
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
            x=1597,
            y=251,
            width=248,
            height=248,

        },
        {
            -- wallRightDown
            x=1597,
            y=501,
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
            x=873,
            y=1119,
            width=248,
            height=248,

        },
    },

    sheetContentWidth = 1846,
    sheetContentHeight = 1371
}

SheetInfo.frameIndex =
{

    ["btnExit"] = 1,
    ["btnGoogle"] = 2,
    ["btnMenu"] = 3,
    ["btnPause"] = 4,
    ["btnPlay"] = 5,
    ["btnRestart"] = 6,
    ["btnSound"] = 7,
    ["btnSoundOff"] = 8,
    ["character_1"] = 9,
    ["character_2"] = 10,
    ["character_3"] = 11,
    ["character_4"] = 12,
    ["floor"] = 13,
    ["hook"] = 14,
    ["score"] = 15,
    ["tileBg"] = 16,
    ["wallLeftDown"] = 17,
    ["wallLeftMiddle"] = 18,
    ["wallLeftTop"] = 19,
    ["wallRightDown"] = 20,
    ["wallRightMiddle"] = 21,
    ["wallRightTop"] = 22,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
