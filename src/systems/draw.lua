local Tiny = require (LIB_PATH .. "tiny.tiny")
local DrawSystem = Tiny.system()

function DrawSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "transform")

	return self
end

function DrawSystem:onAdd(e)
	self.bus:register("draw", function (dt)
		self:draw(e, dt)
	end)
end

function DrawSystem:draw(e, dt)
	love.graphics.draw(
		e.sprite.image,
		e.sprite.quad,
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2
	)
end


return DrawSystem
