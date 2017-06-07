local graphics = {}
graphics.__index = graphics

function graphics:new(width, height, scale)
	local o = {}

	o.width = width or 320
	o.height = height or 200
	o.scale = scale or 3
	o.unit = 16
	batches = {}

	return setmetatable(o, graphics)
end

function graphics:init()
	-- Graphics defaults
	love.graphics.setPointSize(8)

	-- Window defaults
	love.window.setMode(
		self.width * self.scale,
		self.height * self.scale
	)
end

return setmetatable(graphics, {
	__call = graphics.new
})
