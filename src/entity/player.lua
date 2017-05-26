local Transform = require (RODA_SRC .. 'component.transform')
local Body = require (RODA_SRC .. 'component.body')
local Collider = require (RODA_SRC .. 'component.collider')
local Controller = require (RODA_SRC .. 'component.controller')
local player = {}

function player:new(position, size)
	local o = {}

	o.transform = Transform(position)
	o.body = Body(Vector(0, 0), Vector(0, 0), Vector(-0.15, 0.0))
	o.collider = Collider(Rect(position, size))
	o.controller = Controller(0.5)
	o.img = love.graphics.newImage('assets/images/B2.png')

	return setmetatable(o, { __index = self })
end

function player:jump()
	self.body.velocity.y = 13
end

function player:update(dt)

end

function player:draw()
	Roda:set_shader('outline')
	love.graphics.setColor(255, 0, 255)
	Roda.shader:send('stepSize', {
		1 / self.img:getWidth(),
		1 / self.img:getHeight()
	})
	love.graphics.draw(
		self.img,
		love.graphics.newQuad(0, 0, 32, 32, self.img:getDimensions()),
		self.transform.position.x - 16,
		self.transform.position.y - 16
	)

	love.graphics.setColor(255, 255, 255, 255)
	Roda:set_shader('default')
	love.graphics.draw(
		self.img,
		love.graphics.newQuad(0, 0, 32, 32, self.img:getDimensions()),
		self.transform.position.x - 16,
		self.transform.position.y - 16
	)

	--love.graphics.setColor(255, 0, 0, 150)
	--self.collider.shape:draw('fill')
end

return setmetatable(player, { __call = player.new })
