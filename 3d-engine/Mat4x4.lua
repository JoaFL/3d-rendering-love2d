---@class Mat4x4
---@field m table<table<number>>
local Mat4x4 = {}
Mat4x4.__index = Mat4x4

function Mat4x4.new()
	local self = setmetatable({
		m = {
			{ 0, 0, 0, 0 },
			{ 0, 0, 0, 0 },
			{ 0, 0, 0, 0 },
			{ 0, 0, 0, 0 },
		},
	}, Mat4x4)

	return self
end

return Mat4x4
