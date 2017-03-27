local Class = require 'middleclass'
local process_controller = Class('ProcessManager')

function process_controller:initialize(bus)
	self.processes = {}
	self.bus = bus
	self:bind()
end

function process_controller:bind()
	self.bus:register('process/attach', function (process)
		self:attach(process)
	end)

	self.bus:register('update', function (dt)
		self:update(dt)
	end)
end

function process_controller:unbind()
end

function process_controller:attach(process)
	table.insert(self.processes, process)
end

function process_controller:remove(index)
	table.remove(self.processes, index)
end

function process_controller:update(dt)
	for i, process in ipairs(self.processes) do
		if process.state == 'UNINITIALIZED' then
			process:on_init()
		end

		if process.state == 'RUNNING' then
			process:on_update(dt)
		end

		if process:is_dead() then
			if process.state == 'SUCCEEDED' then
				process:on_success()

				if process.child then
					self:attach(process:dettach())
				end

			elseif process.state == 'FAILED' then
				process:on_fail()
			elseif process.state == 'ABORTED' then
				process:on_abort()
			end

			self:remove(i)
		end
	end
end

return process_controller
