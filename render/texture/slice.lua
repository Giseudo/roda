local Class = require (LIB_PATH .. "hump.class")
local Texture = require (RODA_PATH .. "render.texture")

local TextureSlice = Class{
	__includes = Texture,
	slice = 8,
	quads = {
		top_left,
		top,
		top_right,
		middle_left,
		middle,
		middle_right,
		bottom_left,
		bottom,
		bottom_right
	}
}

function TextureSlice:init(file, slice, width, height)
	Texture.init(self, file)
	self.slice = slice
	self.width = width
	self.height = height

	-- Top quads
	self.quads.top_left = love.graphics.newQuad(0, 0, slice, slice, self.image:getDimensions())
	self.quads.top = love.graphics.newQuad(slice, 0, slice, slice, self.image:getDimensions())
	self.quads.top_right = love.graphics.newQuad(slice * 2, 0, slice, slice, self.image:getDimensions())

	-- Middle quads
	self.quads.middle_left = love.graphics.newQuad(0, slice, slice, slice, self.image:getDimensions())
	self.quads.middle = love.graphics.newQuad(slice, slice, slice, slice, self.image:getDimensions())
	self.quads.middle_right = love.graphics.newQuad(slice * 2, slice, slice, slice, self.image:getDimensions())

	-- Bottom quads
	self.quads.bottom_left = love.graphics.newQuad(0, slice * 2, slice, slice, self.image:getDimensions())
	self.quads.bottom = love.graphics.newQuad(slice, slice * 2, slice, slice, self.image:getDimensions())
	self.quads.bottom_right = love.graphics.newQuad(slice * 2, slice * 2, slice, slice, self.image:getDimensions())
end

function TextureSlice:draw(position, padding)
	-- Top
	love.graphics.draw(
		self.image,
		self.quads.top_left,
		position.x - self.slice,
		position.y - self.slice
	)

	love.graphics.draw(
		self.image,
		self.quads.top,
		position.x,
		position.y - self.slice,
		0,
		(self.width + padding * 2) / self.slice, 1
	)

	love.graphics.draw(
		self.image,
		self.quads.top_right,
		position.x + self.width + (padding * 2),
		position.y - self.slice
	)

	-- Middle
	love.graphics.draw(
		self.image,
		self.quads.middle_left,
		position.x - self.slice,
		position.y,
		0,
		1,
		(self.height + padding * 2) / self.slice
	)

	love.graphics.draw(
		self.image,
		self.quads.middle,
		position.x,
		position.y,
		0,
		(self.width + padding * 2) / self.slice,
		(self.height + padding * 2) / self.slice
	)

	love.graphics.draw(
		self.image,
		self.quads.middle_right,
		position.x + self.width + (padding * 2),
		position.y,
		0,
		1,
		(self.height + padding * 2) / self.slice
	)

	-- Bottom
	love.graphics.draw(
		self.image,
		self.quads.bottom_left,
		position.x - self.slice,
		position.y + self.height + (padding * 2)
	)

	love.graphics.draw(
		self.image,
		self.quads.bottom,
		position.x,
		position.y + self.height + (padding * 2),
		0,
		(self.width + padding * 2) / self.slice,
		1
	)

	love.graphics.draw(
		self.image,
		self.quads.bottom_right,
		position.x + self.width + (padding * 2),
		position.y + self.height + (padding * 2)
	)
end

return TextureSlice
