local ProcessSystem = {}

function ProcessSystem:new(bus)
	self.bus = bus
	self.processes = {}

	self.bus:register("process/attach", function (process)
		self:attach(process)
	end)

	self.bus:register("update", function (dt)
		self:update(dt)
	end)

	return self
end

function ProcessSystem:attach(process)
	table.insert(self.processes, process)
end

function ProcessSystem:remove(index)
	table.remove(self.processes, index)
end

function ProcessSystem:update(dt)
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

return ProcessSystem
