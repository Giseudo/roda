local Tiny = require 'tiny'

local animation = {}
animation.__index = animation

function animation:new()
	local o = setmetatable({
		filter = Tiny.requireAll('animator', 'sprite'),
		isUpdateSystem = true
	}, animation)

	return Tiny.processingSystem(o)
end

function animation:onAdd(e)
	e.sprite.frame = e.animator.current.start
end

function animation:process(e, dt)
	e.animator.timer = e.animator.timer + dt

	if e.animator.timer > e.animator.speed then
		e.animator.timer = 0

		if e.animator.frame > e.animator.current.start + e.animator.current.length then
			e.animator.frame = e.animator.current.start
		end

		e.sprite.frame = e.animator.frame
		e.animator.frame = e.animator.frame + 1
	end
end

return setmetatable(animation, {
	__call = animation.new
})
