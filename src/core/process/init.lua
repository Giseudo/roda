local Class = require 'middleclass'

local process = Class('Process')

function process:initialize() self.state = 'UNINITIALIZED' end

-- Virtual methods
function process:on_init() self.state = 'RUNNING' end
function process:on_update(dt) end
function process:on_success() end
function process:on_fail() end
function process:on_abort() end

-- Ending process methods
function process:succeed() self.state = 'SUCCEEDED' end
function process:fail() self.state = 'FAILED' end
function process:pause() self.state = 'PAUSED' end
function process:resume() self.state = 'RUNNING' end

-- Accessors
function process:get_state()
	return self.state
end

function process:is_alive()
	return self.state == 'RUNNING' or self.state == 'PAUSED'
end

function process:is_dead()
	return self.state == 'SUCCEEDED' or self.state == 'FAILED' or self.state == 'ABORTED'
end

function process:is_removed()
	return self.state == 'REMOVED'
end

function process:is_paused()
	return self.state == 'PAUSED'
end

-- Child methods
function process:attach(child)
	self.child = child
end

function process:dettach()
	local child = self.child
	self.child = nil

	return child
end

return process
