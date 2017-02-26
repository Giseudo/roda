local Tiny = require (LIB_PATH .. "tiny.tiny")
local DebugSystem = Tiny.system()

function DebugSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "transform")


	return self
end

function DebugSystem:onAdd(e, dt)
	self.bus:register("draw", function (dt)
		self:draw(e, dt)
	end)
end

function DebugSystem:draw(e, dt)
	love.graphics.rectangle(
		"line",
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2,
		e.sprite.width,
		e.sprite.height
	)

end


return DebugSystem
