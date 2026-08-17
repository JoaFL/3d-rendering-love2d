local Vector3 = require("Vector3")

local Matrix = {}

function Matrix.vecToMatrix(v) -- v={x=5, y=10, z=2}
	return { --		______
		{ v.x }, -- [ +5 ]
		{ v.y }, -- [ 10 ]
		{ v.z }, -- [ +2 ]
	} -- 			------
end

--[[______
	[ +5 ]
	[ 10 ]
	[ +2 ]
	------
]]
function Matrix.matrixToVec(m) -- m=[{5} , {10} , {2}]
	-- {5, 10, 2}
	return Vector3.new(m[1][1], m[2][1], #m > 2 and m[3][1] or 0)
end

function Matrix.logMatrix(m)
	local COLS = #m[1]
	local ROWS = #m

	local s = ""
	for i = 1, ROWS do
		s = ""
		for j = 1, COLS do
			s = s .. tostring(m[i][j]) .. " "
		end
		print(s)
	end
	print()
end

function Matrix.matmulvec(a, vec)
	local m = Matrix.vecToMatrix(vec)
	local r = Matrix.matmul(a, m)

	return Matrix.matrixToVec(r)
end

function Matrix.matmul(a, b)
	if b.x and b.y and b.z then
		return Matrix.matmulvec(a, b)
	end

	local colsA = #a[1]
	local rowsA = #a
	local colsB = #b[1]
	local rowsB = #b

	if colsA ~= rowsB then
		error("Columns of A must match rows of B")
	end

	local result = {}
	for j = 1, rowsA do
		result[j] = {}
		for i = 1, colsB do
			local sum = 0
			for n = 1, colsA do
				sum = sum + a[j][n] * b[n][i]
			end
			result[j][i] = sum
		end
	end

	return result
end

return Matrix
