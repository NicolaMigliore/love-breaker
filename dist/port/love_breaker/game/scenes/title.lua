local Title = {
	layers = {}
}

function Title:enter()
	Timer.after(.2, function() self:createUI() end)
end

function Title:update(dt)
end

function Title:draw()
end

function Title:leave()
	UI:removeLayer('titleMain')
end

function Title:createUI()
	-- UI - create main layer
	self.layers.main = UI:newLayer('titleMain')

	local decorator = THEMES.basic.decorator

	local maxCol = UI:getMaxCol()
	local cw, ch = 24, 27
	local cCol = (maxCol / 2) - (cw / 2) + 1
	local c_main = UI:newContainer('titleMain', cw, ch, 8, cCol, decorator, nil, 'mainContainer')

	local lw, lh = cw - 2, 3
	local lCol = (cw / 2) - (lw / 2) + 1
	local customTheme = {
		color = { 1, 1, 1, 1 },
		font = FONTS.robotic_l,
		align = 'center',
	}
	local l_title = UI:newLabel('titleMain', 'LOVE-BREAKER', lw, lh, ALIGNMENTS.center, customTheme)
	c_main:addChild(l_title, 2, lCol)

	local bw, bh = 8, 2
	local bCol = (cw / 2) - (bw / 2) + 1
	local b_start = UI:newButton('titleMain', 'CLASSIC', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.game, false) end)
	c_main:addChild(b_start, 8, bCol)
	local b_endless = UI:newButton('titleMain', 'ENDLESS', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.game, true) end)
	c_main:addChild(b_endless, 11, bCol)
	local b_settings = UI:newButton('titleMain', 'SCORES', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.highScore, true) end)
	c_main:addChild(b_settings, 14, bCol)
	local b_settings = UI:newButton('titleMain', 'SETTINGS', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.settingsMenu) end)
	c_main:addChild(b_settings, 17, bCol)
	local b_settings = UI:newButton('titleMain', 'EXIT', bw, bh, decorator, nil, function() love.event.quit() end)
	c_main:addChild(b_settings, 20, bCol)

	lw, lh = 5, 1
	local l_version = UI:newLabel('titleMain', 'v.'..GAME_VERSION, lw, lh, ALIGNMENTS.right)
	c_main:addChild(l_version, ch - lh + .5, cw - lw + .5)

	UI:animateContainer(c_main, .2)
end

return Title
