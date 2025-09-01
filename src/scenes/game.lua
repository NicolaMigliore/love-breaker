local Ball = require 'entities.ball'
local Paddle = require 'entities.paddle'
local Brick, BrickTypes = unpack(require 'entities.brick')
local TriggerRect = require 'entities.triggerRect'
local Particles = require 'particles'

local Game = {
	balls = {},
	paddle = nil,
	bricks = {},
	particles = nil,
	gameOverTrigger = nil,
	isServing = true,
	score = 0,
	lives = 3,
	style = STYLES.default,
}

PAUSE = false

function Game:enter()
	love.graphics.setFont(FONTS.robotic)

	self.score = 0
	self.lives = 3
	self.isServing = true

	-- setup entities
	local pw, ph = 140, 14
	self.paddle = Paddle(FIXED_WIDTH / 2 - pw / 2, FIXED_HEIGHT - 50 - ph / 2, pw, ph)

	self.balls = {}
	local rad = 15
	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - rad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, rad))

	self.bricks = self:generateBricks()

	self.gameOverTrigger = TriggerRect(0, self.paddle.pos.y + self.paddle.h + 5, FIXED_WIDTH, 100, function(ball)
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

	self.particles = Particles()
end

function Game:update(dt)
	if PAUSE then return end

	-- update balls
	for i, ball in ipairs(self.balls) do
		local hasCollision, collisionPoint, collisionResponse = ball:update(dt, self.paddle, self.bricks)
		if hasCollision then
			local r1, r2 = 0, -math.pi
			if math.abs(collisionResponse.x) > math.abs(collisionResponse.y) then
				r1 = r1 + math.pi/2
				r2 = r2 + math.pi/2
			end
			self.particles:addPuff(collisionPoint.x, collisionPoint.y, r1)
			self.particles:addPuff(collisionPoint.x, collisionPoint.y, r2)
		end
	end

	if self.isServing then
		local nextBall = self.balls[#self.balls]
		nextBall.pos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - nextBall.rad - 1)
		nextBall.vel.x = math.abs(nextBall.vel.x) * Utils.sign(self.paddle.lastDir.x)

		if INPUT:down('action1') then
			self.isServing = false
			nextBall.speed = 300
		end
	end

	self.paddle:update(dt)

	-- update bricks
	for i, brick in ipairs(self.bricks) do
		if brick.collision and brick.breakTimer <= 0 then
			local x, y = brick.pos.x + brick.w / 2, brick.pos.y + brick.h / 2
			self.particles:addShatter(x, y, -math.pi / 2)
			self.score = self.score + 10
			if brick.lives <= 0 then
				table.remove(self.bricks, i)
			else
				-- reset collision state for hard bricks
				brick.collision = false
			end
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

	self.particles:update(dt)
end

function Game:draw()
	-- Push:start()

	love.graphics.setColor(1, 1, 1, 1)

	if self.isServing then
		local nextBall = self.balls[#self.balls]
		local p1 = nextBall.pos
		local p2 = nextBall.pos + (nextBall.vel * 25)
		love.graphics.line(p1.x, p1.y, p2.x, p2.y)
	end

	-- draw balls
	for i, ball in ipairs(self.balls) do
		ball:draw(self.style)
	end

	self.paddle:draw(self.style)

	-- draw bricks
	for i, brick in ipairs(self.bricks) do
		brick:draw(self.style)
	end

	self.gameOverTrigger:draw()
	self.particles:draw()

	-- UI
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', 0, FIXED_HEIGHT - 35, FIXED_WIDTH, 20 * SCALE)
	love.graphics.setColor(1, 1, 1)

	Utils.printLabel('LIVES: ' .. self.lives .. '   SCORE: ' .. self.score, FIXED_WIDTH - 5, FIXED_HEIGHT - 15, ALIGNMENTS.right)

	Utils.printLabel(love.timer.getFPS() .. 'fps', 10, 20, ALIGNMENTS.left)

	-- Push:finish()
end

function Game:serveBall()
	self.isServing = true

	local rad = 15
	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - rad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, rad))
end

function Game:generateBricks()
	local bricks = {}
	local level = {
		'bxxxxxb',
		'bbbhbbb',
		'hhhhhhh',
		'eheeehe',
	}

	for j, row in ipairs(level) do
		local h = 40
		local y = 40 + (j - 1) * (h + 14)
		for i = 1, #row do
			local b = string.sub(row, i, i)
			local choices = {
				b = 'base',
				h = 'hard',
				e = 'explosive',
				x = 'empty',
			}
			local brickType = BrickTypes[choices[b]]
			if brickType then
				local w = 80
				local x = 38 + (i - 1) * (w + 14)
				local newBrick = Brick(x, y, w, h, brickType)
				table.insert(bricks, newBrick)
			end
		end
	end
	return bricks
end

return Game
