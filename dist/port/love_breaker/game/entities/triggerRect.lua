local TriggerRect = Object:extend()

function TriggerRect:new(x, y, w, h, ballFn, brickFn, dropFn)
	self.pos = Vector(x, y)
	self.w = w
	self.h = h
	self.ballFn = ballFn
	self.brickFn = brickFn
	self.dropFn = dropFn
end

function TriggerRect:update(dt, balls, bricks, drops)
	-- run collision on balls
	for i, ball in ipairs(balls) do
		if Utils.collisionCircRect(ball.pos.x, ball.pos.y, ball.rad, self.pos.x, self.pos.y, self.w, self.h) then
			self.ballFn(ball, i)
		end
	end
	-- run collision on bricks
	for i, brick in ipairs(bricks) do
		if Utils.CollisionRectRect(self.pos.x, self.pos.y, self.w, self.h, brick.pos.x, brick.pos.y, brick.w, brick.h) then
			self.brickFn(brick, i)
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
	if GAME_SETTINGS.debugMode then
		love.graphics.setColor(1, 1, 1, .75)
		love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return TriggerRect
