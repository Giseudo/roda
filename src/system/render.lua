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

function render:process(e, dt)
	--[[ Outline sprite
	love.graphics.setColor(255, 0, 255, 255)
	Roda:set_shader('outline')

	Roda.shader:send('stepSize', {
		1 / e.sprite.texture:getWidth(),
		1 / e.sprite.texture:getHeight()
	})

	love.graphics.draw(
		e.sprite.texture,
		e.sprite.quad,
		e.transform.position.x - 16,
		e.transform.position.y - 16
	)

	love.graphics.setColor(255, 255, 255, 255)
	Roda:set_shader('default')]]
	love.graphics.draw(
		e.sprite.texture,
		e.sprite.quad,
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2
	)

end

return setmetatable(render, {
	__call = render.new
})
