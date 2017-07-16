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

function render:preProcess(dt)
	Roda.bus:emit('camera/set')
end

function render:process(e, dt)
	e.sprite.batch:set(
		e.sprite.id,
		e.sprite.quads[e.sprite.frame],
		e.transform.position.x,
		e.transform.position.y,
		e.transform.rotation,
		e.transform.scale.x,
		e.transform.scale.y,
		e.sprite.width / 2,
		e.sprite.height / 2
	)
end

function render:postProcess(dt)
	-- Draw sprite batches
	for _, batch in pairs(Roda.graphics.batches) do
		love.graphics.draw(batch)
	end

	Roda.bus:emit('camera/unset')
end

return setmetatable(render, {
	__call = render.new
})
