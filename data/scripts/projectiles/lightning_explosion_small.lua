dofile_once("data/scripts/lib/utilities.lua")

---@type some_utils
local some_utils = dofile_once("mods/disable_friendly_fire_v2/files/some_utils.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local shooter = some_utils.get_projectile_root_shooter(entity_id)

local how_many = 4
angle_inc = ( 2 * 3.14159 ) / how_many + math.rad(ProceduralRandomf( pos_x, pos_y, 30) - ProceduralRandomf( pos_x + 2.5532, pos_y + 59.8, 30))
local theta = 0
local length = 2500
print("gs")

for i=1,how_many do
	local vel_x = math.cos( theta ) * length
	local vel_y = math.sin( theta ) * length
	theta = theta + angle_inc

	local projectile = shoot_projectile( entity_id, "data/entities/projectiles/deck/lightning.xml", pos_x, pos_y, vel_x, vel_y )

	if shooter ~= some_utils.forced_friendly_fire_dummy then
		edit_component(projectile, "LightningComponent", function(lightning, _v)
			print("Found LightningComponent, disabling friendly fire for it.")
			ComponentObjectSetValue2(lightning, "config_explosion", "dont_damage_this", shooter)
		end)
	end
end
