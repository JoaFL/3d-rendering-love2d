---@class Triangle
---@field points table<Vector3>
local Triangle = {}
---@private
Triangle.__index = Triangle

---@param p1 Vector3
---@param p2 Vector3
---@param p3 Vector3
---@return Triangle
function Triangle.new(p1, p2, p3)
	local self = setmetatable({
		points = { p1, p2, p3 },
	}, Triangle)

	return self
end

return Triangle
