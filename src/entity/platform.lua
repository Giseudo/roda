local Collider = require (RODA_SRC .. 'component.collider')
local platform = {}

function platform:new(position, size)
	return setmetatable({
		position = position,
		collider = Collider(Rect(position, size), true)
	},
	{ __index = self })
end

function platform:update()
	self.collider.shape.position = position
end

function platform:draw()
	love.graphics.setColor(0, 255, 0, 150)
	self.collider.shape:draw('fill')
end

return setmetatable(platform, { __call = platform.new })


