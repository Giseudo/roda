-- TODO: Refactor this and test
local Class = require 'middleclass'
local System = require (RODA_SRC .. 'system')
local Tiny = require 'tiny'

local processing_system = Class('ProcessManager', System)

function processing_system:initialize()
	System.initialize(self)
	self.processes = {}

	self.filter = Tiny.requireAll('process'`)
end

function processing_system:bind()
	roda.bus:register('process/attach', function (process)
		self:attach(process)
	end)

	roda.bus:register('update', function (dt)
		self:update(dt)
	end)
end

function processing_system:unbind()
end

function processing_system:on_add(e)
end

function processing_system:attach(process)
	table.insert(self.processes, process)
end

function processing_system:remove(index)
	table.remove(self.processes, index)
end

function processing_system:update(dt)
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

return processing_system
