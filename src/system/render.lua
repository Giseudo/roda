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

function render:onRemove(e)
	e.sprite.batch:set(e.sprite.id, 0, 0, 0, 0)
end

function render:process(e, dt)
	if e == nil then
		return
	end

	if Vector.distance(e.transform.position, Roda.scene.camera.transform.position) < 470 then
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
	else
		e.sprite.batch:set(e.sprite.id, 0, 0, 0, 0)
	end
end

function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

function render:postProcess(dt)
	-- Draw sprite batches
	for key, batch in pairsByKeys(Roda.graphics.batches) do
		love.graphics.draw(batch)
	end

	Roda.bus:emit('camera/unset')
end

return setmetatable(render, {
	__call = render.new
})
