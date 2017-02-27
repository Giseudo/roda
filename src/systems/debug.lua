local Tiny = require (LIB_PATH .. "tiny.tiny")
local DebugSystem = Tiny.system()

function DebugSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "transform")

	return self
end

function DebugSystem:onAdd(e, dt)
	self.bus:register("scene/draw", function (dt)
		self:draw(e, dt)
	end)
end

function DebugSystem:draw(e, dt)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle(
		"line",
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2,
		e.sprite.width,
		e.sprite.height
	)
	love.graphics.setColor(255, 255, 255, 255)
end


return DebugSystem
