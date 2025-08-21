local Ball = require 'entities.ball'
local Paddle = require 'entities.paddle'
local Brick = require 'entities.brick'
local Game = {
    balls = {},
    paddle = nil,
    bricks = {},
}

function Game:enter()
    table.insert(self.balls, Ball(64,128,4))
    self.paddle = Paddle(128,230)
    self.bricks = self:generateBricks()
end

function Game:update(dt)
    -- update balls
    for i, ball in ipairs(self.balls) do
        ball:update(dt, self.paddle, self.bricks)
    end
    
    self.paddle:update(dt)

    -- update bricks
    for i, brick in ipairs(self.bricks) do
        if brick.collision then
            table.remove(self.bricks,i)
        else
            brick:update(dt)
        end
    end
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

    -- draw bricks
    for i, brick in ipairs(self.bricks) do
        brick:draw()
    end
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

function Game:generateBricks()
    local bricks = {}
    for row=1,4 do
        local y = 10+row*12
        for i=0,9 do
            local x = 10+i*24
            local b = Brick(x,y)
            table.insert(bricks,b)
        end
    end
    return bricks
end

return Game