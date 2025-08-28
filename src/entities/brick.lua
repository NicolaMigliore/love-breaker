local Brick = Object:extend()

function Brick:new(x, y, w, h)
	self.pos = Vector(x, y)
	self.vel = Vector(0, 0)
	self.w = w
	self.h = h
	self.collision = false
	self.breakTimer = .1
end

function Brick:update(dt)
	if self.collision then
		self.breakTimer = self.breakTimer - dt
	end
end

function Brick:draw()
	love.graphics.setColor(1, 1, 1)
	if self.collision then love.graphics.setColor(.6, .2, .2) end
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return Brick
