local Class = require (LIB_PATH .. "hump.class")
local Device = Class{
	joystick = false,
	up = "up",
	left = "left",
	right = "right",
	down = "down",
	jump = "space"
}

function Device:init()
end

return Device
