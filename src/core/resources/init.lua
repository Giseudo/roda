local ASSETS_DIR = 'assets/'

local resources = {}

function resources:new()
	local o = {}

	o.shaders = {}

	return setmetatable(o, { __index = resources })
end

function resources:load_shader(name, vertex, fragment, geometry)
	local shader = {}

	if vertex then
		shader.vertex = self:read('shaders/' .. vertex)
	end

	if fragment then
		shader.fragment = self:read('shaders/' .. fragment)
	end

	if geometry then
		shader.geometry = self:read('shaders' .. geometry)
	end

	self.shaders[name] = love.graphics.newShader(shader.vertex, shader.fragment, shader.geometry)
end

function resources:read(filepath)
	local content = love.filesystem.read(ASSETS_DIR .. filepath)

	if content == nil then
		Roda.logger:warn('File "' .. filepath .. '" not found.', self)
	end

	return content
end

return setmetatable(resources, { __call = resources.new })
