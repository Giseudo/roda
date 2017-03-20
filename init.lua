require (GAME_LIB .. 'roda.env') -- Should use RODA_PATH

local Tiny = require 'tiny'
local Signal = require (RODA_LIB .. 'hump.signal')
local Editor = require (RODA_SRC .. 'core.editor') -- Should use RODA_SRC
local ProcessManager = require (RODA_SRC .. 'core.process.manager')

local engine = {}

function engine:new()
	self.bus = Signal()
	self.world = Tiny.world()
	self.process_manager = ProcessManager(self.bus)
	self.systems = {}

	self.bus:register('system/add', function(name, system)
		self.systems[name] = system
		self.world:add(system)
		self.world:refresh()
	end)

	self.bus:register('scene/add', function(entity)
		self.world:add(entity)
		self.world:refresh()

		if entity.on_add then
			entity:on_add()
		end
	end)

	self.bus:register('world/refresh', function ()
		self.world:refresh()
	end)

	if GAME_EDITOR then
		self.editor = Editor(self.bus)
	end

	return self
end

function engine:add_system(name, system)
	self.systems[name] = system
	self.world:add(self.systems[name])
	self.world:refresh()
end

function engine:update(dt)
	self.bus:emit('update', dt)
end



function engine:draw()
	local dt = love.timer.getDelta()

	love.graphics.clear(100, 100, 100, 255)
	self.bus:emit('render/draw', dt)

	if GAME_EDITOR then
		self.bus:emit('editor/draw', dt)
	end
end

return setmetatable(engine, { __call = engine.new })
