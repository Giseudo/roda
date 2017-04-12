local camera = {}
local parent = {}
function parent:new()
	return setmetatable({}, { __index = self })
end
function parent:test()
	print("OMG ITS WORKING")
end

-- FIGURE OUT WHY INHERITANCE NEVER WORKS
function camera:new(x, y, width, height)
	self = parent:new()
	self:test()
	return setmetatable(
		{
			x = x or 0,
			y = y or 0,
			width = width or 320,
			height = height or 200,
			rotation = 0,
			zoom = 2
		},
		{ __index = camera }
	)
end

function camera:set()
	x = self.x + math.floor(love.graphics.getWidth() / 2) / roda.scale
	y = self.y + math.floor(love.graphics.getHeight() / 2) / roda.scale

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(1 / self.zoom, 1 / -self.zoom)
	love.graphics.translate(x * self.zoom, -y * self.zoom)

	-- Stencil Mask
	love.graphics.stencil(function()
		love.graphics.rectangle(
			"fill",
			(- self.width / 2) * self.zoom,
			(- self.height / 2) * self.zoom,
			self.width * self.zoom,
			self.height * self.zoom
		)
	end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
end

function camera:unset()
	love.graphics.setStencilTest()
	love.graphics.pop()
	--print(self:test())
end

function camera:move(dx, dy)
	self.x = self.x + (dx or 0)
	self.y = self.y + (dy or 0)
end

function camera:rotate(dt)
	self.rotation = self.rotation + dr
end

function camera:zoom(sz)
	sz = sz or 1
	self.zoom = self.zoom * sz
end

return setmetatable(camera, { __call = camera.new })
