local GameOver = {
    score = 0,
	isEndless = false,
    buttons = {},
}

function GameOver:enter(previous)
    self.score = previous.score
	self.isEndless = previous.isEndless
end

function GameOver:update(dt)
    if INPUT:down('reload') then GameState.switch(GAME_SCENES.game, self.isEndless) end
end

function GameOver:draw()
    Push:start()

    love.graphics.setFont(FONTS.robotic_l)
    love.graphics.setColor(1,1,1,1)
    Utils.printLabel('SCORE: '..self.score,FIXED_WIDTH/2,128,ALIGNMENTS.center)
    
    love.graphics.setFont(FONTS.robotic)
    local alfa = (math.sin(love.timer.getTime()*4) + 1) * 0.25 + 0.5
    love.graphics.setColor(1,1,1,alfa)
    Utils.printLabel('PRESS "R" TO RESTART',FIXED_WIDTH/2,200,ALIGNMENTS.center)
    Push:finish()
end

return GameOver