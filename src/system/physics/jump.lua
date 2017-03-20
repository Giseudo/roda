local Class = require 'middleclass'
local Tiny = require 'tiny'
local Vector = require (RODA_LIB .. 'hump.vector')
local System = require (RODA_SRC .. 'system')

local jump_system = Class('JumpSystem', System)

function jump_system:initialize(bus)
	System.initialize(self, bus)

	self.filter = Tiny.requireAll('transform', 'rigidbody', 'agent')
end

function jump_system:bind()
	self.bus:register('physics/jump', function (e, velocity)
		if e.rigidbody:is_grounded() then
			self.bus:emit('physics/translate', e, velocity)
		end
	end)
end

function jump_system:on_add(e)
	print(e.name)
end

return jump_system
