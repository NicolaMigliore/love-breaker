local TriggerRect = Object:extend()

function TriggerRect:new(x, y, w, h, ballFn, dropFn)
	self.pos = Vector(x, y)
	self.w = w
	self.h = h
	self.ballFn = ballFn
	self.dropFn = dropFn
end

function TriggerRect:update(dt, balls, drops)
	-- run collision on balls
	for i, ball in ipairs(balls) do
		if Utils.collisionCircRect(ball.pos.x, ball.pos.y, ball.rad, self.pos.x, self.pos.y, self.w, self.h) then
			self.ballFn(ball, i)
		end
	end
	-- run collision on drops
	for i, drop in ipairs(drops) do
		if Utils.CollisionRectRect(self.pos.x, self.pos.y, self.w, self.h, drop.pos.x, drop.pos.y, drop.w, drop.h) then
			self.dropFn(drop, i)
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
