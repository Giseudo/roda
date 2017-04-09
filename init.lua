require (GAME_LIB .. 'roda.env')
local Camera = require (RODA_SRC .. 'camera')

roda = {
	camera = Camera()
}

function roda:run()
	self.camera:set()
end

function roda:update(dt)
end

function roda:events()
end

function roda:draw()
end

function roda:quit()
end
