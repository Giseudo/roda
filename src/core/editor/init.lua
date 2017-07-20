require 'imgui'

local EditorMap = require (RODA_SRC .. 'core.editor.map')
local EditorEntities = require (RODA_SRC .. 'core.editor.entities')

local editor = {}
editor.__index = editor

function editor:new()
	local o = {
		map = EditorMap(),
		entities = EditorEntities(),
		active = true
	}

	return setmetatable(o, editor)
end

function editor:init()
	self.map:init()
	self.entities:init()

	Roda.bus:register('input/keyboard/pressed', function(key)
		if self.active == true then
			if love.keyboard.isDown('lctrl') then
				-- Shortcuts
				if key == 'd' then
					if Roda.debug == true then
						Roda.debug = false
					else
						Roda.debug = true
					end
				end

				-- Camera inputs
				if key == 'z' then
					Roda.bus:emit('camera/zoom', 1)
				end
				if key == 'x' then
					Roda.bus:emit('camera/zoom', -1)
				end

				if key == 'm' then
					self.map.show_window = not self.map.show_window
				end
				if key == 'e' then
					self.entities.show_window = not self.entities.show_window
				end
				if key == 's' then
					Roda.bus:emit('scene/save', 'entities')
				end
			end
		end
	end)

	Roda.bus:register('input/textinput', function(t)
		imgui.TextInput(t)
		if not imgui.GetWantCaptureKeyboard() then
			-- Pass event to the game
		end
	end)

	Roda.bus:register('input/keyboard/pressed', function(key)
		imgui.KeyPressed(key)
		if not imgui.GetWantCaptureKeyboard() then
			-- Pass event to the game
		end
	end)

	Roda.bus:register('input/keyboard/released', function(key)
		imgui.KeyReleased(key)
		if not imgui.GetWantCaptureKeyboard() then
			-- Pass event to the game
		end
	end)

	Roda.bus:register('input/mouse/moved', function(x, y)
		imgui.MouseMoved(love.mouse.getX(), love.mouse.getY())
		if not imgui.GetWantCaptureMouse() then
			-- Pass event to the game
		end
	end)

	Roda.bus:register('input/mouse/pressed', function(event)
		imgui.MousePressed(event.button)
		if not imgui.GetWantCaptureMouse() then
			-- Pass event to the game
		end
	end)

	Roda.bus:register('input/mouse/released', function(event)
		imgui.MouseReleased(event.button)
		if not imgui.GetWantCaptureMouse() then
			-- Pass event to the game
		end
	end)

	Roda.bus:register('input/mouse/wheel', function(x, y)
		imgui.WheelMoved(y)
		if not imgui.GetWantCaptureMouse() then
			-- Pass event to the game
		end
	end)
end

function editor:update()
	imgui.NewFrame()
end

function editor:draw()
	-- Menu
	if imgui.BeginMainMenuBar() then
		if imgui.BeginMenu('File') then
			imgui.MenuItem('New', 'CTRL+N')
			imgui.MenuItem('Save', 'CTRL+S')
			imgui.MenuItem('Quit')
			imgui.EndMenu()
		end
		if imgui.BeginMenu('World') then
			if imgui.MenuItem('Map', 'CTRL+M', self.map.show_window) then
				self.map.show_window = not self.map.show_window
			end
			if imgui.MenuItem('Entities', 'CTRL+E', self.entities.show_window) then
				self.entities.show_window = not self.entities.show_window
			end

			imgui.EndMenu()
		end
		imgui.EndMainMenuBar()
	end

	self.map:draw()
	self.entities:draw()

	love.graphics.setShader()
	imgui.Render();
end

function editor:destroy()
	imgui.ShutDown()
end

return setmetatable(editor, {
	__call = editor.new
})
