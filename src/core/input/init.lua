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
			jump = '',
			up = 'space',
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

	-- Key released
	function love.keyreleased(key)
		for i, other in pairs(self.scheme.keyboard) do
			if key == other then
				Roda.bus:emit('input/released', i)
			end
		end
		Roda.bus:emit('input/keyboard/released', key)
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
			position = Roda.scene.camera:get_coords(x, y),
			button = button
		})
	end

	-- Mouse released
	function love.mousereleased(x, y, button)
		Roda.bus:emit('input/mouse/released', {
			position = Roda.scene.camera:get_coords(x, y),
			button = button
		})
	end

	-- Mouse moved
	function love.mousemoved(x, y, dx, dy)
		Roda.bus:emit('input/mouse/moved', {
			position = Roda.scene.camera:get_coords(x, y),
			delta = Roda.scene.camera:get_coords(dx, dy),
		})
	end

	if love.mouse.isDown(1) then
		Roda.bus:emit('input/mouse/pressing', {
			position = Roda.scene.camera:get_coords(love.mouse.getX(), love.mouse.getY()),
			button = 'left'
		})
	end
end

return setmetatable(input, {
	__call = input.new
})
