local Tiny = require 'tiny'

local world = {}
world.__index = world

function world:new()
	local o = Tiny.world()

	return setmetatable(o, world)
end

return setmetatable(world, {
	__index = Tiny,
	__call = world.new
})
