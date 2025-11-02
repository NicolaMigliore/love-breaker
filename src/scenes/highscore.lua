local HighScore = {
	scores = {},
	isViewMode = false,
	isAddingScore = false,
	newScore = 0,
}

function HighScore:enter(previous, isViewMode)
	self:loadScores()

	self.isViewMode = isViewMode or false
	self.isEndless = previous.isEndless
	self.newScore = previous.score or 0
	self.isAddingScore = not self.scores[7] or self.newScore > self.scores[7].score

	Timer.after(.2, function() self:createUI() end)
end

function HighScore:update(dt)

end

function HighScore:draw()

end

function HighScore:leave()

end

function HighScore:sortScores()
	self.scores = Lume.sort(self.scores, function(s1, s2) return s1.score > s2.score end)
end

function HighScore:loadScores()
	local scoresString = love.filesystem.read('scores.json')
	if scoresString then
		self.scores = Json.decode(scoresString)
	else
		print('Alert: did not find scores. Writing empty score file.')
		self.scores = {}
		self:saveScores()
	end
end

function HighScore:saveScores()
	local scoresString = Json.encode(self.scores)
	love.filesystem.write('scores.json', scoresString)
end

function HighScore:addScore(name, score)
	table.insert(self.scores, { name = name, score = score })
	self:sortScores()
	self:saveScores()
end

function HighScore:createUI()
	local layerName = 'hs_main'
	if UI:layerExists(layerName) then
		UI:removeLayer(layerName)
	end
	local decorator = THEMES.basic.decorator

	-- container
	local maxCol = UI:getMaxCol()
	local cw, ch = 24, 30
	local cCol = (maxCol / 2) - (cw / 2) + 1
	local c_main = UI:newContainer(layerName, cw, ch, 5, cCol, decorator, nil, 'mainContainer')
	-- local c_main = Luis.createElement(layerName, 'FlexContainer', cw, ch, 8, cCol, nil, nil, 'mainContainer')

	-- title
	local lw, lh = cw - 2, 3
	local lCol = (cw / 2) - (lw / 2) + 1
	local customTheme = {
		color = { 1, 1, 1, 1 },
		font = FONTS.robotic_l,
		align = 'center',
	}
	local l_title = UI:newLabel(layerName, 'HIGH SCORES', lw, lh, ALIGNMENTS.center, customTheme)
	c_main:addChild(l_title, 2, lCol)

	local row = 6

	-- new score
	if self.isAddingScore then
		local addNewScore = function(newName)
			newName = string.sub(newName, 1, 8)
			self:addScore(newName, self.newScore)
			self.isAddingScore = false
			self:createUI()
		end
		if love.joystick.getJoystickCount() > 0 then
			local newScore_pi = UI:newPadInput(layerName, 12, 3, addNewScore)
			c_main:addChild(newScore_pi, row, 5)
			UI:setCurrentFocus(newScore_pi)
		else
			
			local i_name = UI:newTextInput(layerName, 'username', 12, 2, addNewScore)
			c_main:addChild(i_name, row + .5, 5)
		end
		local l_newScore = UI:newLabel(layerName, self.newScore, 3, lh, ALIGNMENTS.left)
		c_main:addChild(l_newScore, row, 17)
		row = row + 3
	elseif not self.isViewMode then
		local labelTheme = {
			color = PALETTE.orange_1,
			font = FONTS.robotic,
			align = ALIGNMENTS.center,
		}
		local l_name = UI:newLabel(layerName, 'YOUR SCORE: ' .. self.newScore, 16, lh, ALIGNMENTS.center, labelTheme)
		c_main:addChild(l_name, row, 5)
		row = row + 3
	end

	-- scores
	for i = 1, 7, 1 do
		local nameLabel, pointsLabel = '--------', ' : 0'
		local score = self.scores[i]
		if score then
			nameLabel = score.name
			pointsLabel = ' : ' .. score.score
		end

		lw, lh = 7, 2
		local l_name = UI:newLabel(layerName, nameLabel, lw, lh, ALIGNMENTS.right, nil)
		c_main:addChild(l_name, row, 6)
		local l_points = UI:newLabel(layerName, pointsLabel, lw, lh, ALIGNMENTS.left, nil)
		c_main:addChild(l_points, row, 13)
		row = row + 2
	end

	-- buttons
	if not self.isAddingScore then
		row = row + 2
		local bw, bh = 8, 2
		local bCol = (cw / 2) - (bw / 2) + 1
		local b_restart = UI:newButton(layerName, 'RESTART', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.game, self.isEndless) end)
		c_main:addChild(b_restart, row, bCol)
		row = row + 3
		local b_quit = UI:newButton(layerName, 'QUIT', bw, bh, decorator, nil, function() GameState.switch(GAME_SCENES.title) end)
		c_main:addChild(b_quit, row, bCol)
	end

	UI:animateContainer(c_main, .2)
end

return HighScore
