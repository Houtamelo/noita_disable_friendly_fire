-- Author: Nathan
---@class some_utils
local M = {}

M.forced_friendly_fire_dummy = EntityCreateNew("bloodlust_or_piercing_shot")

---@param entity entity_id
---@return entity_id
function M.get_projectile_root_shooter(entity)
    local projectile_comp = EntityGetFirstComponent(entity, "ProjectileComponent")

    if projectile_comp == nil then return entity end

    local who_shot = ComponentGetValue2(projectile_comp, "mWhoShot")
    if who_shot == 0 then return entity end

    --if entity == who_shot then return entity end

    return M.get_projectile_root_shooter(who_shot)
end

return M
