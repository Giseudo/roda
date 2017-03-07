local Process = {}

function Process:new(o)
	o = o or {
		state = "UNINITIALIZED"
	}
	setmetatable(o, self)
	self.__index = self

	return o
end

-- Virtual methods
function Process:onInit()
	self.state = "RUNNING"
end

function Process:onUpdate(dt)
end

function Process:onSuccess()
end

function Process:onFail()
end

function Process:onAbort()
end

-- Ending process methods
function Process:succeed()
	self.state = "SUCCEEDED"
end

function Process:fail()
	self.state = "FAILED"
end

function Process:pause()
	self.state = "PAUSED"
end

function Process:resume()
	self.state = "RUNNING"
end

-- Accessors
function Process:getState()
	return self.state
end

function Process:isAlive()
	return self.state == "RUNNING" or self.state == "PAUSED"
end

function Process:isDead()
	return self.state == "SUCCEEDED" or self.state == "FAILED" or self.state == "ABORTED"
end

function Process:isRemoved()
	return self.state == "REMOVED"
end

function Process:isPaused()
	return self.state == "PAUSED"
end

-- Child methods
function Process:attach(child)
	self.child = child
end

function Process:dettach()
end

return Process
