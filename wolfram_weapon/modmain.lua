PrefabFiles = {
    "ak47",
    "akclip",
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING


-- Recipe
AddRecipe("akclip", { Ingredient("rock", 1), Ingredient("ash", 2), Ingredient("charcoal", 2) }, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.NONE, nil, nil, nil, 7, nil, "images/inventoryimages/akclip.xml", "akclip.tex" )
