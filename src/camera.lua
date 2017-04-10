local camera = {}

function camera:new()
	self.x = 0
	self.y = 0
	self.width = 320
	self.height = 240
	self.rotation = 0
	self.zoom = 1

	return self
end

function camera:set()
	x = math.floor(love.graphics.getWidth() / 2) / roda.multiplier
	y = math.floor(love.graphics.getHeight() / 2) / roda.multiplier

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
