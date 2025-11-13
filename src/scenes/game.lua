local Ball = require 'entities.ball'
local Paddle = require 'entities.paddle'
local Brick, BrickTypes = unpack(require 'entities.brick')
local Drop, DropTypes, DropTypeColors = unpack(require 'entities.drop')
local TriggerRect = require 'entities.triggerRect'
local Particles = require 'particles'
CardManager = require('entities.cardManager')

local levels = require('assets.level-sets.base')

local Game = {
	balls = {},
	combo = 0,
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
	isEndless = false,
	layers = {},
	timers = {},
	sfx = {},
	cardManager = CardManager(),
}

function Game:enter(previous, endless)
	PARTICLES = Particles()
	DROPS = {}

	self.score = 0
	self.lives = 3
	self.combo = 0
	
	self.isEndless = endless
	self.curLevel = 1
	self:setLevel(self.curLevel)

	-- setup UI
	self:createUI()

	-- load sound FXs
	self:loadSFX()

	self.canvas = love.graphics.newCanvas(GAME_SETTINGS.fixedWidth, GAME_SETTINGS.fixedheight)

	self:setSuddenDeathTimer()
end

-- MARK: Update
function Game:update(dt)
	if INPUT:released('start') then GameState.push(GAME_SCENES.pause) return end

	-- update balls
	for i, ball in ipairs(self.balls) do
		ball.rad = self.suddenDeath and 20 or self.ballRad
		ball.speed = self.ballSpeed
		local hasCollision, collisionPoint, collisionResponse, hitBrick, hitPaddle = ball:update(dt, self.paddle, self.bricks)
		if hasCollision then
			if hitBrick then self.combo = self.combo + 1 end
			if hitPaddle then self.combo = 0 end
			-- particles
			local r1, r2 = 0, -math.pi
			if math.abs(collisionResponse.x) > math.abs(collisionResponse.y) then
				r1 = r1 + math.pi / 2
				r2 = r2 + math.pi / 2
			end
			PARTICLES:addPuff(collisionPoint.x, collisionPoint.y, r1)
			PARTICLES:addPuff(collisionPoint.x, collisionPoint.y, r2)

			-- sounds
			local comboSound = 'bounce_'..math.min(math.floor(self.combo / 5), 3)
			self.sfx[comboSound]:stop()
			self.sfx[comboSound]:play()

			local shakeStr = math.min(math.floor(self.combo / 5), 4) * 3
			Shack:setShake(shakeStr)
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

	self.paddle.speed = self.suddenDeath and 800 or self.paddleSpeed
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
		if self.curLevel <= #levels or self.isEndless then
			self:setLevel(self.curLevel)
		else
			GameState.switch(GAME_SCENES.highScore)
		end
	end

	-- update drops
	for i, drop in ipairs(DROPS) do
		drop:update(dt)

		-- check paddle collision
		local paddleCollide = Utils.CollisionRectRect(drop.pos.x, drop.pos.y, drop.w, drop.h, self.paddle.pos.x, self.paddle.pos.y, self.paddle.w, self.paddle.h)
		if paddleCollide then
			local msg = nil
			if drop.type == DropTypes.life then
				self.lives = self.lives + 1
				msg = '1 UP'
			elseif drop.type == DropTypes.bigBall then
				if self.timers.bigBall then Timer.cancel(self.timers.bigBall) self.timers.bigBall = nil end
				self.ballRad = 20
				self.timers.bigBall = Timer.after(10, function() self.ballRad = 10 end)
				msg = 'BIG BALL'
			elseif drop.type == DropTypes.speedPaddle then
				if self.timers.paddleSpeed then Timer.cancel(self.timers.paddleSpeed) self.timers.paddleSpeed = nil end
				self.paddleSpeed = 800
				Timer.after(10, function() self.paddleSpeed = 600 end)
				msg = 'GOTTA GO FAST'
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
				msg = 'MULTI BALLS'
			end

			-- spawn particles
			local typeColor = DropTypeColors[drop.type]
			local colors = { typeColor[1], typeColor[2], typeColor[3], 1, 0.331298828125, 0.33332443237305, 0.4609375, 1, 0.72265625, 0.72265625, 0.72265625, 0.3984375}
			local px = self.paddle.pos.x + self.paddle.w / 2 + love.math.random(10) - 5
			local py = drop.pos.y + drop.h + love.math.random(8) - 4
			PARTICLES:addBigPuff(px, py, nil, colors)

			-- spawn card
			self.cardManager:addCard(msg, 1, typeColor)

			-- play sound
			self.sfx.powerup:stop()
			self.sfx.powerup:play()

			-- remove drop
			table.remove(DROPS, i)
		end
	end

	-- update trigger
	self.gameOverTrigger:update(dt, self.balls, self.bricks, DROPS)
	if #self.bricks == 0 then
		self.score = self.score + self.lives * 50
		GameState.switch(GAME_SCENES.highScore)
	end

	PARTICLES:update(dt)

	-- update hud
	if self.layers.hud then
		local hudContainer = self.layers.hud.containers.c_hud
		local labels = hudContainer.children
		local time = (self.suddenDeathTimer.time > 0.1) and Utils.secondsToTimeString(120 - self.suddenDeathTimer.time) or '00:00'
		labels[1]:setText('TIME '..time)
		labels[2]:setText('LIVES '..self.lives)
		labels[3]:setText('SCORE '..self.score)
		labels[4]:setText('COMBO '..self.combo)
	end
end

