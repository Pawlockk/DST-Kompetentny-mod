local assets=
{
	Asset("ANIM", "anim/akclip.zip"),
	Asset("ATLAS", "images/inventoryimages/akclip.xml"),
    Asset("IMAGE", "images/inventoryimages/akclip.tex"),
}

local prefabs =
{

}


local function fncommon(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
	
    
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("stackable")	 
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/akclip.xml"

	return inst
end
local function fnakclip(Sim)
	local inst = fncommon(Sim)
	    
    inst.AnimState:SetBank("akclip")--("bullet")
    inst.AnimState:SetBuild("akclip")
    inst.AnimState:PlayAnimation("idle")    
    
    if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

STRINGS.NAMES.AKCLIP = ".308 Winchester"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AKCLIP = "Till it goes click."
STRINGS.RECIPE_DESC.AKCLIP = "An En Bloc Clip. 8 rounds contained."
return Prefab( "common/inventory/akclip", fnakclip, assets)
