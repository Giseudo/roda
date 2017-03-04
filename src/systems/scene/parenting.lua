local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local ParentingSystem = Tiny.system()

function ParentingSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "parent")

	self.bus:register("scene/add/child", function(parent, child)
		self:addChild(parent, child)
	end)

	return self
end

function ParentingSystem:onAdd(e)
	self.bus:register("update", function(dt)
		self:update(e, dt)
	end)
end

function ParentingSystem:update(e, dt)
	local origin = e.parent.transform.position
	local offset = origin - e.transform.position

	e.transform.position = offset + e.transform.position
end

function ParentingSystem:addChild(parent, child)
	local name = child.name

	if parent.children[name] then
		name = name .. "_A" -- FIXME: We need to generate automatic prefixes
	end

	child.parent = parent
	parent.children[name] = child
	self.bus:emit("scene/add", child)
end

return ParentingSystem
