local Camera = require(RODA_SRC .. 'entity.camera')
local Layer = require(RODA_SRC .. 'core.scene.layer')
local Tile = require(RODA_SRC .. 'entity.tile')
local Block = require(RODA_SRC .. 'entity.block')

local scene = {}
scene.__index = scene

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
	Roda.bus:emit('world/add', self.camera)

	Roda.bus:register('tile/add', function(name, file, position)
		local x, y = self.ground:get_tile_index(position)

		if x ~= 0 and y ~= 0 then
			if self.ground.tiles[x][y] == nil then
				local tile = Tile(self.ground:get_tile_position(x, y), name, 'assets/textures/' .. file)
				self.ground:add_tile(tile, x, y)
				Roda.world:add(tile)
				Roda.world:refresh()
			end
		end
	end)

	Roda.bus:register('tile/add/block', function(name, file, x, y, dx, dy)
		local tiles = {}
		local columns, rows = 0, 0

		if math.min(x, dx) > 0 and math.min(y, dy) > 0 then
			for i = math.min(x, dx), math.max(x, dx) do
				tiles[i] = {}
				rows = 0
				columns = columns + 1

				for k = math.min(y, dy), math.max(y, dy) do
					local tile = Tile(self.ground:get_tile_position(i, k), name, 'assets/textures/' .. file)
					tiles[i][k] = tile
					rows = rows + 1

					self.ground:add_tile(tile, i, k)
					Roda.world:add(tile)
				end
			end

			local first = self.ground:get_tile_position(math.min(x, dx), math.max(y, dy))
			local second = self.ground:get_tile_position(math.max(x, dx), math.min(y, dy))

			local position = first + (second - first) / 2
			local block = Block(position, tiles, Vector(columns, rows))

			Roda.world:add(block)
			Roda.world:refresh()
		end
	end)
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

return setmetatable(scene, {
	__call = scene.new
})
