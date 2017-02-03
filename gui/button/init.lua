local Class = require (LIB_PATH .. "hump.class")
local Label = require (RODA_PATH .. "gui.label")

local Button = Class{
	__includes = Label,
	disabled = false
}

function Button:init()
	Label.init(self)
end

function Button:click()
end
