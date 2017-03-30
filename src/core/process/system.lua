local Class = require 'middleclass'
local process_system = Class('ProcessManager')

function process_system:initialize()
	self.processes = {}
	self:bind()
end

function process_system:bind()
	roda.bus:register('process/attach', function (process)
		self:attach(process)
	end)

	roda.bus:register('update', function (dt)
		self:update(dt)
	end)
end

function process_system:unbind()
end

function process_system:attach(process)
	table.insert(self.processes, process)
end

function process_system:remove(index)
	table.remove(self.processes, index)
end

function process_system:update(dt)
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

return process_system
