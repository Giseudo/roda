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
	e.sprite.frame = e.animator.start
end

function animation:process(e, dt)
	e.animator.timer = e.animator.timer + dt

	if e.animator.timer > e.animator.speed then
		e.sprite.frame = e.sprite.frame + 1
		e.animator.timer = 0

		if e.sprite.frame > e.animator.start + e.animator.length then
			e.sprite.frame = e.animator.start
		end
	end
end

return setmetatable(animation, {
	__call = animation.new
})
