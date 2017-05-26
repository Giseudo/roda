local logger = {}

function logger:new()
	local o = {}

	o.history = {}

	return setmetatable(o, { __index = logger })
end

function logger:warn(message, owner)
	self.history[#self.history] = { 'WARNING', message, owner }

	print('WARNING', message)
end

return setmetatable(logger, { __call = logger.new })
