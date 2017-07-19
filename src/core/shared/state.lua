local state = {
	current = '',
	state = function(self)
		return self.states[self.current]
	end,
	switch = function(self, state)
		local previous = self.current

		self.current = state
		self.state = self.states[state]
		self.state:enter(previous)
	end,
	update = function(self, e, dt)
		self.states[self.current]:update(e, dt)
	end
}
state.__index = state

function state:new(o)
	return setmetatable(o, state)
end

return setmetatable(state, { __call = state.new })
