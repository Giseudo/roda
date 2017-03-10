local process_manager = {}

local function constructor(o, bus)
	o = o or {}
	o.processes = {}
	o.bus = bus
	o:bind()

	return o
end

function process_manager:bind()
	self.bus:register("process/attach", function (process)
		self:attach(process)
	end)

	self.bus:register("update", function (dt)
		self:update(dt)
	end)
end

function process_manager:unbind()
end

function process_manager:attach(process)
	table.insert(self.processes, process)
end

function process_manager:remove(index)
	table.remove(self.processes, index)
end

function process_manager:update(dt)
	for i, process in ipairs(self.processes) do
		if process.state == "UNINITIALIZED" then
			process:onInit()
		end

		if process.state == "RUNNING" then
			process:onUpdate(dt)
		end

		if process:isDead() then
			if process.state == "SUCCEEDED" then
				process:onSuccess()

				if process.child then
					self:attach(process.child)
				else
					--
				end

			elseif process.state == "FAILED" then
				process:onFail()
			elseif process.state == "ABORTED" then
				process:onAbort()
			end

			self:remove(i)
		end
	end
end

return setmetatable(
	process_manager,
	{
		__call = constructor
	}
)
