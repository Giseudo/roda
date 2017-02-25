local Tiny = require (LIB_PATH .. "tiny.tiny")
local DebugSystem = Tiny.processingSystem()

DebugSystem.filter = Tiny.requireAll("sprite", "position")

function DebugSystem:process(e, dt)
	love.graphics.rectangle(
		"line",
		e.position.x - e.sprite.width / 2,
		e.position.y - e.sprite.height / 2,
		e.sprite.width,
		e.sprite.height
	)

end


return DebugSystem
