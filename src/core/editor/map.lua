require 'imgui'

local editor_map = {}
editor_map.__index = editor_map

function editor_map:new()
	local o = {
		show_window = false,
		placing_tiles = false,
		placing_blocks = false,
		current_tile = nil,
		start_drag = nil,
		end_drag = nil,
		layer = 1,
		tile = 'terrain_01'
	}

	return setmetatable(o, editor_map)
end

function editor_map:init()
	Roda.bus:register('input/mouse/pressing', function(event)
		local layer

		if self.layer == 0 then
			layer = 'background'
		elseif self.layer == 1 then
			layer = 'ground'
		elseif self.layer == 2 then
			layer = 'foreground'
		end

		if self.placing_tiles then
			if event.button == 1 then
				Roda.bus:emit(
					'tile/add',
					layer,
					self.tile,
					self.tile .. '.png',
					event.position
				)
			elseif event.button == 2 then
				Roda.bus:emit(
					'tile/remove',
					layer,
					event.position
				)
			end
		end

		if self.placing_blocks then
			if event.button == 1 then
				local x, y = Roda.scene[layer]:get_tile_index(event.position)
				if x ~= 0 and y ~= 0 then
					if self.start_drag == nil then
						self.start_drag = Vector(x, y)
					end
				end
			end
		end
	end)

	Roda.bus:register('input/mouse/pressed', function(event)
		if self.placing_blocks then
			if event.button == 2 then
				for _, other in pairs(Roda.physics.quadtree) do
					if other.tiles then
						local half = other.collider.shape:get_half()
						local dx = event.position.x - other.transform.position.x
						local px = half.x - math.abs(dx)
						local dy = event.position.y - other.transform.position.y
						local py = half.y - math.abs(dy)

						if px > 0 and py > 0 then
							for row in pairs(other.tiles) do
								for column in pairs(other.tiles[row]) do
									Roda.bus:emit('tile/remove', 'ground', other.tiles[row][column].transform.position)
								end
							end
							Roda.bus:emit('world/remove', other)
						end
					end
				end
			end
		end
	end)

	Roda.bus:register('input/mouse/released', function(event)
		if self.placing_blocks then
			if self.start_drag ~= nil then
				local layer

				if self.layer == 0 then
					layer = 'background'
				elseif self.layer == 1 then
					layer = 'ground'
				elseif self.layer == 2 then
					layer = 'foreground'
				end

				local x, y = Roda.scene[layer]:get_tile_index(event.position)
				self.end_drag = Vector(x, y)

				Roda.bus:emit(
					'tile/add/block',
					layer,
					self.tile,
					self.tile .. '.png',
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
	if self.placing_tiles or self.placing_blocks then
		if self.placing_tiles then
			love.graphics.setColor(255, 0, 0, 100)
		else
			love.graphics.setColor(0, 0, 255, 100)
		end

		love.graphics.rectangle(
			'fill',
			love.mouse.getX() - 16,
			love.mouse.getY() - 16,
			32,
			32
		)

		love.graphics.setColor(255, 255, 255, 255)
	end

	if self.show_window then
		status, showAnotherWindow = imgui.Begin("Map", true, { 'AlwaysAutoResize' });

		-- Tiles
		imgui.ListBoxHeader('Tiles', 2)
		if imgui.Selectable('terrain_01', self.tile == 'terrain_01') then
			self.tile = 'terrain_01'
		end
		if imgui.Selectable('terrain_02', self.tile == 'terrain_02') then
			self.tile = 'terrain_02'
		end
		imgui.ListBoxFooter()

		-- Layers
		if imgui.RadioButton('Background', self.layer, 0) then self.layer = 0 end 
		imgui.SameLine()
		if imgui.RadioButton('Ground', self.layer, 1) then self.layer = 1 end
		imgui.SameLine()
		if imgui.RadioButton('Foreground', self.layer, 2) then self.layer = 2 end

		-- Actions
		if imgui.Button('Draw Tiles', 100, 40) then
			self.placing_tiles = true
			self.placing_blocks = false
		end
		imgui.SameLine()

		if imgui.Button('Draw Blocks', 100, 40) then
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
