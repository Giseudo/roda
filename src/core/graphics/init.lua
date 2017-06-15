local graphics = {}
graphics.__index = graphics

function graphics:new(width, height, scale)
	local o = {}

	o.width = width or 480
	o.height = height or 270
	o.scale = scale or 3
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
			display = 2
		}
	)
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

		self.batches[batch] = love.graphics.newSpriteBatch(image)
	end

	return self.batches[batch]
end

return setmetatable(graphics, {
	__call = graphics.new
})
