local Tiny = require (LIB_PATH .. "tiny.tiny")
local AnimationSystem = Tiny.system()

function AnimationSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "animator")

	return self
end

function AnimationSystem:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

function AnimationSystem:update(e, dt)
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


return AnimationSystem
