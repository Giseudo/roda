local Transform = require (RODA_SRC .. 'component.transform')
local Body = require (RODA_SRC .. 'component.body')
local Collider = require (RODA_SRC .. 'component.collider')
local Sprite = require (RODA_SRC .. 'component.sprite')
local Animator = require (RODA_SRC .. 'component.animator')
local Controller = require (RODA_SRC .. 'component.controller')

local b2 = {}
b2.__index = b2

function b2:new(position, size)
	local o = {}

	o.transform = Transform(position)
	o.body = Body(Vector(0, 0), Vector(0, 0), Vector(-0.15, 0.0))
	o.collider = Collider(Rect(position, size), true)
	o.sprite = Sprite('assets/images/B2.png', 32, 32, 0)
	o.animator = Animator('Idle', 0, 6)

	return setmetatable(o, b2)
end

function b2:jump()
	self.body.velocity.y = 11
end

return setmetatable(b2, { __call = b2.new })
