local game_object = {
	active = true,
	parent = nil,
	children = {},
	components = {},
	layer = 1
}

function game_object:new(o, bus, name, layer, parent)
	o = o or {}
	o.bus = bus or nil
	o.name = name or ""

	self.__index = self
	setmetatable(o, self)

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

return setmetatable(game_object, { __call = game_object.new })
