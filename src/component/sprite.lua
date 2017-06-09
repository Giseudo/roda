local sprite = {}
sprite.__index = sprite

function sprite:new(file, width, height, frame, columns, offset)
	local o = {}

	o.texture = love.graphics.newImage(file)
	o.width = width
	o.height = height
	o.frame = frame or 0
	o.columns = columns
	o.quad = love.graphics.newQuad(0, 0, width, height, o.texture:getDimensions())
	o.offset = offset or Vector(0, 0)

	sprite.set_frame(o, o.frame)

	return setmetatable(o, sprite)
end

function sprite:set_frame(frame)
	local column = self.offset.x + math.floor(frame % self.columns)
	local row = self.offset.y + math.floor(frame / self.columns)

	self.frame = frame
	
	self.quad:setViewport(
		column * self.width,
		self.texture:getHeight() - self.height - row * self.height,
		self.width,
		self.height,
		self.texture:getDimensions()
	)
end

return setmetatable(sprite, {
	__call = sprite.new
})
