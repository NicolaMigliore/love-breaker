local Ball = require 'entities.ball'
local Paddle = require 'entities.paddle'
local Brick, BrickTypes = unpack(require 'entities.brick')
local Drop, DropTypes = unpack(require 'entities.drop')
local TriggerRect = require 'entities.triggerRect'
local Particles = require 'particles'

local levels = require('assets.level-sets.base')

local Game = {
	balls = {},
	ballRad = 10,
	ballSpeed = 400,
	paddle = nil,
	paddleSpeed = 600,
	bricks = {},
	gameOverTrigger = nil,
	isServing = true,
	score = 0,
	lives = 3,
	style = STYLES.neon,
	curLevel = 1,
}

function Game:enter()
	love.graphics.setFont(FONTS.robotic)
	PARTICLES = Particles()
	DROPS = {}

	self.score = 0
	self.lives = 3
	self.curLevel = 1
	-- self.ballRad = 15

	self:setLevel(self.curLevel)
end

-- MARK: Update
function Game:update(dt)
	if INPUT:released('start') then GameState.push(GAME_SCENES.pause) return end

	-- update balls
	for i, ball in ipairs(self.balls) do
		ball.rad = self.ballRad
		ball.speed = self.ballSpeed
		local hasCollision, collisionPoint, collisionResponse = ball:update(dt, self.paddle, self.bricks)
		if hasCollision then
			local r1, r2 = 0, -math.pi
			if math.abs(collisionResponse.x) > math.abs(collisionResponse.y) then
				r1 = r1 + math.pi / 2
				r2 = r2 + math.pi / 2
			end
			PARTICLES:addPuff(collisionPoint.x, collisionPoint.y, r1)
			PARTICLES:addPuff(collisionPoint.x, collisionPoint.y, r2)
		end
	end

	if self.isServing then
		local nextBall = self.balls[#self.balls]
		nextBall.pos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - nextBall.rad - 1)
		nextBall.vel.x = math.abs(nextBall.vel.x) * Utils.sign(self.paddle.lastDir.x)

		if INPUT:down('action1') then
			self.isServing = false
			nextBall.speed = self.ballSpeed
			nextBall.served = true
		end
	end

	self.paddle.speed = self.paddleSpeed
	self.paddle:update(dt)

	-- update bricks
	for i, brick in ipairs(self.bricks) do
		if brick.collision and brick.breakTimer <= 0 then
			local x, y = brick.pos.x + brick.w / 2, brick.pos.y + brick.h / 2
			PARTICLES:addShatter(x, y, -math.pi / 2)
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
	if #self.bricks == 0 then
		-- TODO: add transition
		self.curLevel = self.curLevel + 1
		if self.curLevel <= #levels then
			self:setLevel(self.curLevel)
		else
			GameState.switch(GAME_SCENES.gameOver)
		end
	end

	for i, drop in ipairs(DROPS) do
		drop:update(dt)

		-- check paddle collision
		local paddleCollide = Utils.CollisionRectRect(drop.pos.x, drop.pos.y, drop.w, drop.h, self.paddle.pos.x, self.paddle.pos.y, self.paddle.w, self.paddle.h)
		if paddleCollide then
			if drop.type == DropTypes.life then
				self.lives = self.lives + 1
			elseif drop.type == DropTypes.bigBall then
				self.ballRad = 10
				Timer.after(10, function() self.ballRad = 15 end)
			elseif drop.type == DropTypes.speedPaddle then
				self.paddleSpeed = 800
				Timer.after(10, function() self.paddleSpeed = 600 end)
			elseif drop.type == DropTypes.multiBall then
				local lastBall = self.balls[#self.balls]
				local signX, signY = Utils.sign(lastBall.vel.x), Utils.sign(lastBall.vel.y)
				local b1 = Ball(lastBall.pos.x + self.ballRad * 2 + 15, lastBall.pos.y, self.ballRad)
				b1.vel.x = math.abs(b1.vel.x) * signX
				b1.vel.y = math.abs(b1.vel.y) * signY
				b1.speed = self.ballSpeed
				b1.served = true
				table.insert(self.balls, b1)
				local b2 = Ball(lastBall.pos.x - self.ballRad * 2 - 15, lastBall.pos.y, self.ballRad)
				b2.vel.x = math.abs(b2.vel.x) * signX
				b2.vel.y = math.abs(b2.vel.y) * signY
				b2.speed = self.ballSpeed
				b2.served = true
				table.insert(self.balls, b2)
			end

			table.remove(DROPS, i)
		end
	end

	-- update trigger
	self.gameOverTrigger:update(dt, self.balls, DROPS)
	if #self.bricks == 0 then
		self.score = self.score + self.lives * 50
		GameState.switch(GAME_SCENES.gameOver)
	end

	PARTICLES:update(dt)
end

-- MARK: Draw
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

	for i, drop in ipairs(DROPS) do
		drop:draw()
	end

	self.gameOverTrigger:draw()
	PARTICLES:draw()

	-- UI
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', 0, FIXED_HEIGHT - 35, FIXED_WIDTH, 20 * SCALE)
	love.graphics.setColor(1, 1, 1)

	Utils.printLabel('LIVES: ' .. self.lives .. '   SCORE: ' .. self.score, FIXED_WIDTH - 5, FIXED_HEIGHT - 15,
		ALIGNMENTS.right)

	Utils.printLabel(love.timer.getFPS() .. 'fps', 10, 20, ALIGNMENTS.left)

	-- Push:finish()
end

function Game:serveBall()
	self.isServing = true

	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - self.ballRad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, self.ballRad))
end

-- MARK: Setup Level
--- setup the level
---@param lvl number level number
function Game:setLevel(lvl)
	PARTICLES = Particles()
	self.isServing = true

	-- setup entities
	local pw, ph = 140, 14
	self.paddle = Paddle(FIXED_WIDTH / 2 - pw / 2, FIXED_HEIGHT - 50 - ph / 2, pw, ph)

	self.balls = {}
	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - self.ballRad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, self.ballRad))


	self.gameOverTrigger = TriggerRect(0, self.paddle.pos.y + self.paddle.h + self.ballRad * 2, FIXED_WIDTH, 100,
		function(ball, index)
			if index then
				local particleIndex = Lume.find(PARTICLES.list, ball.trail)
				print(particleIndex)
				table.remove(PARTICLES.list, particleIndex)
				table.remove(self.balls, index)
			end
			self.score = self.score - 20
			if #self.balls == 0 then
				self.lives = self.lives - 1

				if self.lives <= 0 then
					GameState.switch(GAME_SCENES.gameOver)
				else
					self:serveBall()
				end
			end
		end,
		function(drop, index)
			table.remove(DROPS, index)
		end)

	self.bricks = self:generateBricks(levels[lvl])
end

--- generate the bricks for the provided level
---@param level table list of strings describing brick rows
---@return table bricks list of the bricks to add to the level
function Game:generateBricks(level)
	local bricks = {}

	for j, row in ipairs(level) do
		local h = 26
		local y = 55 + (j - 1) * (h + 14)
		for i = 1, #row do
			local b = string.sub(row, i, i)
			local choices = {
				b = 'base',
				h = 'hard',
				e = 'explosive',
				x = 'empty',
				d = 'drop'
			}
			local brickType = BrickTypes[choices[b]]
			if brickType then
				local w = 80
				local x = 43 + (i - 1) * (w + 14)
				local newBrick = Brick(x, y, w, h, brickType)
				table.insert(bricks, newBrick)
			end
		end
	end
	return bricks
end

return Game
