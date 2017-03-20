local Class = require 'middleclass'
local game_object = Class('GameObject')

function game_object:initialize(bus, name, layer, parent)
	self.bus = bus or nil
	self.name = name or ''
	self.active = true
	self.parent = parent or nil
	self.children = {}
	self.components = {}
	self.layer = layer or 1
end

function game_object:add_component(name, component)
	self[name] = component
	self.components[name] = component
end

function game_object:get_component(name)
	return self.components[name]
end

function game_object:remove_component(name)
	table.remove(self.components, name)
	table.remove(self, name)
end

function game_object:has_component(name)
	return self.components[name] ~= nil
end

function game_object:bind(event, callback)
	self.bus:register(event, callback)
end

function game_object:unbind(event, callback)
	self.bus:unregister(event, callback)
end

return game_object
