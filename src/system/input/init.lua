local Class = require 'middleclass'
local Tiny = require 'tiny'
local System = require (RODA_SRC .. 'system')

local input_system = Class('InputSystem', System)

function input_system:initialize()
	System.initialize(self)

	self.filter = Tiny.requireAll('controller')
	self.pressing = {}
end

function input_system:bind(e)
	roda.bus:register('update', function (dt)
		self:update(dt)
	end)

	roda.bus:register('key/pressed', function (key)
		self.pressing[key] = true
		roda.bus:emit('input/pressed', key)
	end)

	roda.bus:register('key/released', function (key)
		self.pressing[key] = false
		roda.bus:emit('input/released', key)
	end)
end

function input_system:update(dt)
	function love.keypressed(key)
		roda.bus:emit('key/pressed', key)
	end

	function love.keyreleased(key)
		roda.bus:emit('key/released', key)
	end

	for key, value in pairs(self.pressing) do
		if value then
			roda.bus:emit('input/pressing', key)
		end
	end
end


return input_system
