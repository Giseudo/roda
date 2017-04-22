local camera = {}

function camera:new(x, y, width, height)
	return setmetatable(
		{
			position = Vector(x or 0, y or 0),
			width = width or 320,
			height = height or 200,
			rotation = 0,
			fov = 2
		},
		{ __index = camera }
	)
end

function camera:follow(target)
	self:move(
		(target.position.x - self.position.x) * 2 * love.timer.getDelta(),
		0.0
		--(target.position.y - self.position.y) * 2 * love.timer.getDelta()
	)
end

function camera:move(x, y)
	self.position.x = self.position.x + x or 0
	self.position.y = self.position.y + y or 0
end

function camera:set()
	local x = math.floor(love.graphics.getWidth() / 2) / roda.scale
	local y = math.floor(love.graphics.getHeight() / 2) / roda.scale

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.rotate(- self.rotation)
	love.graphics.scale(1 / self.fov, 1 / - self.fov)
	love.graphics.translate(
		- self.position.x + x * self.fov,
		- self.position.y - y * self.fov
	)

	-- Stencil Mask
	love.graphics.stencil(function()
		love.graphics.rectangle(
			"fill",
			self.position.x - self.width * self.fov / 2,
			self.position.y - self.height * self.fov / 2,
			self.width * self.fov,
			self.height * self.fov
		)
	end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
end

function camera:move(x, y)
	self.position.x = x
	self.position.y = y
end

function camera:unset()
	love.graphics.setStencilTest()
	love.graphics.pop()
end

function camera:move(x, y)
	self.position.x = self.position.x + (x or 0)
	self.position.y = self.position.y + (y or 0)
end

function camera:rotate(dt)
	self.rotation = self.rotation + dt
end

function camera:zoom(speed)
	speed = speed or 1
	self.fov = self.fov + speed * love.timer.getDelta()
end

return setmetatable(camera, { __call = camera.new })
