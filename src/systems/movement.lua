local Tiny = require (LIB_PATH .. "tiny.tiny")
local MovementSystem = Tiny.processingSystem()

MovementSystem.filter = Tiny.requireAll("transform", "velocity")

function MovementSystem:process(e, dt)
end


return MovementSystem
