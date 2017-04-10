require (GAME_LIB .. 'roda.env')
local Camera = require (RODA_SRC .. 'camera')

roda = {
	camera = Camera(),
	multiplier = 3
}

function roda:run()
	love.window.setMode(
		self.camera.width * self.multiplier,
		self.camera.height * self.multiplier, {
			vsync=true,
		}
	)
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	self.shader = love.graphics.newShader[[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
			vec4 pixel = Texel(texture, vec2(texture_coords.x, 1.0f - texture_coords.y));
			return pixel * color;
		}
	]]
end

function roda:update(dt)
end

function roda:events()
end

function roda:draw()
	love.graphics.setShader(self.shader)
	love.graphics.scale(self.multiplier, self.multiplier)
	love.graphics.clear(100, 100, 120, 255)
	self.camera:set()

	android = love.graphics.newImage("assets/images/B2.png")
	love.graphics.draw(android, love.graphics.newQuad(0, 0, 32, 32, android:getDimensions()), -16, -16)

	self.camera:unset()
end

function roda:quit()
end
