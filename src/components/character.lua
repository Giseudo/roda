local Class = require (LIB_PATH .. "hump.class")
local Character = Class{
	health = 0,
	mana = 0,
	damage = 0
}

function Character:init(name)
	self.name = name
end

return Character
