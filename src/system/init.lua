local Class = require 'middleclass'
local Tiny = require 'tiny'

local system = Class('Sytem')

function system:initialize(bus)
	Tiny.system(self)

	self.bus = bus
	self:bind()
end

function system:onAdd(e) self:on_add(e) end

-- Virtual Methods
function system:bind() end
function system:unbind() end
function system:on_add(e) end

return system
