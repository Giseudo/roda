local Class = require 'middleclass'
local Roda = require (RODA_PATH)

local actor = Class('Actor')

function actor:initialize(name, layer, parent)
	self.name = name or ''
	self.active = true
	self.parent = parent or nil
	self.children = {}
	self.components = {}
	self.layer = layer or 1
end

function actor:add_component(name, component)
	self[name] = component
	self.components[name] = component
end

function actor:get_component(name)
	return self.components[name]
end

function actor:remove_component(name)
	table.remove(self.components, name)
	table.remove(self, name)
end

function actor:has_component(name)
	return self.components[name] ~= nil
end

function actor:bind(event, callback)
	Roda.bus:register(event, callback)
end

function actor:unbind(event, callback)
	Roda.bus:unregister(event, callback)
end

return actor
