local graphics = {}
graphics.__index = graphics

function graphics:new(width, height, scale)
	local o = {}

	o.width = width or 480
	o.height = height or 270
	o.scale = scale or 2
	o.unit = 16
	o.batches = {}

	return setmetatable(o, graphics)
end

function graphics:init()
	-- Graphics defaults
	love.graphics.setPointSize(8)

	-- Window defaults
	love.window.setMode(
		self.width * self.scale,
		self.height * self.scale,
		{
			display = 1,
			vsync = true
		}
	)
	love.window.setTitle('Sparkle')

	Roda.bus:register('world/clear', function()
		for i, batch in pairs(self.batches) do
			batch:clear()
			self.batches[i] = nil
		end
	end)

	Roda.bus:register('world/clear/entities', function()
		for i, batch in pairs(self.batches) do
			batch:clear()
			self.batches[i] = nil
		end
	end)
end

function graphics:get_batch(batch)
	if self.batches[batch] == nil then
		Roda.logger:error('Batch "' .. batch .. '" not found.', self)
		return
	end

	return self.batches[batch]
end

function graphics:add_batch(batch, file)
	if self.batches[batch] == nil then
		local image = love.graphics.newImage(file)

		self.batches[batch] = love.graphics.newSpriteBatch(image, 10000)
	end

	return self.batches[batch]
end

return setmetatable(graphics, {
	__call = graphics.new
})
