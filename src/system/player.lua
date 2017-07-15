local Tiny = require 'tiny'

local player = {}
player.__index = player

function player:new()
	local o = setmetatable({
		filter = Tiny.requireAll('controller', 'animator', 'sprite', 'transform'),
		isUpdateSystem = true
	}, player)

	return Tiny.processingSystem(o)
end

function player:onAdd(e)
	-- Player movement
	Roda.bus:register('input/pressed', function(button)
		if e.controller.player then
			if button == 'jump' then
				e.controller:jump()
			end
		end
	end)

	Roda.bus:register('input/pressing', function(button)
		if e.controller.player then
			if button == 'left' then
				e.controller:move_left()
			end
			if button == 'right' then
				e.controller:move_right()
			end
			if button == 'down' then
				e.controller:move_down()
			end
			if button == 'up' then
				e.controller:move_up()
			end
		end
	end)
end

function player:process(e, dt)
	if e.controller.forward or e.controller.backward then
		e.animator:set_animation('moving')

		if e.transform.facing == 'forward' and e.controller.backward then
			e.transform.facing = 'backward'
			e.transform.scale.x = e.transform.scale.x * - 1
		end

		if e.transform.facing == 'backward' and e.controller.forward then
			e.transform.facing = 'forward'
			e.transform.scale.x = e.transform.scale.x * -1
		end
	elseif e.controller.forward == false and e.controller.backward == false then
		e.animator:set_animation('idle')
	end

	-- Reset controller direction
	e.controller:reset()
end

return setmetatable(player, {
	__call = player.new
})
