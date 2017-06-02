local animator = {}
animator.__index = animator

function animator:new(name, start, length)
	local o = {}

	o.name = name
	o.start = start
	o.length = length
	o.timer = 0
	o.speed = 0.1

	return setmetatable(o, animator)
end

return setmetatable(animator, {
	__call = animator.new
})
