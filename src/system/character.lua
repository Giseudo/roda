local Tiny = require 'tiny'

local character = {}
character.__index = character

function character:new()
	local o = setmetatable({
		filter = Tiny.requireAll('controller', 'animator', 'sprite', 'transform'),
		isUpdateSystem = true
	}, character)

	return Tiny.processingSystem(o)
end

function character:onAdd(e)
end

function character:process(e, dt)
	if e.controller.forward or e.controller.backward then
		if e.transform.facing == 'forward' and e.controller.backward then
			e.transform.facing = 'backward'
			e.transform.scale.x = e.transform.scale.x * - 1
		end

		if e.transform.facing == 'backward' and e.controller.forward then
			e.transform.facing = 'forward'
			e.transform.scale.x = e.transform.scale.x * -1
		end
	end

	if e.controller.dashing == true then
		if e.animator.animations['dash_2'] then
			e.animator:set_animation('dash_2')
		end
	elseif e.controller.flying == true then
		if e.animator.animations['flying'] then
			e.animator:set_animation('flying')
		end
	elseif e.controller.forward or e.controller.backward then
		e.animator:set_animation('moving')
	elseif e.controller.forward == false and e.controller.backward == false then
		if e.animator.animations['idle'] then
			e.animator:set_animation('idle')
		end
	end

	-- Reset controller direction
	e.controller:reset()
end

return setmetatable(character, {
	__call = character.new
})
