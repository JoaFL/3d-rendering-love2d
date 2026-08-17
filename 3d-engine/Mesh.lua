---@class Mesh
---@field triangles table<Vector3>
local Mesh = {}
---@private
Mesh.__index = Mesh

---@param triangles table<Vector3>
---@return Mesh
function Mesh.new(triangles)
	local self = setmetatable({
		triangles = triangles,
	}, Mesh)

	return self
end

return Mesh
