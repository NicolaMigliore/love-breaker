local Paddle = Object:extend()

function Paddle:new(x,y)
    self.pos = Vector(x,y)
    self.vel = Vector(0,0)
    self.w = 45
    self.h = 7
    self.speed = 6
end

function Paddle:update(dt)
    self.vel.x = 0
    if KEY_DOWN.left then self.vel.x = -1 end
    if KEY_DOWN.right then self.vel.x = 1 end

    local normVelocity = self.vel:normalized()
    self.vel = normVelocity * self.speed
    self.pos = self.pos + self.vel

    -- check bounds
    local maxX = love.graphics.getWidth()
    if self.pos.x < 0 then self.pos.x = 0 end
    if self.pos.x + self.w > maxX then self.pos.x = maxX - self.w end

end

function Paddle:draw()
    love.graphics.rectangle('fill',self.pos.x,self.pos.y,self.w,self.h)
    -- love.graphics.print('v:'..self.vel:__tostring()..' | s:'..Utils.round(self.vel:len(),2),10,10)
end

return Paddle