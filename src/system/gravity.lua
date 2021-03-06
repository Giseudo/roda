local Tiny = require 'tiny'

local gravity = {}
gravity.__index = gravity

function gravity:new()
	local o = setmetatable({
		filter = Tiny.requireAll('body'),
		isUpdateSystem = true
	}, gravity)

	return Tiny.processingSystem(o)
end

function gravity:process(e, dt)
	if math.abs(e.transform.position.x - Game.sparkle.transform.position.x) > 300 then
		return
	end

	if e.body.kinematic then
		e.body.acceleration.x = 0
		e.body.acceleration.y = 0
		return
	end

	-- Apply gravity force
	e.body.acceleration.x = Roda.physics.gravity.x
	e.body.acceleration.y = Roda.physics.gravity.y

	-- Max gravity velocity
	if e.body.velocity.y <= -10.0 then
		e.body.velocity.y = -10.0
	end
end

return setmetatable(gravity, {
	__call = gravity.new
})
