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
		Roda.bus:emit('input/keyboard/pressed', key)
	end

	-- Key pressing
	for i, key in pairs(self.scheme.keyboard) do
		if love.keyboard.isDown(key) then
			Roda.bus:emit('input/pressing', i)
		end
	end

	-- Mouse pressed
	function love.mousepressed(x, y, button)
		Roda.bus:emit('input/mouse/pressed', {
			position = Roda.camera:mousePosition(x, y),
			button = button
		})
	end

	-- Mouse released
	function love.mousereleased(x, y, button)
		Roda.bus:emit('input/mouse/released', {
			position = Roda.camera:mousePosition(x, y),
			button = button
		})
	end

	-- Mouse moved
	function love.mousemoved(x, y, dx, dy)
		Roda.bus:emit('input/mouse/moved', {
			position = Roda.camera:mousePosition(x, y),
			delta = Roda.camera:mousePosition(dx, dy),
		})
	end
end

function input:keyboard()
end

return setmetatable(input, {
	__call = input.new
})
