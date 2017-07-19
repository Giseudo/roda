local Tiny = require 'tiny'

local character = {}
character.__index = character

function character:new()
	local o = setmetatable({
		filter = Tiny.requireAll('transform', 'state'),
		isUpdateSystem = true
	}, character)

	return Tiny.processingSystem(o)
end

function character:onAdd(e)
end

function character:onRemove(e)
end

function character:process(e, dt)
	if e == nil then
		return
	end

	if Vector.distance(e.transform.position, Roda.scene.camera.transform.position) < 320 then
		e.state:update(dt)
	end
end

return setmetatable(character, {
	__call = character.new
})
