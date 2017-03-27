local Class = require 'middleclass'
local Controller = require (RODA_SRC .. 'core.controller')

local ai_controller = Class('AIController', Controller)

function ai_controller:initialize()
end

return ai_controller
