local Mesh = require("Mesh")
local Triangle = require("Triangle")
local Vector3 = require("Vector3")
local Mat4x4 = require("Mat4x4")
local MatrixMath = require("MatrixMath")

local SCREEN_WIDTH = love.graphics.getWidth()
local SCREEN_HEIGHT = love.graphics.getHeight()
local F_NEAR = 0.1
local F_FAR = 1000.0
local F_VOV = 90.0
local F_ASPECT_RATIO = SCREEN_HEIGHT / SCREEN_WIDTH
local F_FOV_RAD = 1.0 / math.tan(F_VOV * 0.5 / 180.0 * math.pi)

local meshCube = Mesh.new({
	-- SOUTH
	Triangle.new(Vector3.new(0, 0, 0), Vector3.new(0, 1, 0), Vector3.new(1, 1, 0)),
	Triangle.new(Vector3.new(0, 0, 0), Vector3.new(1, 1, 0), Vector3.new(1, 0, 0)),

	-- EAST
	Triangle.new(Vector3.new(1, 0, 0), Vector3.new(1, 1, 0), Vector3.new(1, 1, 1)),
	Triangle.new(Vector3.new(1, 0, 0), Vector3.new(1, 1, 1), Vector3.new(1, 0, 1)),

	-- NORTH
	Triangle.new(Vector3.new(1, 0, 1), Vector3.new(1, 1, 1), Vector3.new(0, 1, 1)),
	Triangle.new(Vector3.new(1, 0, 1), Vector3.new(0, 1, 1), Vector3.new(0, 0, 1)),

	-- WEST
	Triangle.new(Vector3.new(0, 0, 1), Vector3.new(0, 1, 1), Vector3.new(0, 1, 0)),
	Triangle.new(Vector3.new(0, 0, 1), Vector3.new(0, 1, 0), Vector3.new(0, 0, 0)),

	-- TOP
	Triangle.new(Vector3.new(0, 1, 0), Vector3.new(0, 1, 1), Vector3.new(1, 1, 1)),
	Triangle.new(Vector3.new(0, 1, 0), Vector3.new(1, 1, 1), Vector3.new(1, 1, 0)),

	-- BOTTOM
	Triangle.new(Vector3.new(1, 0, 1), Vector3.new(0, 0, 1), Vector3.new(0, 0, 0)),
	Triangle.new(Vector3.new(1, 0, 1), Vector3.new(0, 0, 0), Vector3.new(1, 0, 0)),
})

local matProj = Mat4x4.new()
matProj.m[1][1] = F_ASPECT_RATIO * F_FOV_RAD
matProj.m[2][2] = F_FOV_RAD
matProj.m[3][3] = F_FAR / (F_FAR - F_NEAR)
matProj.m[4][3] = (-F_FAR * F_NEAR) / (F_FAR - F_NEAR)
matProj.m[3][4] = 1.0
matProj.m[4][4] = 0.0

local matRotZ = Mat4x4.new()
local matRotX = Mat4x4.new()
local fTheta = 0

function love.load() end

function love.update(dt)
	fTheta = fTheta + 1 * dt

	matRotZ.m[1][1] = math.cos(fTheta)
	matRotZ.m[1][2] = math.sin(fTheta)
	matRotZ.m[2][1] = -math.sin(fTheta)
	matRotZ.m[2][2] = math.cos(fTheta)
	matRotZ.m[3][3] = 1
	matRotZ.m[4][4] = 1

	matRotX.m[1][1] = 1
	matRotX.m[2][2] = math.cos(fTheta * 0.5)
	matRotX.m[2][3] = math.sin(fTheta * 0.5)
	matRotX.m[3][2] = -math.sin(fTheta * 0.5)
	matRotX.m[3][3] = math.cos(fTheta * 0.5)
	matRotX.m[4][4] = 1
end

function love.draw()
	---@param triangle Triangle
	for _, triangle in ipairs(meshCube.triangles) do
		local triRotatedZ = Triangle.new(
			MatrixMath.multiplyMatrixVector(triangle.points[1], matRotZ.m),
			MatrixMath.multiplyMatrixVector(triangle.points[2], matRotZ.m),
			MatrixMath.multiplyMatrixVector(triangle.points[3], matRotZ.m)
		)

		local triRotatedZX = Triangle.new(
			MatrixMath.multiplyMatrixVector(triRotatedZ.points[1], matRotX.m),
			MatrixMath.multiplyMatrixVector(triRotatedZ.points[2], matRotX.m),
			MatrixMath.multiplyMatrixVector(triRotatedZ.points[3], matRotX.m)
		)

		local triTranslated = Triangle.new(
			Vector3.new(triRotatedZX.points[1].x, triRotatedZX.points[1].y, triRotatedZX.points[1].z + 3),
			Vector3.new(triRotatedZX.points[2].x, triRotatedZX.points[2].y, triRotatedZX.points[2].z + 3),
			Vector3.new(triRotatedZX.points[3].x, triRotatedZX.points[3].y, triRotatedZX.points[3].z + 3)
		)

		local triProjected = Triangle.new(
			MatrixMath.multiplyMatrixVector(triTranslated.points[1], matProj.m),
			MatrixMath.multiplyMatrixVector(triTranslated.points[2], matProj.m),
			MatrixMath.multiplyMatrixVector(triTranslated.points[3], matProj.m)
		)

		for _, v in ipairs(triProjected.points) do
			v.x = (v.x + 1) * (0.5 * SCREEN_WIDTH)
			v.y = (v.y + 1) * (0.5 * SCREEN_HEIGHT)
		end

		love.graphics.polygon(
			"line",
			triProjected.points[1].x,
			triProjected.points[1].y,
			triProjected.points[2].x,
			triProjected.points[2].y,
			triProjected.points[3].x,
			triProjected.points[3].y
		)

		love.graphics.circle("fill", triProjected.points[1].x, triProjected.points[1].y, 5)
	end
end
