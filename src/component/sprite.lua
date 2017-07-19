local sprite = {}
sprite.__index = sprite

function sprite:new(name, file, width, height, frame, columns)
	local o = {}

	o.id = nil
	o.name = name
	o.width = width
	o.height = height
	o.frame = frame or 0
	o.columns = columns
	o.quads = {}
	o.file = file
	o.batch = Roda.graphics:add_batch(name, file)

	sprite.create_quads(o)

	return setmetatable(o, sprite)
end

function sprite:create_quads()
	local frame = 0

	for i = 0, self.columns do
		for k = 0, self.batch:getTexture():getHeight() / self.height do
			local column = math.floor(frame % self.columns)
			local row = math.floor(frame / self.columns)

			self.quads[frame] = love.graphics.newQuad(
				column * self.width,
				self.batch:getTexture():getHeight() - self.height - row * self.height,
				self.width,
				self.height,
				self.batch:getTexture():getDimensions()
			)

			frame = frame + 1
		end
	end
end

function sprite:set_texture(file)
	self.file = file
	self.batch:setTexture(love.graphics.newImage(file))
end

return setmetatable(sprite, {
	__call = sprite.new
})
