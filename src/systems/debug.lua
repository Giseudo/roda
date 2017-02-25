local Tiny = require (LIB_PATH .. "tiny.tiny")
local DebugSystem = Tiny.processingSystem()

DebugSystem.filter = Tiny.requireAll("sprite", "transform")

function DebugSystem:process(e, dt)
	love.graphics.rectangle(
		"line",
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2,
		e.sprite.width,
		e.sprite.height
	)

end


return DebugSystem
