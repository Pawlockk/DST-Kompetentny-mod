local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.WOLFRAM_HEALTH = 150
TUNING.WOLFRAM_HUNGER = 250
TUNING.WOLFRAM_SANITY = 200

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WOLFRAM = {
	"nightmarefuel",
	"ash",
	"gears",
	"wand",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.WOLFRAM
end
local prefabs = FlattenTree(start_inv, true)

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "wolfram_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "wolfram_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function ChangeStats(inst, enable)

	if inst.components.hunger.current > 175 then
		inst.components.health.absorb = 0.4
		inst.components.combat.damagemultiplier = 1.45
	elseif inst.components.hunger.current < 75 then
		inst.components.health.absorb = 0.2
		inst.components.combat.damagemultiplier = 2.75
	else
		inst.components.health.absorb = 0.3
		inst.components.combat.damagemultiplier = 1.75
	end
end




-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "wolfram.tex" )
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.WOLFRAM_HEALTH)
	inst.components.hunger:SetMax(TUNING.WOLFRAM_HUNGER)
	inst.components.sanity:SetMax(TUNING.WOLFRAM_SANITY)

	FOODGROUP =
	{
		BARTEK =
		{
			name = "BARTEK",
			types =
			{
				FOODTYPE.GENERIC,
				FOODTYPE.RAW,
				FOODTYPE.MEAT,
				FOODTYPE.BERRY,
				FOODTYPE.ELEMENTAL,
				FOODTYPE.ROUGHAGE,
				FOODTYPE.VEGGIE,
				FOODTYPE.HORRIBLE,
				FOODTYPE.GOODIES,
				FOODTYPE.BURNT,
				FOODTYPE.GEARS,
				FOODTYPE.WOOD,
				FOODTYPE.SEEDS,
				FOODTYPE.INSECT,
			},
		}
	}

	inst.components.eater:SetDiet({FOODGROUP.BARTEK})


    inst.components.combat.damagemultiplier = 1.75

	inst.components.health.absorb = 0.3
	
	inst.components.hunger.hungerrate = 1.5 * TUNING.WILSON_HUNGER_RATE

	inst.components.locomotor.walkspeed = 2
	inst.components.locomotor.runspeed = 4

	

	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("wolfram", prefabs, assets, common_postinit, master_postinit, prefabs)
