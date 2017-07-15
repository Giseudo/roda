require 'imgui'

local editor_entities = {}
editor_entities.__index = editor_entities

function editor_entities:new()
	local o = {
		show_window = false
	}

	return setmetatable(o, editor_entities)
end

function editor_entities:init()
end

function editor_entities:update()
end

function editor_entities:draw()
	if self.show_window then
		imgui.SetNextWindowPos(200, 50, "Entities")
		imgui.Begin("Entities", true, { 'AlwaysAutoResize' });

		imgui.Button('Place Entity')

		imgui.End();
	end
end

function editor_entities:map()
end

function editor_entities:destroy()
	imgui.ShutDown()
end

return setmetatable(editor_entities, {
	__call = editor_entities.new
})
