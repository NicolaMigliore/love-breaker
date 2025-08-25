local GameOver = {
    score = 0,
    buttons = {},
}

function GameOver:enter(previous)
    self.score = previous.score
end

function GameOver:update(dt)
    if KEY_DOWN.r then GameState.switch(GAME_SCENES.game) end
end

function GameOver:draw()
    Push:start()
    love.graphics.setColor(1,1,1)
    Utils.printLabel('SCORE: '..self.score,FIXED_WIDTH/2,128,ALIGNMENTS.center)
    Utils.printLabel('PRESS "R" TO RESTART',FIXED_WIDTH/2,200,ALIGNMENTS.center)
    Push:finish()
end

return GameOver