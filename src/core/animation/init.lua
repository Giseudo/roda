local animation = {}

function animation:new(begin, finish, framerate)
	self.begin = begin
	self.finish = finish
	self.framerate = framerate

	return self
end

return setmetatable(animation,
	{ __call = animation.new }
)
