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
			fire = 'space',
			turn = 'lshift',
			up = 'up',
			down = 'down',
			left = 'left',
			right = 'right'
		},
		osx = {
			jump = 0,
			fire = 16,
			turn = 15,
			up = 0,
			down = 0,
			left = 8,
			right = 6
		},
		joystick = {
			jump = 0,
			fire = 12,
			turn = 0,
			up = 0,
			down = 0,
			left = 8,
			right = 6
		}
	}
end

function input:update(dt)
	-- Key pressed
	function love.keypressed(key)
		if Roda.state == 'game' then
			for i, other in pairs(self.scheme.keyboard) do
				if key == other then
					Roda.bus:emit('input/pressed', i)
				end
			end
		end
		Roda.bus:emit('input/keyboard/pressed', key)
	end

	-- Key released
	function love.keyreleased(key)
		if Roda.state == 'game' then
			for i, other in pairs(self.scheme.keyboard) do
				if key == other then
					Roda.bus:emit('input/released', i)
				end
			end
		end
		Roda.bus:emit('input/keyboard/released', key)
	end

	if Roda.state == 'game' then
		-- Key pressing
		for i, key in pairs(self.scheme.keyboard) do
			if love.keyboard.isDown(key) then
				Roda.bus:emit('input/pressing', i)
			end
		end
	end

	-- Joystick pressed
	function love.joystickpressed(joystick, button)
		if Roda.state == 'game' then
			for i, other in pairs(self.scheme.joystick) do
				if button == other then
					Roda.bus:emit('input/pressed', i)
				end
			end
		end
		Roda.bus:emit('input/joystick/pressed', button)
	end

	-- Joystick released
	function love.joystickreleased(joystick, button)
		for i, other in pairs(self.scheme.joystick) do
			if button == other then
				Roda.bus:emit('input/released', i)
			end
		end
		Roda.bus:emit('input/joystick/released', button)
	end

	local joysticks = love.joystick.getJoysticks()
	for k, joystick in ipairs(joysticks) do
		-- Joystick pressing
		for i, button in pairs(self.scheme.joystick) do
			if joystick:isDown(button) then
				Roda.bus:emit('input/pressing', i)
			end
		end

		-- Joystick axis
		local horizontal, vertical = joystick:getAxes()

		if horizontal == - 1 then
			Roda.bus:emit('input/pressing', 'left')
		elseif horizontal == 1 then
			Roda.bus:emit('input/pressing', 'right')
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
			button = 1
		})
	end
	if love.mouse.isDown(2) then
		Roda.bus:emit('input/mouse/pressing', {
			position = Roda.scene.camera:get_coords(love.mouse.getX(), love.mouse.getY()),
			button = 2
		})
	end

end

return setmetatable(input, {
	__call = input.new
})
