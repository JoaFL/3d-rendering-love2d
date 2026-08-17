---@class Vector3
---@field x number
---@field y number
---@field z number
---@field Magnitude number
---@field Unit Vector3
---@operator add(Vector3): Vector3
---@operator sub(Vector3): Vector3
---@operator mul(Vector3 | number): Vector3
---@operator div(Vector3 | number): Vector3
---@operator unm: Vector3
local Vector3 = {}
---@private
function Vector3.__index(self, key)
	if key == "Magnitude" then
		return math.sqrt((self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2))
	end

	if key == "Unit" then
		local magnitude = self.Magnitude

		return Vector3.new(self.x / magnitude, self.y / magnitude, self.z / magnitude)
	end

	return rawget(Vector3, key)
end

---@private
function Vector3.__add(a, b)
	return Vector3.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

---@private
function Vector3.__sub(a, b)
	return Vector3.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

---@private
function Vector3.__mul(a, b)
	if type(b) == "number" then
		return Vector3.new(a.x * b, a.y * b, a.z * b)
	end

	return Vector3.new(a.x * b.x, a.y * b.y, a.z * b.z)
end

---@private
function Vector3.__div(a, b)
	if type(b) == "number" then
		return Vector3.new(a.x / b, a.y / b, a.z / b)
	end

	return Vector3.new(a.x / b.x, a.y / b.y, a.z / b.z)
end

---@private
function Vector3.__unm(self)
	return Vector3.new(-self.x, -self.y, -self.z)
end

---@private
function Vector3.__eq(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

---@private
function Vector3.__tostring(self)
	return string.format("(%.2f, %.2f, %.2f)", self.x, self.y, self.z)
end

---@private
function Vector3.__concat(a, b)
	return tostring(a) .. tostring(b)
end

---@param x number?
---@param y number?
---@param z number?
---@return Vector3
function Vector3.new(x, y, z)
	local self = setmetatable({
		x = x or 0,
		y = y or 0,
		z = z or 0,
	}, Vector3)

	return self
end

return Vector3
