local Class = require 'middleclass'
local Tiny = require 'tiny'
local Vector = require (RODA_LIB .. 'hump.vector')
local System = require (RODA_SRC .. 'system')

local parenting_system = Class('ParentingSystem', System)

function parenting_system:initialize(bus)
	System.initialize(self, bus)

	self.filter = Tiny.requireAll('transform', 'parent')
end

function parenting_system:bind()
	self.bus:register('scene/add/child', function(parent, child)
		self:addChild(parent, child)
	end)
end

function parenting_system:onAdd(e)
	self.bus:register('update', function(dt)
		self:update(e, dt)
	end)
end

function parenting_system:update(e, dt)
	local origin = e.parent.transform.position
	local offset = origin - e.transform.position

	e.transform.position = offset + e.transform.position
end

function parenting_system:addChild(parent, child)
	local name = child.name

	if parent.children[name] then
		name = name .. '_A' -- FIXME: We need to generate automatic prefixes
	end

	child.parent = parent
	parent.children[name] = child
	self.bus:emit('scene/add', child)
end

return parenting_system
