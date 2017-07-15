local Tiny = require 'tiny'

local camera_follow = {}
camera_follow.__index = camera_follow

function camera_follow:new()
	local o = setmetatable({
		filter = Tiny.requireAll('transform', 'viewport', 'target'),
		isUpdateSystem = true
	}, camera_follow)

	return Tiny.processingSystem(o)
end

function camera_follow:process(e, dt)
	if e.target.transform then
		local horizontal = math.floor((e.target.transform.position.x - e.transform.position.x) * 3 * love.timer.getDelta())
		local vertical = math.floor((e.target.transform.position.y - e.transform.position.y + 50.0) * 3 * dt)
		local position

		if e.follow == 'both' then
			position = Vector(horizontal, vertical)
		elseif e.follow == 'horizontal' then
			position = Vector(horizontal, 0)
		elseif e.follow == 'vertical' then
			position = Vector(0, vertical)
		end

		e.transform.position = e.transform.position + position
	end
end

return setmetatable(camera_follow, {
	__call = camera_follow.new
})
