local input = {}
input.__index = input

function input:new()
	local o = {}

	o.scheme = {}

	return setmetatable(o, input)
end

function input:init()
	self.scheme = {
		keyboard = {
			jump = 'space',
			up = 'up',
			down = 'down',
			left = 'left',
			right = 'right'
		},
		joystick = {}
	}
end

function input:update(dt)
	-- Key pressed
	function love.keypressed(key)
		for i, other in pairs(self.scheme.keyboard) do
			if key == other then
				Roda.bus:emit('input/pressed', i)
			end
		end
		Roda.bus:emit('input/pressed/key', key)
	end

	-- Key pressing
	for i, key in pairs(self.scheme.keyboard) do
		if love.keyboard.isDown(key) then
			Roda.bus:emit('input/pressing', i)
		end
	end
end

function input:keyboard()
end

return setmetatable(input, {
	__call = input.new
})
