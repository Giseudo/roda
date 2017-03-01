require "imgui"
local Tiny = require (LIB_PATH .. "tiny.tiny")
local Bump = require (LIB_PATH .. "bump.bump")
local EditorSystem = Tiny.system()

local showTestWindow = false
local showAnotherWindow = false
local floatValue = 0;
local sliderFloat = { 0.1, 0.5 }
local clearColor = { 0.2, 0.2, 0.2 }
local comboSelection = 1
local textValue = "text"

function EditorSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "camera")

	return self
end

function EditorSystem:onAdd(e)
	self.bus:register('update', function (dt)
		imgui.NewFrame()
	end)

	self.bus:register('draw', function (dt)
		self:draw(dt)
	end)
end

function EditorSystem:draw(dt)
	local status

	-- Menu
	if imgui.BeginMainMenuBar() then
		if imgui.BeginMenu("File") then
			imgui.MenuItem("Test")
			imgui.EndMenu()
		end
		imgui.EndMainMenuBar()
	end

	-- Debug Window
	imgui.Text("Hello, world!");
	status, clearColor[1], clearColor[2], clearColor[3] = imgui.ColorEdit3("Clear color", clearColor[1], clearColor[2], clearColor[3]);

	-- Sliders
	status, floatValue = imgui.SliderFloat("SliderFloat", floatValue, 0.0, 1.0);
	status, sliderFloat[1], sliderFloat[2] = imgui.SliderFloat2("SliderFloat2", sliderFloat[1], sliderFloat[2], 0.0, 1.0);

	-- Combo
	status, comboSelection = imgui.Combo("Combo", comboSelection, { "combo1", "combo2", "combo3", "combo4" }, 4);

	-- Windows
	if imgui.Button("Test Window") then
		showTestWindow = not showTestWindow;
	end

	if imgui.Button("Another Window") then
		showAnotherWindow = not showAnotherWindow;
	end

	if showAnotherWindow then
		imgui.SetNextWindowPos(50, 50, "FirstUseEver")
		status, showAnotherWindow = imgui.Begin("Another Window", true, { "AlwaysAutoResize", "NoTitleBar" });
		imgui.Text("Hello");
		-- Input Text
		status, textValue = imgui.InputTextMultiline("InputText", textValue, 200, 300, 200);
		imgui.End();
	end

	if showTestWindow then
		showTestWindow = imgui.ShowTestWindow(true)
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
