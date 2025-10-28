local Settings = Object:extend()

function Settings:new(baseWidth, basedHeight, scale)
	self.scale = scale               -- SCALE
	self.fixedWidth = 360 * self.scale -- FIXED_WIDTH
	self.fixedHeight = 360 * self.scale -- FIXED_HEIGHT

	self.debugMode = false
	self.enableShaders = false

	self.volumeSfx = 1
end

-- load setting from settings file if available
function Settings:loadSettings()
	local settingsString = love.filesystem.read('settings.json')
	if settingsString then
		local jSettings = Json.decode(settingsString)
		self.scale = jSettings.scale
		self.fixedWidth = jSettings.fixedWidth
		self.fixedHeight = jSettings.fixedHeight
		self.debugMode = jSettings.debugMode
		self.enableShaders = jSettings.enableShaders
		self.volumeSfx = jSettings.volumeSfx
	else
		print('Alert: did not find settings. Writing default settings!')
		self:saveSettings()
	end
end

function Settings:saveSettings()
	local jSettings = {}
	jSettings.scale = self.scale
	jSettings.fixedWidth = self.fixedWidth
	jSettings.fixedHeight = self.fixedHeight
	jSettings.debugMode = self.debugMode
	jSettings.enableShaders = self.enableShaders
	jSettings.volumeSfx = self.volumeSfx
	local settingsString = Json.encode(jSettings)
	love.filesystem.write('settings.json', settingsString)
end

return Settings
