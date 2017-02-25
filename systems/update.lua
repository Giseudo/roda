local Tiny = require (LIB_PATH .. "tiny.tiny")
local UpdateSystem = Tiny.processingSystem()

UpdateSystem.filter = Tiny.requireAll("update")

function UpdateSystem:process(e, dt)
	e:update(dt)
end


return UpdateSystem
