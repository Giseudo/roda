local Tiny = require 'tiny'

local render = {}
render.__index = render

function render:new()
	local o = setmetatable({
		filter = Tiny.requireAll('sprite', 'transform'),
		isDrawingSystem = true,
	}, render)

	return Tiny.processingSystem(o)
end

function render:onAdd(e)
	e.sprite.id = e.sprite.batch:add(e.sprite.quads[e.sprite.frame])
end

function render:process(e, dt)
	e.sprite.batch:set(
		e.sprite.id,
		e.sprite.quads[e.sprite.frame],
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2
	)

end

return setmetatable(render, {
	__call = render.new
})
