local Tiny = require (LIB_PATH .. "tiny.tiny")
local DrawSystem = Tiny.processingSystem()

DrawSystem.filter = Tiny.requireAll("sprite", "position")

function DrawSystem:process(e, dt)
	e.sprite:draw(dt, e.position)
end


return DrawSystem
