local Tiny = require (LIB_PATH .. "tiny.tiny")
local DrawSystem = Tiny.processingSystem()

DrawSystem.filter = Tiny.requireAll("sprite", "transform")

function DrawSystem:process(e, dt)
	e.sprite:draw(dt, e.transform.position)
end


return DrawSystem
