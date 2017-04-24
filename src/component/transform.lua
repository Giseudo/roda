local transform = {}

function transform:new(position, scale, rotation)
	return setmetatable({
		position = position or Vector(0, 0),
		scale = scale or Vector(1, 1),
		rotation = rotation or 0
	},
	{ __index = self })
end

return setmetatable(transform, { __call = transform.new })
