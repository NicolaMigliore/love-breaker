local Ball = Object:extend()

function Ball:new(x,y,r)
    self.pos = Vector(x,y)
    self.rad = r
    self.speed = 5
    local angle = math.pi/4
    self.vel = Vector.fromPolar(angle, self.speed) --Vector(1,1)
    self.collision = false
end

function Ball:update(dt,paddle)

    local normVelocity = self.vel:normalized()
    self.pos = self.pos + normVelocity * self.speed

    self.collision = false
    -- check bounds collision
    local maxX = love.graphics.getWidth()
    local maxY = love.graphics.getHeight()

    local invertX = (self.pos.x + self.rad > maxX) or (self.pos.x - self.rad < 0)
    if invertX then self.vel.x = -self.vel.x end
    local invertY = (self.pos.y + self.rad > maxY) or (self.pos.y - self.rad < 0)
    if invertY then self.vel.y = -self.vel.y end

    -- check paddle collisions
    local paddleCollision = Utils.collisionCircRect(self.pos.x, self.pos.y, self.rad, paddle.pos.x, paddle.pos.y, paddle.w, paddle.h)
    self.collision = self.collision or paddleCollision
    if paddleCollision then
        self.vel.y = -self.vel.y

        -- deflect horizontally
        local same_dir = Utils.sign(self.vel.x) == Utils.sign(paddle.vel.x)
        local hit_sides = self.pos.y > paddle.pos.y

        -- round angle values to avoid float rounding errors
        local cur_angle = Utils.round(math.atan2(self.vel.y, self.vel.x),4)
        local is30or150Deg = (Utils.round(-math.pi/6, 4) == cur_angle) or (Utils.round(-math.pi*5/6, 4) == cur_angle) -- 30°
        local is45or135Deg = (Utils.round(-math.pi/4, 4) == cur_angle) or (Utils.round(-math.pi*3/4, 4) == cur_angle) -- 45°
        local is60or120Deg = (Utils.round(-math.pi/3, 4) == cur_angle) or (Utils.round(-math.pi*2/3, 4) == cur_angle) -- 60°

        if hit_sides and (not same_dir or paddle.vel.x == 0)  then
            self.vel.x = -self.vel.x
            self.pos.y = paddle.pos.y - self.rad
        elseif paddle.vel.x ~= 0 then
            local dir = Utils.sign(self.vel.x)
            -- raise angle
            if not same_dir and not is60or120Deg then
                self.vel = self.vel:rotated(-dir * math.pi/12)
            end
            -- lower angle
            if same_dir and not is30or150Deg then
                self.vel = self.vel:rotated(dir * math.pi/12)
            end
        end
    end
end

function Ball:draw()
    love.graphics.setColor(1,1,1)

    if self.collision then love.graphics.setColor(.6,.2,.2) end

    love.graphics.circle('fill', self.pos.x, self.pos.y, self.rad)
    love.graphics.setColor(1,1,1)
end

return Ball