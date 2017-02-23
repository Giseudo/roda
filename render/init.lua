local love = love
local Class = require (LIB_PATH .. "hump.class")
local Fonts = require (RODA_PATH .. "render.fonts")

local Render = Class{
	bus = {},
	fonts = {}
}

function Render:init(bus)
	self.bus = bus
	self.fonts = Fonts(bus)

	--self.bus:post("render/fonts/add-image", {
	--	name = "glyph",
	--	file = "lib/roda/assets/fonts/glyph.png",
	--	chars = " abcdefghijklmnopqrstuvwxyz" ..
	--		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
	--		"123456789.,!?-+/():;%&`'*#=[]\""
	--})

	-- Change default filter to nearest neighbour
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	--self.bus:post("render/fonts/set", {
	--	name = "glyph"
	--})
end

function Render:draw(message)
	self.bus:post("render/draw", message);
end

return Render
