local Class = require (LIB_PATH .. "hump.class")
local MessageBus = require (RODA_PATH .. "message-bus")
local Input = require (RODA_PATH .. "input")
local Console = require (RODA_PATH .. "console")
local Render = require (RODA_PATH .. "render")
local Camera = require (RODA_PATH .. "camera")

local Engine = Class{
	bus = {},
	input = {},
	console = {},
	render = {},
	camera = {}
}

function Engine:init()
	self.bus = MessageBus()
	self.input = Input(self.bus)
	self.console = Console(self.bus)
	self.render = Render(self.bus)
	self.camera = Camera(self.bus)
end

function Engine:update(dt)
	self.bus:post("update", { dt = dt })
end

function Engine:draw()
	self.render:draw()
end

return Engine
