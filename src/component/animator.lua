local animator = {}
animator.__index = animator

function animator:new(name, start, length)
	local o = {}

	o.timer = 0
	o.speed = 0.1
	o.frame = 0
	o.animations = {}
	o.current = nil

	animator.add_animation(o, name, start, length)
	animator.set_animation(o, name)

	return setmetatable(o, animator)
end

function animator:add_animation(name, start, length)
	self.animations[name] = {
		name = name,
		start = start,
		length = length
	}
end

function animator:set_animation(name)
	if self.current ~= nil then
		if self.current.name == name then
			return
		end
	end

	self.current = self.animations[name]
	self.frame = self.current.start
end

return setmetatable(animator, {
	__call = animator.new
})
