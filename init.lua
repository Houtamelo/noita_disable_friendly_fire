function OnPlayerSpawned(player_entity)
	print("Player spawned, disabling friendly fire")
    EntityAddComponent(player_entity, "LuaComponent",
        {
            script_damage_about_to_be_received = "mods/disable_friendly_fire_v2/files/deny_friendly_fire.lua",
            script_shot = "mods/disable_friendly_fire_v2/files/deny_friendly_fire.lua",
            remove_after_executed = "0",
            execute_every_n_frame = "-1",
        }
    )
end

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/disable_friendly_fire_v2/files/gun_actions.lua")