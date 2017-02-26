local Tiny = require (LIB_PATH .. "tiny.tiny")
local DrawSystem = Tiny.processingSystem()

DrawSystem.filter = Tiny.requireAll("sprite", "transform")

function DrawSystem:process(e, dt)
	love.graphics.draw(
		e.sprite.image,
		e.sprite.quad,
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2
	)
end


return DrawSystem
