local Transform = require (RODA_SRC .. 'component.transform')
local Body = require (RODA_SRC .. 'component.body')
local Collider = require (RODA_SRC .. 'component.collider')
local Controller = require (RODA_SRC .. 'component.controller')
local player = {}

function player:new(position, size)
	return setmetatable({
		transform = Transform(position),
		body = Body(Vector(0, 0), Vector(0, 0), Vector(-0.15, 0.0)),
		collider = Collider(Rect(position, size)),
		controller = Controller(0.5)
	},
	{ __index = self })
end

function player:jump()
	self.body.velocity.y = 13
end

function player:update(dt)

end

function player:draw()
	love.graphics.setColor(255, 0, 0, 150)
	self.collider.shape:draw('fill')
end

return setmetatable(player, { __call = player.new })
