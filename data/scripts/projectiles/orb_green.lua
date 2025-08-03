dofile_once("data/scripts/lib/utilities.lua")

local source = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(source)

local herd = 0
local source_projectile = EntityGetComponent(source, "ProjectileComponent")
if (source_projectile ~= nil) then
    herd = ComponentGetValue2(source_projectile, "mShooterHerdId")
end

local how_many = 8
local angle_inc = (2 * 3.14159) / how_many
local theta = 0.
local length = 100

for i = 1, how_many do
    GameEntityPlaySound(source, "duplicate")
    local child = EntityLoad("data/entities/projectiles/orb_green.xml", pos_x, pos_y)

    local child_projectile = EntityGetComponent(child, "ProjectileComponent")
    if (child_projectile ~= nil) then
        ComponentSetValue2(child_projectile, "mWhoShot", source)
        ComponentSetValue2(child_projectile, "mShooterHerdId", source)
    end

    local vel_x = math.cos(theta) * length
    local vel_y = math.sin(theta) * length
    theta = theta + angle_inc

    local child_velocity = EntityGetComponent(child, "VelocityComponent")

    if (child_velocity ~= nil) then
        ComponentSetValueVector2(child_velocity, "mVelocity", vel_x, vel_y)
    end
end
