local Tiny = require "tiny"
local animation_system = Tiny.system()

function animation_system:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("animator", "sprite")

	return self
end

function animation_system:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

function animation_system:update(e, dt)
	if e.animator.current == nil then
		return
	end

	if e.animator.timer > e.animator.current[3] then
		e.sprite:setFrame(e.animator:next())
		e.animator.timer = 0
	else
		e.animator.timer = e.animator.timer + dt
	end
end


return setmetatable(animation_system, { __call = animation_system.new })
