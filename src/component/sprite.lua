local sprite = {}
sprite.__index = sprite

function sprite:new(file, width, height, frame)
	local o = {}

	o.texture = love.graphics.newImage(file)
	o.width = width
	o.height = height
	o.frame = frame or 0
	o.quad = love.graphics.newQuad(width * o.frame, 0, width, height, o.texture:getDimensions())

	return setmetatable(o, sprite)
end

return setmetatable(sprite, {
	__call = sprite.new
})
