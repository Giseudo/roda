local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Camera = require (LIB_PATH .. "hump.camera")
local Signal = require (LIB_PATH .. "hump.signal")
local Tiny = require (LIB_PATH .. "tiny.tiny")
local EditorSystem = require (RODA_PATH .. "systems.editor")
local ProcessSystem = require (RODA_PATH .. "systems.process")

local Engine = Class{
	bus = Signal(),
	world = Tiny.world(),
	systems = {},
	scene = {}
}

function Engine:init()
	self.bus:register("system/add", function(name, system)
		self.systems[name] = system
		self.world:add(system)
		self.world:refresh()
	end)

	self.bus:register("scene/add", function(entity)
		self.world:add(entity)
		self.world:refresh()

		-- On add entity hook
		-- FIXME: Polish this
		if entity.onAdd then
			entity:onAdd()
		end
	end)

	self.bus:emit("system/add", "process", ProcessSystem:new(self.bus))

	if GAME_EDITOR then
		self.bus:emit("system/add", "editor", EditorSystem:new(self.bus))
	end
end

function Engine:update(dt)
	self.bus:emit("update", dt)
end

function Engine:draw()
	local dt = love.timer.getDelta()

	love.graphics.clear(100, 100, 100, 255)
	self.bus:emit("render/draw", dt)

	if GAME_EDITOR then
		self.bus:emit("editor/draw", dt)
	end
end

return Engine
