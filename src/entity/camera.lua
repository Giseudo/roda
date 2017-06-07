local Transform = require (RODA_SRC .. 'component.transform')
local camera = {}

function camera:new(position, scale)
	local o = {}

	o.transform = Transform(position, scale)
	o.rotation = 0
	o.viewport = Rect(position, Vector(
		love.graphics.getWidth() / o.transform.scale.x,
		love.graphics.getHeight() / o.transform.scale.y
	))

	return setmetatable(o, { __index = camera })
end

function camera:follow(target)
	self:move(
		(target.transform.position.x - self.transform.position.x) * 3 * love.timer.getDelta(),
		(target.transform.position.y - self.transform.position.y + 50.0) * 3 * love.timer.getDelta()
	)
end

function camera:move(x, y)
	self.transform.position.x = self.transform.position.x + x or 0
	self.transform.position.y = self.transform.position.y + y or 0
end

function camera:set()
	local x = math.floor(love.graphics.getWidth() / 2) / self.transform.scale.x
	local y = math.floor(love.graphics.getHeight() / 2) / self.transform.scale.y

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.scale(self.transform.scale.x, - self.transform.scale.y)
	love.graphics.rotate(- self.rotation)
	love.graphics.translate(
		- self.transform.position.x + x,
		- self.transform.position.y - y
	)

	self.viewport.position = self.transform.position
end

function camera:move(x, y)
	self.transform.position.x = x
	self.transform.position.y = y
end

function camera:unset()
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
		love.mouse.getX(),
		love.mouse.getY()
	)

	-- Center position on the middle of screen & invert Y axis
	position.x = position.x - love.graphics.getWidth() / 2
	position.y = -position.y + love.graphics.getHeight() / 2

	-- Divide by engine scale
	position = position / self.transform.scale

	-- Sum with camera position
	return position + self.transform.position
end

function camera:zoom(value)
	self.transform.scale.x = math.max(math.min(self.transform.scale.x + value, 4), 1)
	self.transform.scale.y = math.max(math.min(self.transform.scale.y + value, 4), 1)

	-- Update viewport size
	self.viewport.size.x = love.graphics.getWidth() / self.transform.scale.x
	self.viewport.size.y = love.graphics.getHeight() / self.transform.scale.y
end

return setmetatable(camera, { __call = camera.new })
