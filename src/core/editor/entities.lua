require 'imgui'

local Skeleton = require (GAME_SRC .. 'entity.skeleton')
local Robot = require (GAME_SRC .. 'entity.robot')
local Bomb = require (GAME_SRC .. 'entity.bomb')
local Hand = require (GAME_SRC .. 'entity.hand')
local Rocks = require (GAME_SRC .. 'entity.rocks')
local Skull = require (GAME_SRC .. 'entity.skull')
local Life = require (GAME_SRC .. 'entity.life')

local editor_entities = {}
editor_entities.__index = editor_entities

function editor_entities:new()
	local o = {
		show_window = false,
		placing_entities = false,
		holding = nil,
		polarity = 0,
		entity = 'life'
	}

	return setmetatable(o, editor_entities)
end

function editor_entities:init()
	Roda.bus:register('input/mouse/pressed', function(event)
		if self.placing_entities then
			self.placing_entities = false
			self.holding = nil
		elseif event.button == 1 then
			for _, other in pairs(Roda.physics.quadtree) do
				if other.collider and other.tiles == nil then
					local half = other.collider.shape:get_half()
					local dx = event.position.x - other.transform.position.x
					local px = half.x - math.abs(dx)
					local dy = event.position.y - other.transform.position.y
					local py = half.y - math.abs(dy)

					if px > 0 and py > 0 then
						self.holding = other
						self.placing_entities = true
					end
				end
			end
		end

		if event.button == 2 then
			for _, other in pairs(Roda.physics.quadtree) do
				if other.collider and other.tiles == nil then
					local half = other.collider.shape:get_half()
					local dx = event.position.x - other.transform.position.x
					local px = half.x - math.abs(dx)
					local dy = event.position.y - other.transform.position.y
					local py = half.y - math.abs(dy)

					if px > 0 and py > 0 then
						Roda.bus:emit('world/remove', other)
					end
				end
			end
		end
	end)

	Roda.bus:register('input/mouse/moved', function(event)
		if self.placing_entities and self.holding then
			self.holding.transform.position = event.position
		end
	end)
end

function editor_entities:update()
end

function editor_entities:draw()
	if self.show_window then
		imgui.Begin("Entities", true, { 'AlwaysAutoResize' });

		imgui.ListBoxHeader('Tiles', 2)
		if imgui.Selectable('life', self.entity == 'life') then
			self.entity = 'life'
		end
		if imgui.Selectable('skeleton', self.entity == 'skeleton') then
			self.entity = 'skeleton'
		end
		if imgui.Selectable('robot', self.entity == 'robot') then
			self.entity = 'robot'
		end
		if imgui.Selectable('bomb', self.entity == 'bomb') then
			self.entity = 'bomb'
		end
		if imgui.Selectable('hand', self.entity == 'hand') then
			self.entity = 'hand'
		end
		if imgui.Selectable('waterfall', self.entity == 'waterfall') then
			self.entity = 'waterfall'
		end
		if imgui.Selectable('skull', self.entity == 'skull') then
			self.entity = 'skull'
		end
		imgui.ListBoxFooter()

		if imgui.RadioButton('Light', self.polarity, 0) then self.polarity = 0 end 
		imgui.SameLine()
		if imgui.RadioButton('Dark', self.polarity, 1) then self.polarity = 1 end

		if imgui.Button('Place Entity', 100, 40) then
			local polarity

			if self.polarity == 0 then
				polarity = 'light'
			elseif self.polarity == 1 then
				polarity = 'dark'
			end

			if self.entity == 'life' then
				self.holding = Life(Vector(0, 0))
			elseif self.entity == 'robot' then
				self.holding = Robot(Vector(0, 0), Vector(16, 16), polarity)
			elseif self.entity == 'skeleton' then
				self.holding = Skeleton(Vector(0, 0), Vector(16, 32), polarity)
			elseif self.entity == 'bomb' then
				self.holding = Bomb(Vector(0, 0), Vector(16, 16), polarity)
			elseif self.entity == 'hand' then
				self.holding = Hand(Vector(0, 0), Vector(100, 80), polarity)
			elseif self.entity == 'skull' then
				self.holding = Skull(Roda.scene.camera:get_coords(love.mouse.getX(), love.mouse.getY()), Vector(40, 40), polarity)
			end

			self.placing_entities = true

			Roda.bus:emit('world/add', self.holding)
		end

		imgui.End()
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
