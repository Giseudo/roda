local logger = {}
logger.__index = logger

function logger:new()
	return setmetatable({
		history = {
			info = {},
			warning = {},
			error = {}
		}
	}, logger)
end

function logger:info(message, owner)
	self.history.info[#self.history.info] = {
		time = os.date("%c"),
		message = message,
		owner = owner
	}

	print(os.date("%c"), 'INFO', owner, message)
end

function logger:warning(message, owner)
	self.history.warning[#self.history.warning] = {
		time = os.date("%c"),
		message = message,
		owner = owner
	}

	print(os.date("%c"), 'WARNING', owner, message)
end

function logger:error(message, owner)
	self.history.error[#self.history.error] = {
		time = os.date("%c"),
		message = message,
		owner = owner
	}

	print(os.date("%c"), 'ERROR', owner, message)
end

return setmetatable(logger, { __call = function(_, ...) return logger.new(...) end })
