local Title = {
	layers = {}
}

function Title:enter(prev)
	-- UI - create main layer
	self.layers.main = Luis.newLayer('main')
	Luis.setCurrentLayer('main')

	local decorator = THEMES.basic.decorator

	local maxCol = UI:getMaxCol()
	local cw, ch = 24, 22
	local c_main = UI:newContainer('main', cw, ch, 8, (maxCol / 2) - (cw / 2) + 1, decorator, 'mainContainer')

	local lw, lh = cw - 2, 3
	local lCol = (cw / 2) - (lw / 2) + 1
	local customTheme = {
		color = { 1, 1, 1, 1 },
		font = FONTS.robotic_l,
		align = 'center',
	}
	-- local l_title = Luis.createElement('main', 'Label', 'PAUSE', lw, lh, 1, 1, 'center')
	local l_title = UI:newLabel('main', 'LOVE-BREAKER', lw, lh, ALIGNMENTS.center, customTheme)
	c_main:addChild(l_title, 2, lCol)

	local bw, bh = 8, 2
	local bCol = (cw / 2) - (bw / 2) + 1
	local b_start = UI:newButton('main', 'START', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.game) end)
	c_main:addChild(b_start, 8, bCol)
	local b_test = UI:newButton('main', 'TEST', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.game) end)
	c_main:addChild(b_test, 11, bCol)
end

function Title:update(dt)

end

function Title:draw()
end

function Title:leave()
	Luis.disableLayer('main')
	Luis.removeLayer('main')
end

return Title