-- MARK: Draw
function Game:draw()
	local canvas = CANVAS.basic
	if GAME_SETTINGS.enableShaders then
		canvas = CANVAS.effects
	end
	love.graphics.setCanvas(canvas)

	-- draw frame
	love.graphics.setColor(PALETTE.orange_2)
	love.graphics.rectangle('line', 10, 10, GAME_SETTINGS.fixedWidth - 20, GAME_SETTINGS.fixedHeight - 60, 5)

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
		drop:draw(self.style)
	end

	self.gameOverTrigger:draw()
	PARTICLES:draw()

	self.cardManager:draw()

	-- reset canvas
	love.graphics.setCanvas()
end

function Game:leave()
	UI:removeLayer('hud')
	print('leaving game')
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
	self.paddle = Paddle(GAME_SETTINGS.fixedWidth / 2 - pw / 2, GAME_SETTINGS.fixedHeight - 80 - ph / 2, pw, ph)

	self.balls = {}
	local nextPos = Vector(self.paddle.pos.x + self.paddle.w / 2, self.paddle.pos.y - self.ballRad - 1)
	table.insert(self.balls, Ball(nextPos.x, nextPos.y, self.ballRad))


	self.gameOverTrigger = TriggerRect(0, self.paddle.pos.y + self.paddle.h + self.ballRad * 2, GAME_SETTINGS.fixedWidth, 100,
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
				self.combo = 0
				if self.lives <= 0 then
					GameState.switch(GAME_SCENES.highScore)
				else
					self:serveBall()
				end

				Shack:setShake(15)
				Shack:setRotation(.1)
				self.sfx.fail:play()
			end
		end,
		function(brick, index)
			GameState.switch(GAME_SCENES.highScore)
		end,
		function(drop, index)
			table.remove(DROPS, index)
		end
	)

	-- setup bricks
	if self.isEndless then
		self.bricks = self:generateRandomBricks()
	else
		self.bricks = self:generateBricks(levels[lvl])
	end
	self:setSuddenDeathTimer()
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

function Game:generateRandomBricks()
	local rows = {
		'bbbbbbb',
		'bbxxxbb',
		'bbbdbbb',
		'dbbdbbd',
		'hhhhhhh',
		'hbhbhbh',
		'xxxxxxx',
		'bbxxxbb',
		'bdxxxdb',
		'hbxxxhb',
		'xhbbbhx',
		'xxeeexx',
		'eeeeeee',
		'heheheh',
		'xheeehx',
		'hdhhhdh',
		'xxbbbxx',
		'bdbdbdb',
	}
	local noLines = 3 + math.floor(love.math.random(4))
	local level = {}
	for i = 1, noLines do
		table.insert(level, Utils.rndTablePick(rows))
	end
	return self:generateBricks(level)
end

function Game:setSuddenDeathTimer()
	-- clear step timer
	if self.stepTimer then
		Timer.clear(self.stepTimer)
		self.stepTimer = nil
	end
	self.suddenDeath = false
	if self.suddenDeathTimer then
		Timer.clear(self.suddenDeathTimer)
	end
	self.suddenDeathTimer = Timer.after(120, function()
		self.suddenDeath = true
		self.cardManager:addCard('SUDDEN DEATH', 1, PALETTE.red_1, true)
		self.stepTimer = Timer.every(1, function()
			if GameState.current() == GAME_SCENES.game then
				for i, brick in ipairs(self.bricks) do
					brick.pos.y = brick.pos.y + 10
				end
			end
		end, 100)
	end)
end

function Game:loadSFX()
	self.sfx = {
		bounce_0 = AUDIO.sfx.bounce_0,
		bounce_1 = AUDIO.sfx.bounce_1,
		bounce_2 = AUDIO.sfx.bounce_2,
		bounce_3 = AUDIO.sfx.bounce_3,
		fail = AUDIO.sfx.fail,
		powerup = AUDIO.sfx.powerup,
	}
end

function Game:leave()
	-- clear step timer
	if self.stepTimer then
		Timer.clear(self.stepTimer)
		self.stepTimer = nil
	end
end

-- MARK: Setup UI
function Game:createUI()
	if UI:layerExists('hud') then
		UI:removeLayer('hud')
	end
	local hudLayer = UI:newLayer('hud')
	local maxCol = UI:getMaxCol()
	local maxRow = UI:getMaxRow()

	local containerTheme = Lume.clone(UI:getTheme().container)
	containerTheme.backgroundColor = PALETTE.orange_3
	containerTheme.borderColor = PALETTE.orange_3
	local c_hud = UI:newContainer('hud', maxCol, 2, maxRow - 1, 1, nil, containerTheme, 'hudContainer')

	local lw = maxCol / 4
	local labelTheme = Lume.clone(UI:getTheme().text)
	labelTheme.color = PALETTE.black
	-- local l_combo = UI:newLabel('hud', 'TIME '..self.suddenDeathTimer.time, lw, 2, ALIGNMENTS.LEFT, labelTheme)
	local l_combo = UI:newLabel('hud', 'TIME ', lw, 2, ALIGNMENTS.LEFT, labelTheme)
	c_hud:addChild(l_combo, 1, 2)
	local l_lives = UI:newLabel('hud', 'LIVES '..self.lives, lw, 2, ALIGNMENTS.LEFT, labelTheme)
	c_hud:addChild(l_lives, 1, 2 + lw)
	local l_score = UI:newLabel('hud', 'SCORE '..self.score, lw, 2, ALIGNMENTS.LEFT, labelTheme)
	c_hud:addChild(l_score, 1, 2 + lw * 2)
	local l_combo = UI:newLabel('hud', 'COMBO '..self.combo, lw, 2, ALIGNMENTS.LEFT, labelTheme)
	c_hud:addChild(l_combo, 1, 2 + lw * 3)

	self.layers.hud = {
		layerName = 'hud',
		layer = hudLayer,
		containers = {
			c_hud = c_hud
		}
	}
end


return Game
