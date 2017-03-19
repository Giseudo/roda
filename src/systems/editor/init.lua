require "imgui"
local Tiny = require "tiny"
local Bump = require (LIB_PATH .. "bump.bump")
local EditorSystem = Tiny.system()

local debug = {
	render = false,
	physics = false
}

-- FIXME: We need to modularize editor system into many chunks
function EditorSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "camera")

	self.bus:register('editor/draw', function (dt)
		self:draw(dt)
	end)

	self.bus:register('update', function (dt)
		self:update(dt)
	end)

	return self
end

function EditorSystem:onAdd(e)

end

function EditorSystem:update(dt)
	imgui.NewFrame()

	function love.textinput(t)
		imgui.TextInput(t)
	end

	function love.keypressed(key)
		imgui.KeyPressed(key)

		if love.keyboard.isDown("lctrl") and
			love.keyboard.isDown("lshift") then
			if key == "r" then
				debug.render = not debug.render
				self.bus:emit("render/debug", debug.render)
			end
			if key == "p" then
				debug.physics = not debug.physics
				self.bus:emit("physics/debug", debug.physics)
			end
		end

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
			if imgui.MenuItem("Render", "SHIFT+CTRL+R", debug.render) then
				debug.render = not debug.render
				self.bus:emit("render/debug", debug.render)
			end
			if imgui.MenuItem("Physics", "SHIFT+CTRL+P", debug.physics) then
				debug.physics = not debug.physics
				self.bus:emit("physics/debug", debug.physics)
			end
			imgui.EndMenu()
		end
		imgui.EndMainMenuBar()
	end

	imgui.Render();
end



return EditorSystem
