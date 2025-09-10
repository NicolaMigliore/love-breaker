

local Pause = {
	prev = nil,
	layers = {}, 
	container = nil,
}

function Pause:enter(prev)
	self.prev = prev
	self.container = self:getContainer()
end

function Pause:update()
	if INPUT:released('start') then GameState.pop() return end
end

function Pause:draw()
end

function Pause:getContainer()
	-- UI - create main layer
	self.layers.main = UI:newLayer('main')

	local decorator = THEMES.basic.decorator

	
	local maxRow, maxCol = UI:getMaxRow(), UI:getMaxCol()
	local cw, ch = 20, 25
	local c_main = UI:newContainer('main', cw, ch, (maxRow / 2) - (ch / 2) + 1, (maxCol / 2) - (cw / 2) + 1, decorator, nil, 'mainContainer')

	local lw, lh = cw - 2, 3
	local lCol = (cw / 2) - (lw / 2) + 1
	local customTheme = THEMES.basic.text
	customTheme.font = FONTS.robotic_l

	local l_title = UI:newLabel('main', 'PAUSE', lw, lh, ALIGNMENTS.center, customTheme)
	c_main:addChild(l_title, 2, lCol)

	local bw, bh = 8, 2
	local bCol = (cw / 2) - (bw / 2) + 1
	local b_resume = UI:newButton('main', 'RESUME', bw, bh, decorator, nil, function() GameState.pop() end)
	c_main:addChild(b_resume, 8, bCol)
	
	local b_title = UI:newButton('main', 'QUIT', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.title) end)
	c_main:addChild(b_title, 11, bCol)
end

function Pause:leave()
	UI:popLayer()
	UI:removeLayer('main')
end

return Pause
