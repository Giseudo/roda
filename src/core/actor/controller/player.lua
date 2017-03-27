local Class = require 'middleclass'
local Controller = require (RODA_SRC .. 'core.controller')

local player_controller = Class('PlayerController', Controller)

function player_controller:initialize()
	self.index = 0
end

return player_controller
