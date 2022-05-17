local assets =
{
	Asset("ANIM", "anim/ak47.zip"),
	Asset("ANIM", "anim/swap_ak47.zip"),
    Asset("ATLAS", "images/inventoryimages/ak47.xml"),
	
}

local prefabs = 
{
    "fire_projectile", 
	"akclip",
}

local CRACK_MUST_TAGS = { "_combat" }
local CRACK_CANT_TAGS = { "player", "epic", "shadow", "shadowminion", "shadowchesspiece" }
local function supercrack(inst, owner)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, TUNING.WHIP_SUPERCRACK_RANGE, CRACK_MUST_TAGS, CRACK_CANT_TAGS)
    for i,v in ipairs(ents) do
        if v.components.combat:HasTarget() then
            v:AddTag("akclip_hit")
            local targetpos = v:GetPosition()
            local pos = owner.temppos or owner:GetPosition()
            local dmg = {-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,}

            if v:HasTag("akclip_hit")  then

                if math.floor(math.sqrt(distsq(targetpos, pos))) == 0 then

                    v.components.health:DoDelta(dmg[1]*owner.components.combat.damagemultiplier)

                elseif math.floor(math.sqrt(distsq(targetpos, pos))) > 10 then

                    v.components.health:DoDelta(dmg[10]*owner.components.combat.damagemultiplier)

                else

                    v.components.health:DoDelta(dmg[math.floor(math.sqrt(distsq(targetpos, pos)))]*owner.components.combat.damagemultiplier)

                end

            end
            v.components.combat:DropTarget()
            if v.sg ~= nil and v.sg:HasState("hit")
                and v.components.health ~= nil and not v.components.health:IsDead()
                and not v.sg:HasStateTag("transform")
                and not v.sg:HasStateTag("nointerrupt")
                and not v.sg:HasStateTag("frozen")
                --and not v.sg:HasStateTag("attack")
                --and not v.sg:HasStateTag("busy")
                then

                if v.components.sleeper ~= nil then
                    v.components.sleeper:WakeUp()
                end
                v.sg:GoToState("hit")
            end
        end
    end
end

local function onattack_ak47(inst, owner, target)

    if target ~= nil and target:IsValid() and owner and owner.components.inventory and owner.components.inventory:Has("akclip", 1) then

        inst.components.weapon:SetRange(10)
        owner.components.inventory:ConsumeByName("akclip", 1)
        target:AddTag("akclip_hit")

        local targetpos = target:GetPosition()
        local pos = owner.temppos or owner:GetPosition()

        -- DMG

        local dmg = {-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,}

        if target:HasTag("akclip_hit")  then

            if math.floor(math.sqrt(distsq(targetpos, pos))) == 0 then

                target.components.health:DoDelta(dmg[1]*owner.components.combat.damagemultiplier)

            elseif math.floor(math.sqrt(distsq(targetpos, pos))) > 10 then

                target.components.health:DoDelta(dmg[10]*owner.components.combat.damagemultiplier)

            else

                target.components.health:DoDelta(dmg[math.floor(math.sqrt(distsq(targetpos, pos)))]*owner.components.combat.damagemultiplier)

            end

        end


        --Crack
        local snap = SpawnPrefab("impact")

        local x, y, z = inst.Transform:GetWorldPosition()
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local angle = -math.atan2(z1 - z, x1 - x)
        snap.Transform:SetPosition(x1, y1, z1)
        snap.Transform:SetRotation(angle * RADIANS)
        snap.Transform:SetScale(3, 3, 3)
        inst:DoTaskInTime(0, supercrack(inst,owner))

    else
        inst.components.weapon:SetRange(0)
    end

end

local function onequip(inst, owner)

    if owner.prefab == "wolfram" and owner.components.inventory then

        -- animacje
        owner.AnimState:OverrideSymbol("swap_object", "swap_ak47", "swap_ak47")
        owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal")
        
	else
		owner:DoTaskInTime(0, function()
			local inv = owner.components.inventory 
			if inv then
				inv:GiveItem(inst)
			end
			local talker = owner.components.talker 
			if talker then
				talker:Say("To jest Bartka!")
			end
		end)
	end

end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(Sim)

	local inst = CreateEntity()
	local minimap = inst.entity:AddMiniMapEntity()
	

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ak47")
    inst.AnimState:SetBuild("ak47")
    inst.AnimState:PlayAnimation("idle")
	inst:AddTag("ak47") 
    
	
	inst:AddTag("firestaff")
    inst:AddTag("rangedfireweapon")
	
	 if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()
  
	
	minimap:SetIcon("ak47.tex")
	
	inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(1)
        inst.components.weapon:SetOnAttack(onattack_ak47)
        inst.components.weapon:SetProjectile("fire_projectile")

	inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	    inst.components.inventoryitem.atlasname = "images/inventoryimages/ak47.xml"
 
    inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip( onequip )
        inst.components.equippable:SetOnUnequip( onunequip )
	
	MakeHauntableLaunch(inst)
	
 
 
    return inst
end

STRINGS.NAMES.AK47 = "Garłacz"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AK47 = "Bartkowa broń XD"


return Prefab("common/inventory/ak47", fn, assets)