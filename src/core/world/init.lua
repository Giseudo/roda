local Tiny = require 'tiny'

local world = {}
world.__index = world

function world:new()
	local o = Tiny.world()

	return setmetatable(o, world)
end

function world:init()
	Roda.bus:register('world/add', function(e)
		self:add(e)
		self:refresh()
	end)

	Roda.bus:register('world/remove', function(e)
		self:remove(e)
		self:refresh()
	end)
end

return setmetatable(world, {
	__index = Tiny,
	__call = world.new
})
