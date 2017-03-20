local Class = require 'middleclass'

local character = Class('Character')

function character:initialize(name)
	self.name = name
	self.health = 0
	self.mana = 0
	self.damage = 0
end

return character
