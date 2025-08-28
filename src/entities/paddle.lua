local Paddle = Object:extend()

function Paddle:new(x, y, w, h)
	self.pos = Vector(x, y)
	self.vel = Vector(0, 0)
	self.lastDir = Vector(1, 0)
	self.w = w
	self.h = h
	self.speed = 6
end

function Paddle:update(dt)
	if self.vel ~= Vector(0, 0) then self.lastDir = self.vel:normalized() end

	self.vel.x = 0
	if INPUT:down('left') then self.vel.x = -1 end
	if INPUT:down('right') then self.vel.x = 1 end

	local normVelocity = self.vel:normalized()
	self.vel = normVelocity * self.speed
	self.pos = self.pos + self.vel

	-- check bounds
	local maxX = FIXED_WIDTH
	if self.pos.x < 0 then self.pos.x = 0 end
	if self.pos.x + self.w > maxX then self.pos.x = maxX - self.w end
end

function Paddle:draw()
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return Paddle
