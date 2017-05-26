local Transform = require (RODA_SRC .. 'component.transform')
local camera = {}

function camera:new(position, width, height)
	local o = {}

	o.transform = Transform(position or Vector(0, 0))
	o.width = width or 320
	o.height = height or 200
	o.rotation = 0
	o.fov = 1.5
	o.viewport = Rect(position, Vector(o.width * 2, o.height * 2))

	return setmetatable(o, { __index = camera })
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

	self.viewport.position = self.transform.position

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

function camera:mousePosition()
	local position = Vector(
		love.mouse.getX() * self.fov,
		love.mouse.getY() * self.fov
	)

	-- Center position on the middle of screen & invert Y axis
	position.x = position.x - love.graphics.getWidth() / 2 * self.fov
	position.y = -position.y + love.graphics.getHeight() / 2 * self.fov

	-- Divide by engine scale
	position = position / Roda.scale

	-- Sum with camera position
	return position + self.transform.position
end

function camera:zoom(speed)
	speed = speed or 1
	self.fov = self.fov + speed * love.timer.getDelta()

	-- Update viewport size
	self.viewport.size.x = self.width * self.fov
	self.viewport.size.y = self.height * self.fov
end

return setmetatable(camera, { __call = camera.new })
