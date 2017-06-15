local Camera = require(RODA_SRC .. 'entity.camera')

local scene = {}
scene.__index = scene

function scene:new()
	local o = {}

	o.camera = Camera()

	return setmetatable(o, scene)
end

function scene:init()
	self.camera:zoom(Roda.graphics.scale)

	Roda.bus:register('camera/set', function() self:camera_set() end)
	Roda.bus:register('camera/unset', function() self:camera_unset() end)
	Roda.bus:register('camera/target', function(e) self.camera.target = e end)
	Roda.bus:register('camera/zoom', function(i) self.camera:zoom(i) end)
	Roda.bus:emit('world/add', self.camera)
end

function scene:camera_set()
	local x = math.floor(love.graphics.getWidth() / 2) / self.camera.transform.scale.x
	local y = math.floor(love.graphics.getHeight() / 2) / self.camera.transform.scale.y

	-- Set World Coodinate
	love.graphics.push()
	love.graphics.scale(self.camera.transform.scale.x, self.camera.transform.scale.y)
	love.graphics.rotate(self.camera.rotation)
	love.graphics.translate(
		- self.camera.transform.position.x + x,
		- self.camera.transform.position.y + y
	)
end

function scene:camera_unset()
	love.graphics.pop()
end

return setmetatable(scene, {
	__call = scene.new
})
