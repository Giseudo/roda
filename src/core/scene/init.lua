local Camera = require(RODA_SRC .. 'entity.camera')
local Layer = require(RODA_SRC .. 'core.scene.layer')
local Tile = require(RODA_SRC .. 'entity.tile')
local Block = require(RODA_SRC .. 'entity.block')
local Skeleton = require(GAME_SRC .. 'entity.skeleton')
local Robot = require(GAME_SRC .. 'entity.robot')
local Bomb = require(GAME_SRC .. 'entity.bomb')
local Hand = require(GAME_SRC .. 'entity.hand')
local Skull = require(GAME_SRC .. 'entity.skull')
local Life = require(GAME_SRC .. 'entity.life')

local scene = {}
scene.__index = scene

function split(s, delimiter)
	result = {};
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	return result;
end


function scene:new()
	local o = {
		background = Layer(500, 20),
		ground = Layer(500, 20),
		foreground = Layer(500, 20)
	}

	o.camera = Camera()

	return setmetatable(o, scene)
end

function scene:init()
	self.camera:zoom(1)

	Roda.bus:register('camera/set', function() self:camera_set() end)
	Roda.bus:register('camera/unset', function() self:camera_unset() end)
	Roda.bus:register('camera/target', function(e) self.camera.target = e end)
	Roda.bus:register('camera/zoom', function(i) self.camera:zoom(i) end)
	Roda.bus:register('camera/follow', function(direction) self.camera.follow = direction end)
	Roda.bus:register('camera/background', function(file) self.camera:set_background('assets/textures/' .. file) end)

	Roda.bus:register('tile/add', function(layer, name, file, position)
		local x, y = self[layer]:get_tile_index(position)

		if x ~= 0 and y ~= 0 then
			if self[layer].tiles[x][y] == nil then
				local tile = Tile(self[layer]:get_tile_position(x, y), name, 'assets/textures/' .. file)
				self[layer]:add_tile(tile, x, y)
				Roda.bus:emit('world/add', tile)
			end
		end
	end)

	Roda.bus:register('tile/remove', function(layer, position)
		local x, y = self[layer]:get_tile_index(position)

		if x ~= 0 and y ~= 0 then
			if self[layer].tiles[x][y] ~= nil then
				local tile = self[layer]:remove_tile(x, y)
				Roda.bus:emit('world/remove', tile)
			end
		end
	end)

	Roda.bus:register('tile/add/block', function(layer, name, file, x, y, dx, dy)
		local tiles = {}
		local columns, rows = 0, 0

		if math.min(x, dx) > 0 and math.min(y, dy) > 0 then
			for i = math.min(x, dx), math.max(x, dx) do
				tiles[i] = {}
				rows = 0
				columns = columns + 1

				for k = math.min(y, dy), math.max(y, dy) do
					local tile = Tile(self[layer]:get_tile_position(i, k), name, 'assets/textures/' .. file)
					tiles[i][k] = tile
					rows = rows + 1

					self[layer]:add_tile(tile, i, k)
					Roda.world:add(tile)
				end
			end

			local first = self[layer]:get_tile_position(math.min(x, dx), math.max(y, dy))
			local second = self[layer]:get_tile_position(math.max(x, dx), math.min(y, dy))

			local position = first + (second - first) / 2
			local block = Block(position, tiles, Vector(columns, rows))

			Roda.world:add(block)
			Roda.world:refresh()
		end
	end)

	-- Save scene
	Roda.bus:register('scene/save', function(file)
		--[[ Tiles
		local data = ''
		for i = 0, self['ground'].rows do
			for k = 0, self['ground'].columns do
				if self['ground']:get_tile(k, i) then
					data = data .. '1'
				else
					data = data .. '0'
				end
			end
			data = data .. '\n'
		end

		love.filesystem.write(file .. '.txt', data)]]

		-- Entities
		local data = ''
		for _, e in pairs(Roda.physics.quadtree) do
			if e.name and e.name ~= 'hand' and e.name ~= 'skull' and e.name ~= 'waterfall' and e.name ~= 'rock' then
				data = data .. e.name .. ','

				if e.tiles == nil then
					data = data .. e.transform.position.x .. ','
					data = data .. e.transform.position.y .. ','
				else
					local minx = 500
					local miny = 500
					local maxx = 0
					local maxy = 0

					for i, row in pairs(e.tiles) do
						for k, column in pairs(row) do
							minx = math.min(i, minx)
							miny = math.min(k, miny)

							maxx = math.max(i, maxx)
							maxy = math.max(k, maxy)
						end
					end

					data = data .. math.min(minx, maxx) .. ',' .. math.max(miny, maxy) .. ','
					data = data .. math.max(minx, maxx) .. ',' .. math.min(miny, maxy)
				end

				if e.polarity then
					data = data .. e.polarity
				end

				data = data .. '\r\n'
			end
		end

		love.filesystem.write(file .. '.txt', data)
	end)

	Roda.bus:register('scene/load', function(file)
		Roda.bus:emit('world/clear/entities')
		Game:place_entities()

		-- Load entities
		if love.filesystem.exists(file .. '.txt') then
			for line in love.filesystem.lines(file .. '.txt') do
				local value = split(line, ',')
				local name = value[1]
				local x = tonumber(value[2])
				local y = tonumber(value[3])
				local polarity = value[4]

				if name == 'life' then
					Roda.bus:emit('world/add', Life(Vector(x, y)))
				elseif name == 'skeleton' then
					Roda.bus:emit('world/add', Skeleton(Vector(x, y), Vector(16, 32), polarity))
				elseif name == 'robot' then
					Roda.bus:emit('world/add', Robot(Vector(x, y), Vector(16, 16), polarity))
				elseif name == 'bomb' then
					Roda.bus:emit('world/add', Bomb(Vector(x, y), Vector(16, 16), polarity))
				elseif name == 'hand' then
					Roda.bus:emit('world/add', Hand(Vector(x, y), Vector(100, 80), polarity))
				elseif name == 'skull' then
					Roda.bus:emit('world/add', Skull(Vector(x, y), Vector(40, 40), polarity))
				elseif name == 'block' then
					local dx = tonumber(value[4])
					local dy = tonumber(value[5])

					Roda.bus:emit(
						'tile/add/block',
						'ground',
						'terrain_01',
						'terrain_01.png',
						x, y,
						dx, dy
					)
				end
			end
		end
	end)

	--[[ Load tiles
	if love.filesystem.exists('tiles.txt') then
		local k = 0
		for line in love.filesystem.lines('tiles.txt') do
			for i = 0, #line do
				local value = tonumber(line:sub(i, i))

				if value == 1 then
					Roda.bus:emit(
						'tile/add',
						'ground',
						'terrain_01',
						'terrain_01.png',
						self['ground']:get_tile_position(i, k)
					)
				end
			end
			k = k + 1
		end
	end]]
end

function scene:camera_set()
	local x = math.floor(love.graphics.getWidth() / 2) / self.camera.transform.scale.x
	local y = math.floor(love.graphics.getHeight() / 2) / self.camera.transform.scale.y

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.scale(self.camera.transform.scale.x, self.camera.transform.scale.y)
	love.graphics.rotate(self.camera.rotation)
	love.graphics.translate(
		- self.camera.transform.position.x + x,
		- self.camera.transform.position.y + y
	)
end

function scene:camera_unset()
	love.graphics.pop()
end

function scene:update(dt)
	local e = self.camera

	if e.target.transform then
		local horizontal = math.floor((e.target.transform.position.x - e.transform.position.x) * 3 * dt)
		local vertical = math.floor((e.target.transform.position.y - e.transform.position.y + 50.0) * 3 * dt)
		local position

		if e.follow == 'both' then
			position = Vector(horizontal, vertical)
		elseif e.follow == 'horizontal' then
			position = Vector(horizontal, 0)
		elseif e.follow == 'vertical' then
			position = Vector(0, vertical)
		end

		e.transform.position = e.transform.position + position
	end
end

return setmetatable(scene, {
	__call = scene.new
})
