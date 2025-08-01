---@type some_utils
local some_utils = dofile_once("mods/disable_friendly_fire_v2/files/some_utils.lua")

for _i, item in ipairs(actions) do
	if item.id == "BLOOD_TO_POWER" then
		print("BLOOD_TO_POWER action found, modfying it..")
		item.action = function()
			local entity_id = GetUpdatedEntityID()

			local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )

			if ( dcomp ~= nil ) then
				local hp = ComponentGetValue2( dcomp, "hp" )
				local damage = math.min( hp * 0.44, 960 )
				local self_damage = hp * 0.2

				if ( hp >= 0.4 ) and ( self_damage > 0.2 ) then
					c.extra_entities = c.extra_entities .. "data/entities/particles/blood_sparks.xml,"

					EntityInflictDamage( entity_id, self_damage, "DAMAGE_CURSE", "$action_blood_to_power", "NONE", 0, 0, some_utils.forced_friendly_fire_dummy )

					-- print( "Spent " .. tostring( damage ) )

					c.damage_projectile_add = c.damage_projectile_add + damage
				end
			end

			draw_actions( 1, true )
		end
	end
end