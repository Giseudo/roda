local controller = {}

function controller:new(speed, player)
	return setmetatable(
		{
			speed = speed or 0.5,
			backward = false,
			forward = false,
			upward = false,
			downward = false,
			jumping = false,
			flying = false,
			player = player or false
		},
		{ __index = controller }
	)
end

function controller:move_left()
	self.backward = true
end

function controller:move_right()
	self.forward = true
end

function controller:move_up()
	self.upward = true
end

function controller:move_down()
	self.downward = true
end

function controller:jump()
	self.jumping = true
end

function controller:fly()
	self.flying = true
end

function controller:dash()
	self.dashing = true
end

function controller:reset()
	self.upward = false
	self.backward = false
	self.forward = false
	self.downward = false
end

return setmetatable(controller, { __call = controller.new })
