local Matrix = require("Matrix")
local Vector3 = require("Vector3")

local CW = love.graphics.getPixelWidth()
local CH = love.graphics.getPixelHeight()
local CW2 = CW / 2
local CH2 = CH / 2

local angle = 0

local cube = { --      x    y    z
	[1] = Vector3.new(200, 100, -50),
	[2] = Vector3.new(300, 100, -50),
	[3] = Vector3.new(300, 200, -50),
	[4] = Vector3.new(200, 200, -50),
	[5] = Vector3.new(200, 100, 50),
	[6] = Vector3.new(300, 100, 50),
	[7] = Vector3.new(300, 200, 50),
	[8] = Vector3.new(200, 200, 50),
}

local triangles = {
	{ v = { 1, 2, 3 }, color = { 255, 0, 0 } },
	{ v = { 1, 4, 3 }, color = { 255, 0, 0 } },

	{ v = { 2, 6, 7 }, color = { 0, 255, 0 } },
	{ v = { 2, 3, 7 }, color = { 0, 255, 0 } },

	{ v = { 6, 5, 8 }, color = { 0, 0, 255 } },
	{ v = { 6, 7, 8 }, color = { 0, 0, 255 } },

	{ v = { 5, 1, 4 }, color = { 255, 255, 0 } },
	{ v = { 5, 8, 4 }, color = { 255, 255, 0 } },

	{ v = { 5, 6, 2 }, color = { 0, 255, 255 } },
	{ v = { 5, 1, 2 }, color = { 0, 255, 255 } },

	{ v = { 4, 8, 7 }, color = { 255, 0, 255 } },
	{ v = { 4, 3, 7 }, color = { 255, 0, 255 } },
}

local rotationZ = {}
local rotationX = {}
local rotationY = {}

local projection = {
	{ 1, 0, 0 },
	{ 0, 1, 0 },
	{ 0, 0, 1 },
}

---@param points table<Vertex>
---@return table
local function getCenter(points)
	local minX, maxX = math.huge, -math.huge
	local minY, maxY = math.huge, -math.huge
	local minZ, maxZ = math.huge, -math.huge

	---@param p Vertex
	for _, p in ipairs(points) do
		minX = math.min(minX, p.x)
		maxX = math.max(maxX, p.x)

		minY = math.min(minY, p.y)
		maxY = math.max(maxY, p.y)

		minZ = math.min(minZ, p.z)
		maxZ = math.max(maxZ, p.z)
	end

	return Vector3.new((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2)
end

local function connect(i, j, points)
	local a = points[i]
	local b = points[j]

	return love.graphics.line(a.x, a.y, b.x, b.y)
end

local function drawTriangle(triangle, vertices)
	local a = vertices[triangle.v[1]]
	local b = vertices[triangle.v[2]]
	local c = vertices[triangle.v[3]]

	love.graphics.setColor(triangle.color[1] / 255, triangle.color[2] / 255, triangle.color[3] / 255)

	return love.graphics.polygon("fill", a.x, a.y, b.x, b.y, c.x, c.y)
end

function love.load()
	local a = Vector3.new(-4, -5, -6)
	local b = Vector3.new(2, 7, 9)
	local c = a + b

	print(c)
end

---@param dt number
function love.update(dt)
	rotationZ = {
		{ math.cos(angle), -math.sin(angle), 0 },
		{ math.sin(angle), math.cos(angle), 0 },
		{ 0, 0, 1 },
	}
	rotationX = {
		{ 1, 0, 0 },
		{ 0, math.cos(angle), -math.sin(angle) },
		{ 0, math.sin(angle), math.cos(angle) },
	}
	rotationY = {
		{ math.cos(angle), 0, math.sin(angle) },
		{ 0, 1, 0 },
		{ -math.sin(angle), 0, math.cos(angle) },
	}

	angle = angle + 1 * dt
end

function love.draw()
	local projecteds = {}

	local centerlized = getCenter(cube)
	for index, v in pairs(cube) do
		local translated = v - centerlized
		local rotated = Matrix.matmul(rotationZ, translated)
		rotated = Matrix.matmul(rotationY, rotated)
		rotated = Matrix.matmul(rotationX, rotated)
		local movedBack = rotated + centerlized
		local projected2d = Matrix.matmul(projection, movedBack)

		projecteds[index] = projected2d
	end

	-- love.graphics.setColor(0, 1, 0)
	-- love.graphics.setLineWidth(5)
	-- connect(1, 2, projecteds)
	-- connect(2, 3, projecteds)
	-- connect(3, 4, projecteds)
	-- connect(4, 1, projecteds)

	-- love.graphics.setColor(0, 0, 1)
	-- connect(5, 6, projecteds)
	-- connect(6, 7, projecteds)
	-- connect(7, 8, projecteds)
	-- connect(8, 5, projecteds)

	-- love.graphics.setColor(1, 0, 1)
	-- connect(1, 5, projecteds)
	-- connect(2, 6, projecteds)
	-- connect(3, 7, projecteds)
	-- connect(4, 8, projecteds)

	for _, triangle in ipairs(triangles) do
		drawTriangle(triangle, projecteds)
	end
end
