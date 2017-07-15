local Transform = require (RODA_SRC .. 'component.transform')
local camera = {}

function camera:new(position, scale)
	local o = {}

	o.transform = Transform(position, scale)
	o.rotation = 0
	o.background = nil
	o.viewport = Rect(position, Vector(
		love.graphics.getWidth() / o.transform.scale.x,
		love.graphics.getHeight() / o.transform.scale.y
	))
	o.target = {}
	o.follow = 'both' -- both, horizontal, vertical

	return setmetatable(o, { __index = camera })
end

function camera:get_coords(x, y)
	local position = Vector(x, y)

	-- Center position on the middle of screen & invert Y axis
	position.x = position.x - love.graphics.getWidth() / 2
	position.y = - position.y + love.graphics.getHeight() / 2

	position = position / self.transform.scale
	position = position + self.transform.position

	return position
end

function camera:set_background(image)
	self.background = love.graphics.newImage(image)
end

function camera:zoom(value)
	self.transform.scale.x = math.max(math.min(self.transform.scale.x + value, 4), 1)
	self.transform.scale.y = math.max(math.min(self.transform.scale.y + value, 4), 1)

	-- Update viewport size
	self.viewport.size.x = love.graphics.getWidth() / self.transform.scale.x
	self.viewport.size.y = love.graphics.getHeight() / self.transform.scale.y
end

return setmetatable(camera, { __call = camera.new })
