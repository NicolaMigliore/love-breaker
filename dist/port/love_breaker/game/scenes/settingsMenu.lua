local SettingsMenu = {
	prev = nil,
	layers = {}, 
	container = nil,
}

function SettingsMenu:enter(prev)
	self.prev = prev

	self.formState = {
		debugMode = GAME_SETTINGS.debugMode,
		enableShaders = GAME_SETTINGS.enableShaders,
		volumeSfx = GAME_SETTINGS.volumeSfx,
	}

	self.initialSettings = {
		debugMode = GAME_SETTINGS.debugMode,
		enableShaders = GAME_SETTINGS.enableShaders,
		volumeSfx = GAME_SETTINGS.volumeSfx,
	}

	self.container = self:getContainer()
end

function SettingsMenu:update()
	if INPUT:released('start') then GameState.switch(self.prev) return end
end

function SettingsMenu:leave()
	if UI:layerExists('settingsMain') then
		UI:removeLayer('settingsMain')
	end
end

function SettingsMenu:getContainer()
	local layerName = 'settingsMain'
	-- UI - create main layer
	UI:newLayer(layerName)

	local decorator = THEMES.basic.decorator

	local maxRow, maxCol = UI:getMaxRow(), UI:getMaxCol()
	local cw, ch = 20, 25
	local c_main = UI:newContainer(layerName, cw, ch, (maxRow / 2) - (ch / 2) + 1, (maxCol / 2) - (cw / 2) + 1, decorator, nil, 'mainContainer')

	local lw, lh = cw - 2, 3
	local lCol = (cw / 2) - (lw / 2) + 1
	local customTheme = THEMES.basic.text
	customTheme.font = FONTS.robotic_l
	local l_title = UI:newLabel(layerName, 'SETTINGS', lw, lh, ALIGNMENTS.center, customTheme)
	c_main:addChild(l_title, 2, lCol)

	-- Debug
	lw, lh = 9, 2
	local l_debug = UI:newLabel(layerName, 'DEBUG-MODE:', lw, lh, ALIGNMENTS.left, nil)
	c_main:addChild(l_debug, 8, 5)
	local checkCol = 15
	local check_debug = UI:newCheckBox(layerName, self.formState.debugMode, function(newDebugMode)
		self.formState.debugMode = newDebugMode
	end)
	c_main:addChild(check_debug, 8.5, checkCol)

	-- Shaders
	local l_shader = UI:newLabel(layerName, 'SHADERS:', lw, lh, ALIGNMENTS.left, nil)
	c_main:addChild(l_shader, 11, 5)
	local check_shader = UI:newCheckBox(layerName, self.formState.enableShaders, function(newDebugMode)
		self.formState.enableShaders = newDebugMode
	end)
	c_main:addChild(check_shader, 11.5, checkCol)

	-- SFX
	lw = 5
	local l_sfx = UI:newLabel(layerName, 'SOUNDS:', lw, lh, ALIGNMENTS.left, nil)
	c_main:addChild(l_sfx, 14, 5)
	sw = 5
	local s_sfx = UI:newSlider(layerName, 0, 1, self.formState.volumeSfx, sw, 2, function(newVolume)
		self.formState.volumeSfx = newVolume
		self:setVolumeSfx(newVolume)
		AUDIO.sfx.click:play()
	end)
	c_main:addChild(s_sfx, 14, 7 + lw)

	-- Music
	local l_sfx = UI:newLabel(layerName, 'MUSIC:', lw, lh, ALIGNMENTS.left, nil)
	c_main:addChild(l_sfx, 17, 5)
	sw = 5
	local s_sfx = UI:newSlider(layerName, 0, 5, 5, sw, 2, function(newVolume) print('TO IMPLEMENT new value: '..newVolume) end)
	c_main:addChild(s_sfx, 17, 7 + lw)

	-- Actions
	local bw, bh = 8, 2
	local bCol = 2
	local b_apply = UI:newButton(layerName, 'APPLY', bw, bh, THEMES.basic.decorator, nil, function()
		GAME_SETTINGS.debugMode = self.formState.debugMode
		GAME_SETTINGS.enableShaders = self.formState.enableShaders
		self:setVolumeSfx(self.formState.volumeSfx)
		GAME_SETTINGS:saveSettings()

		GameState.switch(self.prev)
	end)
	c_main:addChild(b_apply, 23, bCol)

	bCol = bCol + 10
	local b_apply = UI:newButton(layerName, 'CANCEL', bw, bh, THEMES.basic.decorator, nil, function()
		GAME_SETTINGS.debugMode = self.initialSettings.debugMode
		GAME_SETTINGS.enableShaders = self.initialSettings.enableShaders
		self:setVolumeSfx(self.initialSettings.volumeSfx)
		GameState.switch(self.prev)
	end)
	c_main:addChild(b_apply, 23, bCol)

	-- after adding all elements to the container animate it
	UI:animateContainer(c_main, .2)
	return c_main
end

function SettingsMenu:setVolumeSfx(newVolume)
	GAME_SETTINGS.volumeSfx = newVolume
	AUDIO:setVolume()
end



return SettingsMenu