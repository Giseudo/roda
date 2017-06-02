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
	-- Apply gravity force
	e.body.acceleration.y = Roda.gravity

	-- Max gravity velocity
	if e.body.velocity.y <= -10.0 then
		e.body.velocity.y = -10.0
	end
end

return setmetatable(gravity, {
	__call = gravity.new
})
