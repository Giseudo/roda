local player = {}

function player:new(x, y, width, height)
	return setmetatable({
		position = Vector(x or 0, y or 0),
		acceleration = Vector(0, 0),
		velocity = Vector(0, 0),
		friction = -0.15,
		rect = Rect(x or 0, y or 0, 16, 32)
	},
	{ __index = self })
end

function player:jump()
	self.velocity.y = 30
end

function player:update(dt)
	-- Reset acceleration every frame
	self.acceleration = Vector(0, -.8)

	-- TODO Move this out here later
	function love.keypressed(key)
		if key == "space" then
			self:jump()
		end
	end
	if love.keyboard.isDown("left") then
		self.acceleration.x = -0.6
	end
	if love.keyboard.isDown("right") then
		self.acceleration.x = 0.6
	end
	if love.keyboard.isDown("down") then
		self.acceleration.y = -0.6
	end
	if love.keyboard.isDown("up") then
		self.acceleration.y = 0.6
	end

	-- Apply friction
	self.acceleration.x = self.acceleration.x + self.velocity.x * self.friction
	self.acceleration.y = self.acceleration.y + self.velocity.y * self.friction
	-- Equations of motion
	self.velocity = self.velocity + self.acceleration
	self.position = self.position + self.velocity + 0.5 * self.acceleration

	-- Update rect position
	self.rect.position = self.position
end

function player:draw()
	love.graphics.setColor(255, 0, 0, 150)
	love.graphics.rectangle(
		"fill",
		self.rect:get_left(),
		self.rect:get_bottom(),
		self.rect.width,
		self.rect.height
	)
end

return setmetatable(player, { __call = player.new })
