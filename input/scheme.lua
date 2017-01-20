local Class = require (LIB_PATH .. "hump.class")

local Scheme = Class{
	up = "w",
	down = "a",
	right = "s",
	left = "d",
	horizontal = "",
	vertical = "",
	action = "space",
	cancel = "esc"
}

function Scheme:init()
end

return Scheme
