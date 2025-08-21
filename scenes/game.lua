local Ball = require 'entities.ball'
local Paddle = require 'entities.paddle'
local Game = {
    balls = {},
    paddle = nil,
}

function Game:enter()
    table.insert(self.balls, Ball(64,128,4))
    self.paddle = Paddle(128,230)
end

function Game:update(dt)
    -- update balls
    for i, ball in ipairs(self.balls) do
        ball:update(dt, self.paddle)
    end
    self.paddle:update(dt)
end

function Game:draw()
    love.graphics.setColor(.12,.14,.25)
    love.graphics.rectangle('fill',0,0,256,256)

    love.graphics.setColor(1,1,1,1)

    -- draw balls
    for i, ball in ipairs(self.balls) do
        ball:draw()
    end

    self.paddle:draw()
end

-- function Game:keyreleased(key)
--     if key == 'left' then
--         self.paddle:move
--     elseif key == 'right' then
--         Buttons.selectNext()
--     elseif
--         Buttons.active:onClick()
--     end
-- end


return Game