local Tiny = require (LIB_PATH .. "tiny.tiny")
local UpdateSystem = Tiny.system()

function UpdateSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("update")

	return self
end

function UpdateSystem:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

function UpdateSystem:update(e, dt)
	e:update(dt)
end


return UpdateSystem
