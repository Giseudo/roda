require 'imgui'

local editor_map = {}
editor_map.__index = editor_map

function editor_map:new()
	local o = {
		show_window = false,
		placing_tiles = false,
		placing_blocks = true,
		current_tile = nil,
		start_drag = nil,
		end_drag = nil
	}

	return setmetatable(o, editor_map)
end

function editor_map:init()
	Roda.bus:register('input/mouse/pressing', function(event)
		if self.placing_tiles then
			Roda.bus:emit('tile/add', 'terrain_02', 'terrain_02.png', event.position)
		end

		if self.placing_blocks then
			local x, y = Roda.scene.ground:get_tile_index(event.position)

			if x ~= 0 and y ~= 0 then
				if self.start_drag == nil then
					self.start_drag = Vector(x, y)
				end
			end
		end
	end)

	Roda.bus:register('input/mouse/released', function(event)
		if self.placing_blocks then
			if self.start_drag ~= nil then
				local x, y = Roda.scene.ground:get_tile_index(event.position)
				self.end_drag = Vector(x, y)

				Roda.bus:emit(
					'tile/add/block',
					'terrain_01',
					'terrain_01.png',
					self.start_drag.x,
					self.start_drag.y,
					self.end_drag.x,
					self.end_drag.y
				)

				self.start_drag = nil
				self.end_drag = nil
			end
		end
	end)

	Roda.bus:register('input/keyboard/pressed', function(key)
		if key == 'escape' then
			self.placing_tiles = false
			self.placing_blocks = false
		end
	end)
end

function editor_map:update()
end

function editor_map:draw()
	if self.show_window then
		imgui.SetNextWindowPos(50, 50, "Map")
		status, showAnotherWindow = imgui.Begin("Map", true, { 'AlwaysAutoResize' });

		imgui.ListBox('Tiles', 0, {'Grass', 'Dirt'}, 2, 5)

		if imgui.Button('Draw Tiles') then
			self.placing_tiles = true
			self.placing_blocks = false
		end

		if imgui.Button('Draw Blocks') then
			self.placing_blocks = true
			self.placing_tiles = false
		end

		imgui.End();
	end
end

function editor_map:map()
end

function editor_map:destroy()
	imgui.ShutDown()
end

return setmetatable(editor_map, {
	__call = editor_map.new
})
