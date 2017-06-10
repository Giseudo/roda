local Tiny = require 'tiny'

local player = {}
player.__index = player

function player:new()
	local o = setmetatable({
		isUpdateSystem = true
	}, player)

	return Tiny.processingSystem(o)
end

function player:filter(e)
	if e.controller then
		return e.controller.player == true
	end

	return false
end

function player:onAdd(e)
	-- Player movement
	Roda.bus:register('input/pressed', function(button)
		if button == 'jump' then
			e.controller:jump()
		end
	end)

	Roda.bus:register('input/pressing', function(button)
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
	end)
end

function player:process(e, dt)
end

return setmetatable(player, {
	__call = player.new
})
