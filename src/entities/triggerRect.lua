local TriggerRect = Object:extend()

function TriggerRect:new(x, y, w, h, fn)
	self.pos = Vector(x, y)
	self.w = w
	self.h = h
	self.fn = fn
end

function TriggerRect:update(dt, balls)
	for i, ball in ipairs(balls) do
		if Utils.collisionCircRect(ball.pos.x, ball.pos.y, ball.rad, self.pos.x, self.pos.y, self.w, self.h) then
			self.fn(ball)
		end
	end
end

function TriggerRect:draw()
	if DEBUG then
		love.graphics.setColor(1, 1, 1, .75)
		love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return TriggerRect
