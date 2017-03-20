local Class = require 'middleclass'

local animation = Class('Animation')

function animation:initialize(begin, finish, framerate)
	self.begin = begin
	self.finish = finish
	self.framerate = framerate or 0.1
end

return animation
