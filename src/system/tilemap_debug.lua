local Tiny = require 'tiny'

local tilemap_debug = {}
tilemap_debug.__index = tilemap_debug

function tilemap_debug:new()
	local o = setmetatable({
		filter = Tiny.requireAll('transform', 'tiles'),
		isDebugSystem = true
	}, tilemap_debug)

	return Tiny.processingSystem(o)
end

function tilemap_debug:preProcess(e)
	Roda.bus:emit('camera/set')
end

function tilemap_debug:process(e, dt)
	-- Set grid color
	love.graphics.setColor(255, 255, 255, 30)

	-- Draw columns
	for i = 0, e.columns do
		love.graphics.line(
			e.transform.position.x - math.ceil(e.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i,
			e.transform.position.y - math.floor(e.rows / 2) * Roda.graphics.unit,
			e.transform.position.x - math.ceil(e.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i,
			e.transform.position.y + math.ceil(e.rows / 2) * Roda.graphics.unit
		)
	end

	-- Draw rows
	for k = 0, e.rows do
		love.graphics.line(
			e.transform.position.x - math.ceil(e.columns / 2) * Roda.graphics.unit,
			e.transform.position.y - math.floor(e.rows / 2) * Roda.graphics.unit + Roda.graphics.unit * k,
			e.transform.position.x + math.floor(e.columns / 2) * Roda.graphics.unit,
			e.transform.position.y - math.floor(e.rows / 2) * Roda.graphics.unit + Roda.graphics.unit * k
		)
	end

	-- Draw X axis line
	love.graphics.setColor(255, 0, 0, 150)
	love.graphics.line(
		e.transform.position.x - math.ceil(e.columns / 2) * Roda.graphics.unit,
		e.transform.position.y,
		e.transform.position.x + math.floor(e.columns / 2) * Roda.graphics.unit,
		e.transform.position.y
	)

	-- Draw Y axis line
	love.graphics.setColor(0, 0, 255, 150)
	love.graphics.line(
		e.transform.position.x,
		e.transform.position.y + math.ceil(e.rows / 2) * Roda.graphics.unit,
		e.transform.position.x,
		e.transform.position.y - math.floor(e.rows / 2) * Roda.graphics.unit
	)

	love.graphics.setColor(255, 255, 255, 255)
end

function tilemap_debug:postProcess(dt)
	Roda.bus:emit('camera/unset')
end

return setmetatable(tilemap_debug, {
	__call = tilemap_debug.new
})
