local Class = require 'middleclass'
local Pawn = require (RODA_SRC .. 'core.actor.pawn')

local character_pawn = Class('CharacterPawn', Pawn)

function character_pawn:initialize(camera)
	Pawn.initialize(self, camera)
end

return character_pawn
