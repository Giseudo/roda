require (GAME_LIB .. 'roda.env')

local Signal = require (RODA_LIB .. 'hump.signal')
local Scene = require (RODA_SRC .. 'core.scene')
local Editor = require (RODA_SRC .. 'core.editor')
local ProcessManager = require (RODA_SRC .. 'core.process.manager')

local roda = {}

function roda:initialize()
	self.bus = Signal()
	self.scene = Scene(self.bus)
	self.process_manager = ProcessManager(self.bus)

	if GAME_EDITOR then
		self.editor = Editor(self.bus)
	end

	return self
end

function roda:update(dt)
	self.bus:emit('update', dt)
end

function roda:draw()
	local dt = love.timer.getDelta()

	love.graphics.clear(50, 50, 60, 255)
	self.bus:emit('draw', dt)

	if GAME_EDITOR then
		self.bus:emit('editor/draw', dt)
	end
end

return setmetatable(roda, { __call = roda.initialize })
