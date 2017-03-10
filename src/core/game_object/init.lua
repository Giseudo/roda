local game_object = {}

local function constructor(o, bus, name, layer, parent)
	o = o or {}
	o.active = true
	o.bus = bus
	o.name = name
	o.parent = parent or nil
	o.layer = layer or 1
	o.children = {}
	o.listening = {}
	o.components = {}

	return o
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

return setmetatable(
	game_object,
	{ __call = constructor }
)
