require "env"

local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Camera = require (LIB_PATH .. "hump.camera")
local Signal = require (LIB_PATH .. "hump.signal")
local Tiny = require (LIB_PATH .. "tiny.tiny")

local Engine = Class{
	bus = Signal(),
	world = Tiny.world(),
	systems = {}
}

function Engine:init()
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

	love.graphics.clear(100, 100, 100, 255)
	self.bus:emit("render/draw", dt)
	self.bus:emit("editor/draw", dt)
end

return Engine
