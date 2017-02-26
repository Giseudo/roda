local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Camera = require (LIB_PATH .. "hump.camera")
local Signal = require (LIB_PATH .. "hump.signal")
local Tiny = require (LIB_PATH .. "tiny.tiny")

local Engine = Class{
	systems = {}
}

function Engine:init()
	self.camera = Camera(0, 0, 2)
	self.bus = Signal()
	self.world = Tiny.world()

	self.bus:register("system/add", function(name, system)
		self.systems[name] = system
		self.world:add(system)
		self.world:refresh()
	end)

	self.bus:register("entity/add", function(entity)
		self.world:add(entity)
		self.world:refresh()
	end)
end

function Engine:update(dt)
	self.bus:emit("update", dt)
end

function Engine:draw()
	local dt = love.timer.getDelta()

	self.camera:draw(function ()
		self.bus:emit("draw", dt)
	end)
end

return Engine
