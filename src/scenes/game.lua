local Ball = require 'entities.ball'
local Paddle = require 'entities.paddle'
local Brick = require 'entities.brick'
local TriggerRect = require 'entities.triggerRect'

local Game = {
	balls = {},
	paddle = nil,
	bricks = {},
	gameOverTrigger = nil,
	isServing = true,
	score = 0,
	lives = 3,
	style = 'basic',
}

function Game:enter()
	love.graphics.setFont(FONTS.robotic)

	self.score = 0
	self.lives = 3
	self.isServing = true

	-- setup entities
	local pw = 70
	self.paddle = Paddle(FIXED_WIDTH / 2 - pw / 2, FIXED_HEIGHT - 30, pw, 7)

	self.balls = {}
	local rad = 4
	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - rad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, rad))

	self.bricks = self:generateBricks()

	self.gameOverTrigger = TriggerRect(0, self.paddle.pos.y + self.paddle.h, FIXED_WIDTH, 100, function(ball)
		local index = Lume.find(self.balls, ball)
		if index then table.remove(self.balls, index) end
		self.score = self.score - 20
		if #self.balls == 0 then
			self.lives = self.lives - 1

			if self.lives <= 0 then
				GameState.switch(GAME_SCENES.gameOver)
			else
				self:serveBall()
			end
		end
	end)
end

function Game:update(dt)
	-- update balls
	for i, ball in ipairs(self.balls) do
		ball:update(dt, self.paddle, self.bricks)
	end

	if self.isServing then
		local nextBall = self.balls[#self.balls]
		nextBall.pos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - nextBall.rad - 1)
		nextBall.vel.x = math.abs(nextBall.vel.x) * Utils.sign(self.paddle.lastDir.x)

		if INPUT:down('action1') then
			self.isServing = false
			nextBall.speed = 200
		end
	end

	self.paddle:update(dt)

	-- update bricks
	for i, brick in ipairs(self.bricks) do
		if brick.collision and brick.breakTimer and brick.breakTimer <= 0 then
			table.remove(self.bricks, i)
			self.score = self.score + 10
		else
			brick:update(dt)
		end
	end

	-- update trigger
	self.gameOverTrigger:update(dt, self.balls)
	if #self.bricks == 0 then
		self.score = self.score + self.lives * 50
		GameState.switch(GAME_SCENES.gameOver)
	end
end

function Game:draw()
	Push:start()

	love.graphics.setColor(.12, .14, .25)
	love.graphics.rectangle('fill', 0, 0, FIXED_WIDTH, FIXED_HEIGHT)

	love.graphics.setColor(1, 1, 1, 1)

	-- draw balls
	for i, ball in ipairs(self.balls) do
		ball:draw(self.style)
	end

	if self.isServing then
		local nextBall = self.balls[#self.balls]
		local p1 = nextBall.pos
		local p2 = nextBall.pos + (nextBall.vel * 15)
		love.graphics.line(p1.x, p1.y, p2.x, p2.y)
	end

	self.paddle:draw(self.style)

	-- draw bricks
	for i, brick in ipairs(self.bricks) do
		brick:draw(self.style)
	end

	self.gameOverTrigger:draw()

	-- UI
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', 0, FIXED_HEIGHT - 20, FIXED_WIDTH, 20)
	love.graphics.setColor(1, 1, 1)

	Utils.printLabel('LIVES: ' .. self.lives .. '   SCORE: ' .. self.score, FIXED_WIDTH - 5, FIXED_HEIGHT - 10, ALIGNMENTS.right)

	Utils.printLabel(love.timer.getFPS() .. 'fps', 10, 10, ALIGNMENTS.left)

	Push:finish()
end

function Game:serveBall()
	self.isServing = true

	local rad = 4
	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - rad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, rad))
end

function Game:generateBricks()
	local bricks = {}
	for row = 1, 6 do
		local h = 12
		local y = 10 + row * (h + 4)
		for i = 0, 6 do
			local w = 40
			local x = 26 + i * (w + 4)
			local b = Brick(x, y, w, h)
			table.insert(bricks, b)
		end
	end
	return bricks
end

return Game
