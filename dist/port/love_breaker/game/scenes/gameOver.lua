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
    love.graphics.setColor(1,1,1)
    Utils.printLabel('SCORE: '..self.score,128,128,ALIGNMENTS.center)
    Utils.printLabel('PRESS "R" TO RESTART',128,200,ALIGNMENTS.center)
end

return GameOver