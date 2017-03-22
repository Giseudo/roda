local Class = require 'middleclass'
local Tiny = require 'tiny'

local world = Class('World')
world:include(Tiny.world())

function world:initialize(bus)
	self.bus = bus
end

function world:included()
	self:bind()
end

function world:bind()
	self.bus:register('world/add', function(e)
		self:add(e)
		self:refresh()
	end)
end

return world
