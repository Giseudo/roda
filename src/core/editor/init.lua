local editor = {}
editor.__index = editor

function editor:new()
	local o = {}

	return setmetatable(o, editor)
end

function editor:init()
	Roda.bus:register('input/pressed/key', function(key)
		-- Shortcuts
		if key == 'd' then
			if Roda.debug == true then
				Roda.debug = false
			else
				Roda.debug = true
			end
		end

		-- Camera inputs
		if key == 'z' then
			Roda.camera:zoom(1)
		end
		if key == 'x' then
			Roda.camera:zoom(-1)
		end
	end)
end

return setmetatable(editor, {
	__call = editor.new
})