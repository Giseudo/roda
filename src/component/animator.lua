local Class = require 'middleclass'
local Animation = require (RODA_SRC .. 'core.animation')

local animator_component = Class('AnimatorComponent')

function animator_component:initialize(name, animation)
	self.timer = 0
	self.current = nil
	self.animations = {}
	self:add(name, animation)
	self:set(name)
end

function animator_component:add(name, animation)
	self.animations[name] = animation
end

function animator_component:set(name)
	-- Skip current animation
	if (self.current ~= self.animations[name]) then
		self.frame = self.animations[name].begin
	end

	self.current = self.animations[name]
end

function animator_component:next()
	if self.frame >= self.current.finish then
		self.frame = self.current.begin
	else
		self.frame = self.frame + 1
	end

	return self.frame
end

return animator_component
