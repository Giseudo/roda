require "imgui"
local Tiny = require (LIB_PATH .. "tiny.tiny")
local Bump = require (LIB_PATH .. "bump.bump")
local EditorSystem = Tiny.system()

function EditorSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "camera")
	self.debug = {
		render = false,
		physics = false
	}

	self.bus:register('editor/draw', function (dt)
		self:draw(dt)
	end)

	self.bus:register('update', function (dt)
		imgui.NewFrame()
	end)

	return self
end

function EditorSystem:onAdd(e)


end

function EditorSystem:draw(dt)
	local status

	-- Menu
	if imgui.BeginMainMenuBar() then
		if imgui.BeginMenu("File") then
			imgui.MenuItem("Test")
			imgui.EndMenu()
		end

		if imgui.BeginMenu("Debug") then
			if imgui.MenuItem("Render") then
				self.debug.render = not self.debug.render
				self.bus:emit("render/debug", self.debug.render)
			end
			if imgui.MenuItem("Physics") then
				self.debug.physics = not self.debug.physics
				self.bus:emit("physics/debug", self.debug.physics)
			end
			imgui.EndMenu()
		end
		imgui.EndMainMenuBar()
	end

	imgui.Render();
end


function love.textinput(t)
	imgui.TextInput(t)
end

function love.keypressed(key)
	imgui.KeyPressed(key)
end

function love.keyreleased(key)
	imgui.KeyReleased(key)
end

function love.mousemoved(x, y)
	imgui.MouseMoved(x, y)
end

function love.mousepressed(x, y, button)
	imgui.MousePressed(button)
end

function love.mousereleased(x, y, button)
	imgui.MouseReleased(button)
end

function love.wheelmoved(x, y)
	imgui.WheelMoved(y)
end

return EditorSystem
