local camera = {}

function camera:new(x, y, width, height)
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

function camera:follow(target)
	self:move(
		(target.position.x - self.x) * 2 * love.timer.getDelta(),
		(target.position.y - self.y) * 2 * love.timer.getDelta()
	)
end

function camera:move(x, y)
	self.x = self.x + x or 0
	self.y = self.y + y or 0
end

function camera:set()
	local x = math.floor(love.graphics.getWidth() / 2) / roda.scale
	local y = math.floor(love.graphics.getHeight() / 2) / roda.scale

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.rotate(- self.rotation)
	love.graphics.scale(1 / self.zoom, 1 / - self.zoom)
	love.graphics.translate(
		- self.x + x * self.zoom,
		- self.y - y * self.zoom
	)

	-- Stencil Mask
	love.graphics.stencil(function()
		love.graphics.rectangle(
			"fill",
			self.x - self.width * self.zoom / 2,
			self.y - self.height * self.zoom / 2,
			self.width * self.zoom,
			self.height * self.zoom
		)
	end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
end

function camera:move(x, y)
	self.x = x
	self.y = y
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
