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

function TextureSlice:init(file, slice)
	Texture.init(self, file)
	self.slice = slice

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

function TextureSlice:draw(position)
	-- Top left / does not scale
	love.graphics.draw(
		self.image,
		self.quads.top_left,
		position.x,
		position.y
	)

	-- Top / scale width only
	love.graphics.draw(
		self.image,
		self.quads.top,
		position.x + self.slice,
		position.y,
		0,
		(self.width - self.slice * 2) / self.slice,
		1
	)

	-- Top right / does not scale
	love.graphics.draw(
		self.image,
		self.quads.top_right,
		position.x + self.width - self.slice,
		position.y
	)

	-- Middle left / scale height only
	love.graphics.draw(
		self.image,
		self.quads.middle_left,
		position.x,
		position.y + self.slice,
		0,
		1,
		(self.height - self.slice * 2) / self.slice
	)

	-- Middle / scale width only
	love.graphics.draw(
		self.image,
		self.quads.middle,
		position.x + self.slice,
		position.y + self.slice,
		0,
		(self.width - self.slice * 2) / self.slice,
		(self.height - self.slice * 2) / self.slice
	)

	-- Middle right / scale height only
	love.graphics.draw(
		self.image,
		self.quads.middle_right,
		position.x + self.width - self.slice,
		position.y + self.slice,
		0,
		1,
		(self.height - self.slice * 2) / self.slice
	)

	-- Bottom left / does not scale
	love.graphics.draw(
		self.image,
		self.quads.bottom_left,
		position.x,
		position.y + self.height - self.slice
	)

	-- Bottom / scale width only
	love.graphics.draw(
		self.image,
		self.quads.bottom,
		position.x + self.slice,
		position.y + self.height - self.slice,
		0,
		(self.width - self.slice * 2) / self.slice,
		1
	)

	-- Bottom right / does not scale
	love.graphics.draw(
		self.image,
		self.quads.bottom_right,
		position.x + self.width - self.slice,
		position.y + self.height - self.slice
	)
end

return TextureSlice
