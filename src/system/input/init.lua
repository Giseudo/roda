local Class = require 'middleclass'
local Tiny = require 'tiny'
local System = require (RODA_SRC .. 'system')

local input_system = Class('InputSystem', System)

function input_system:initialize(bus)
	System.initialize(self, bus)

	self.filter = Tiny.requireAll('controller')
	self.pressing = {}
end

function input_system:bind(e)
	self.bus:register('update', function (dt)
		self:update(dt)
	end)

	self.bus:register('key/pressed', function (key)
		self.pressing[key] = true
		self.bus:emit('input/pressed', key)
	end)

	self.bus:register('key/released', function (key)
		self.pressing[key] = false
		self.bus:emit('input/released', key)
	end)
end

function input_system:update(dt)
	function love.keypressed(key)
		self.bus:emit('key/pressed', key)
	end

	function love.keyreleased(key)
		self.bus:emit('key/released', key)
	end

	for key, value in pairs(self.pressing) do
		if value then
			self.bus:emit('input/pressing', key)
		end
	end
end


return input_system
