local assets =
{
	Asset( "ANIM", "anim/wolfram.zip" ),
	Asset( "ANIM", "anim/ghost_wolfram_build.zip" ),
}

local skins =
{
	normal_skin = "wolfram",
	ghost_skin = "ghost_wolfram_build",
}

return CreatePrefabSkin("wolfram_none",
{
	base_prefab = "wolfram",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"WOLFRAM", "CHARACTER", "BASE"},
	build_name_override = "wolfram",
	rarity = "Character",
})