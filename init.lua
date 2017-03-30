require (GAME_LIB .. 'roda.env')
local Tiny = require 'tiny'
local Bump = require 'bump'
local Signal = require (RODA_LIB .. 'hump.signal')
local Editor = require (RODA_SRC .. 'core.editor')
local ProcessSystem = require (RODA_SRC .. 'core.process.system')

roda = {}

function roda:initialize()
	self.bus = Signal()
	self.space = Bump.newWorld(32)
	self.world = Tiny.world()
	self.process_system = ProcessSystem()
	self.pawn = nil
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	if GAME_EDITOR then
		self.editor = Editor(self.bus)
	end

	self.bus:register('world/add', function(e)
		self.world:add(e)
		self.world:refresh()
	end)

	self.bus:register('world/pawn', function(e)
		self.pawn = e
	end)

	self.bus:register('scene/space/add', function(e, x, y, w, h)
		self.space:add(e, x, y, w, h)
	end)

	return self
end

function roda:update(dt)
	self.bus:emit('update', dt)
end

function roda:draw()
	local dt = love.timer.getDelta()

	love.graphics.clear(50, 50, 60, 255)
	self.bus:emit('draw', dt)

	self.bus:emit('scene/draw')

	if self.pawn then
		self.pawn.camera:draw(function ()
			self.bus:emit('scene/camera/draw', dt)
			self.bus:emit('scene/debug/draw', dt)
		end)
	end

	if GAME_EDITOR then
		self.bus:emit('editor/draw', dt)
	end
end
