PrefabFiles = {
	"wolfram",
	"wolfram_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/wolfram.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wolfram.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/wolfram.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wolfram.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/wolfram_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wolfram_silho.xml" ),

    Asset( "IMAGE", "bigportraits/wolfram.tex" ),
    Asset( "ATLAS", "bigportraits/wolfram.xml" ),
	
	Asset( "IMAGE", "images/map_icons/wolfram.tex" ),
	Asset( "ATLAS", "images/map_icons/wolfram.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_wolfram.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_wolfram.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_wolfram.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_wolfram.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_wolfram.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_wolfram.xml" ),
	
	Asset( "IMAGE", "images/names_wolfram.tex" ),
    Asset( "ATLAS", "images/names_wolfram.xml" ),
	
	Asset( "IMAGE", "images/names_gold_wolfram.tex" ),
    Asset( "ATLAS", "images/names_gold_wolfram.xml" ),
}

AddMinimapAtlas("images/map_icons/wolfram.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.wolfram = "Wolfram"
STRINGS.CHARACTER_NAMES.wolfram = "Wolfram"
STRINGS.CHARACTER_DESCRIPTIONS.wolfram = "*Ma garłacza\n*Może jeść wszystko\n*Gdy najedzony, jest pancerny a gdy głodny, jest wkurwiony"
STRINGS.CHARACTER_QUOTES.wolfram = "\"Z kodem BARTEK 10% zniżki do laryngologa\""
STRINGS.CHARACTER_SURVIVABILITY.wolfram = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.WOLFRAM = require "speech_wolfram"

-- The character's name as appears in-game 
STRINGS.NAMES.WOLFRAM = "Wolfram"
STRINGS.SKIN_NAMES.wolfram_none = "Wolfram"

local function MakeFruit(inst)
	inst:AddComponent("edible") 
    if inst.components.edible.foodtype == nil then
    inst.components.edible.foodtype = GLOBAL.FOODTYPE.ELEMENTAL
    end  
    inst.components.edible.healthvalue = -1    
    inst.components.edible.sanityvalue = -1    
    inst.components.edible.hungervalue = 5
end

--Do this for each food that you want in the fruit group
AddPrefabPostInit("nightmarefuel", MakeFruit)
AddPrefabPostInit("gears", MakeFruit)


-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("wolfram", "MALE", skin_modes)
