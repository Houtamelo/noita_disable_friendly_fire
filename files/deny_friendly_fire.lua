dofile_once("data/scripts/lib/utilities.lua")
---@type some_utils
local some_utils = dofile_once("mods/disable_friendly_fire_v2/files/some_utils.lua")

function damage_about_to_be_received(damage, _x, _y, entity_thats_responsible, critical_hit_chance)
	if damage <= 0 then
		return damage, critical_hit_chance
	end

	local shooter = some_utils.get_projectile_root_shooter(entity_thats_responsible)

	if shooter ~= nil then
		if shooter == some_utils.forced_friendly_fire_dummy then
			print("Friendly fire forced: " .. tostring(damage) .. " from " .. tostring(entity_thats_responsible))
			return damage, critical_hit_chance
		end

		if EntityHasTag(shooter, "player_unit") then
			print("Denying friendly damage: " .. tostring(damage) .. " from " .. tostring(entity_thats_responsible))
			return 0, critical_hit_chance
		end
	end

	return damage, critical_hit_chance
end

function shot(projectile)
	if EntityHasTag(projectile, "projectile_heal") then return end

	-- Dont disable friendly fire on "Deadly Heal" projectile.
	local is_heal_hurt = false
	edit_all_components(projectile, "HitEffectComponent", function(hit_effect, vars)
		local value_string = ComponentGetValue2(hit_effect, "value_string")
		if value_string ~= nil and value_string == "data/entities/misc/effect_healhurt.xml" then
			is_heal_hurt = true
		end
	end)

	edit_component(projectile, "ProjectileComponent", function(comp, vars)
		-- This flag is set by `BloodLust` and `Piercing Shot` modifiers, I want to keep their friendly fire behavior.
		local forced_friendly_fire = ComponentObjectGetValue2(comp, "config", "friendly_fire")
		if forced_friendly_fire then
			vars.mWhoShot = some_utils.forced_friendly_fire_dummy
		elseif is_heal_hurt == false then
			vars.collide_with_shooter_frames = -1
			vars.explosion_dont_damage_shooter = 1
			vars.friendly_fire = false

			edit_component(projectile, "AreaDamageComponent", function(aoe, _v)
				print("Found AreaDamageComponent, disabling friendly fire for it.")
				local curr_tag = ComponentGetValue2(aoe, "entities_with_tag")

				-- Other tags are:
				--     - player_unit: If something is meant to specifically damage only the player, allow it.
				--     - prey: Seems like this tag never damages the caster? Even if the caster is tagged "prey".
				--     - homing_target: Likely means the spell does a special thing that we shouldn't interfere with.
				--     - enemy: This is what we want to change to, no need to check for it.
				if curr_tag == "hittable" or curr_tag == "mortal" or curr_tag == "human" then
					ComponentSetValue2(aoe, "entities_with_tag", "enemy")
				end
			end)

			local players = get_players()
			if #players > 0 then
				local player = players[1]
				ComponentObjectSetValue2(comp, "config_explosion", "dont_damage_this", player)

				edit_component(projectile, "ExplosionComponent", function(explosion, _v)
					print("Found explosion component, disabling friendly fire for it.")
					ComponentObjectSetValue2(explosion, "config_explosion", "dont_damage_this", player)
				end)

				edit_component(projectile, "LightningComponent", function(lightning, _v)
					print("Found LightningComponent, disabling friendly fire for it.")
					ComponentObjectSetValue2(lightning, "config_explosion", "dont_damage_this", player)
				end)
			end
		end
	end)
end