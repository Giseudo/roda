local Transform = require (RODA_SRC .. 'component.transform')
local camera = {}

function camera:new(position, width, height)
	return setmetatable(
		{
			transform = Transform(position or Vector(0, 0)),
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
		(target.transform.position.x - self.transform.position.x) * 4 * love.timer.getDelta(),
		(target.transform.position.y - self.transform.position.y + 50.0) * 4 * love.timer.getDelta()
	)
end

function camera:move(x, y)
	self.transform.position.x = self.transform.position.x + x or 0
	self.transform.position.y = self.transform.position.y + y or 0
end

function camera:set()
	local x = math.floor(love.graphics.getWidth() / 2) / Roda.scale
	local y = math.floor(love.graphics.getHeight() / 2) / Roda.scale

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.rotate(- self.rotation)
	love.graphics.scale(1 / self.fov, 1 / - self.fov)
	love.graphics.translate(
		- self.transform.position.x + x * self.fov,
		- self.transform.position.y - y * self.fov
	)

	-- Stencil Mask
	love.graphics.stencil(function()
		love.graphics.rectangle(
			"fill",
			self.transform.position.x - self.width * self.fov / 2,
			self.transform.position.y - self.height * self.fov / 2,
			self.width * self.fov,
			self.height * self.fov
		)
	end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
end

function camera:move(x, y)
	self.transform.position.x = x
	self.transform.position.y = y
end

function camera:unset()
	love.graphics.setStencilTest()
	love.graphics.pop()
end

function camera:move(x, y)
	self.transform.position.x = self.transform.position.x + (x or 0)
	self.transform.position.y = self.transform.position.y + (y or 0)
end

function camera:rotate(dt)
	self.rotation = self.rotation + dt
end

function camera:zoom(speed)
	speed = speed or 1
	self.fov = self.fov + speed * love.timer.getDelta()
end

return setmetatable(camera, { __call = camera.new })
