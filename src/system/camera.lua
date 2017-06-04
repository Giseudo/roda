local Tiny = require 'tiny'

local camera = {}
camera.__index = camera

function camera:new()
end

function camera:process(e, dt)
end

return setmetatable(camera, {
	__call = camera.new
})
