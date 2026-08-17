---@class Vertex
---@field x number
---@field y number
---@field z number
local Vertex = {}
Vertex.__index = Vertex

---@param x number
---@param y number
---@param z number
---@return Vertex
function Vertex.new(x, y, z)
	local self = setmetatable({
		x = x,
		y = y,
		z = z,
	}, Vertex)

	return self
end

function Vertex:Draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.x, self.y, 5)
	--love.graphics.arc("fill", self.x, self.y, 5, 0, 2 * math.pi)
	--love.graphics.arc(drawmode (DrawMode), x (number), y (number), radius (number), angle1 (number), angle2 (number), segments (number))
end

return Vertex
