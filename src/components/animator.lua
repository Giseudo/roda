local Class = require (LIB_PATH .. "hump.class")
local Animator = Class{
	frame = 0,
	timer = 0,
	current = nil,
	animations = {}
}

function Animator:init(name, start, finish, speed)
	self:add(name, start, finish, speed)
	self:set(name)
end

function Animator:add(name, start, finish, speed)
	self.animations[name] = { start, finish, speed }
end

function Animator:set(name)
	self.current = self.animations[name]
end

function Animator:next()
	if self.frame >= self.current[2] then
		self.frame = self.current[1]
	else
		self.frame = self.frame + 1
	end

	return self.frame
end

return Animator