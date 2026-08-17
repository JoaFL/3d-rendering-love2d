local Vector3 = require("Vector3")
local MatrixMath = {}

---@param i Vector3
---@param m Mat4x4
---@return Vector3
function MatrixMath.multiplyMatrixVector(i, m)
	local o = { x = 0, y = 0, z = 0 }

	o.x = i.x * m[1][1] + i.y * m[2][1] + i.z * m[3][1] + m[4][1]
	o.y = i.x * m[1][2] + i.y * m[2][2] + i.z * m[3][2] + m[4][2]
	o.z = i.x * m[1][3] + i.y * m[2][3] + i.z * m[3][3] + m[4][3]
	local w = i.x * m[1][4] + i.y * m[2][4] + i.z * m[3][4] + m[4][4]

	if w ~= 0 then
		o.x = o.x / w
		o.y = o.y / w
		o.z = o.z / w
	end

	return Vector3.new(o.x, o.y, o.z)
end

return MatrixMath
