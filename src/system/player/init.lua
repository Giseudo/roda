local Class = require 'middleclass'
local Tiny = require 'tiny'
local Vector = require (RODA_LIB .. 'hump.vector')
local System = require (RODA_SRC .. 'system')

local player_system = Class('PlayerSystem', System)

function player_system:initialize()
	System.initialize(self)

	self.filter = Tiny.requireAll('controller', 'transform', 'rigidbody')
end

function player_system:bind()

end

function player_system:on_add(e)
	self:subscribe(e)

	Roda.bus:register('update', function (dt)
		Roda.bus:emit('player/moved', e, dt)
	end)
end

function player_system:subscribe(e)
	Roda.bus:register('input/released', function (key)
		if key == 'left' or key == 'right' then
			e.animator:set('idle')
		end
	end)

	Roda.bus:register('input/pressing', function (key)
		if key == 'left' then
			e.animator:set('run')
			if (e.transform.scale.x > 0) then
				e.transform.scale.x = -1 * e.transform.scale.x
			end
			Roda.bus:emit('physics/translate', e, Vector(-120, 0))
		end

		if key == 'right' then
			e.animator:set('run')
			if (e.transform.scale.x < 0) then
				e.transform.scale.x = -1 * e.transform.scale.x
			end
			Roda.bus:emit('physics/translate', e, Vector(120, 0))
		end

		if key == 'space' then
			Roda.bus:emit('physics/translate', e, Vector(0, -1) * 450)
		end
	end)
end

return player_system
