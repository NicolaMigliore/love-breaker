local Brick = Object:extend()

function Brick:new(x,y,w,h)
    self.pos = Vector(x,y)
    self.vel = Vector(0,0)
    self.w = w
    self.h = h
    self.collision = false
end

function Brick:update(dt)

end

function Brick:draw()
    love.graphics.setColor(1,1,1)
    if self.collision then love.graphics.setColor(.6,.2,.2) end
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return Brick