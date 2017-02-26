local Tiny = require (LIB_PATH .. "tiny.tiny")
local AnimationSystem = Tiny.processingSystem()

AnimationSystem.filter = Tiny.requireAll("sprite", "animator")

function AnimationSystem:process(e, dt)
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
