-- Author: Nathan
---@class some_utils
local M = {}

M.forced_friendly_fire_dummy = EntityCreateNew("bloodlust_or_piercing_shot")

---@param entity entity_id
---@param recursion_depth int
---@return entity_id
function M.get_projectile_root_shooter(entity, recursion_depth)
	if recursion_depth > 20 then return entity end

    local projectile_comp = EntityGetFirstComponent(entity, "ProjectileComponent")

    if projectile_comp == nil then return entity end

    local who_shot = ComponentGetValue2(projectile_comp, "mWhoShot")
    if who_shot == nil or who_shot == 0 then return entity end

    --if entity == who_shot then return entity end

    return M.get_projectile_root_shooter(who_shot, recursion_depth + 1)
end

return M
