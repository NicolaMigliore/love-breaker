local GameOver = {
	score = 0,
	isEndless = false,
	layers = {}
}

function GameOver:enter(previous)
	self.score = previous.score
	self.isEndless = previous.isEndless

	Timer.after(.2, function() self:createUI() end)
end

function GameOver:update(dt)
end

function GameOver:draw()
end

function GameOver:leave()
	UI:removeLayer('main')
end

function GameOver:createUI()
	self.layers.main = UI:newLayer('main')
	
	local decorator = THEMES.basic.decorator
	local maxCol = UI:getMaxCol()
	local cw, ch = 24, 22
	local c_main = UI:newContainer('main', cw, ch, 8, (maxCol / 2) - (cw / 2) + 1, decorator, nil, 'mainContainer')

	local lw, lh = cw - 2, 3
	local lCol = (cw / 2) - (lw / 2) + 1
	local customTheme = {
		color = { 1, 1, 1, 1 },
		font = FONTS.robotic_l,
		align = 'center',
	}
	local l_title = UI:newLabel('main', 'GAME OVER', lw, lh, ALIGNMENTS.center, customTheme)
	c_main:addChild(l_title, 2, lCol)
	local l_score = UI:newLabel('main', 'SCORE: '..self.score, lw, lh, ALIGNMENTS.center)
	c_main:addChild(l_score, 5, lCol)

	local bw, bh = 8, 2
	local bCol = (cw / 2) - (bw / 2) + 1
	local b_restart = UI:newButton('main', 'RESTART', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.game, self.isEndless) end)
	c_main:addChild(b_restart, 11, bCol)
	local b_quit = UI:newButton('main', 'QUIT', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.title) end)
	c_main:addChild(b_quit, 14, bCol)

	UI:animateContainer(c_main, .2)
end

return GameOver
