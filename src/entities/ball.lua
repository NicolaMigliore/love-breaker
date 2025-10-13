local Ball = Object:extend()

function Ball:new(x, y, r)
	self.pos = Vector(x, y)
	self.rad = r
	self.speed = 0
	local angle = -math.pi / 4
	self.vel = Vector.fromPolar(angle, 1) --Vector(1,1)
	self.collisionTimer = 0
	self.collision = false
	self.collisionX = 0
	self.collisionY = 0
	self.textures = love.graphics.newImage('assets/textures/ball.png')
	self.quads = self:getQuads()
	self.served = false

	-- -- TODO: implement advanced trails (https://love2d.org/forums/viewtopic.php?p=247592#p247592)
	self.trail = nil
	-- self.trail = {}
	-- self.trailMax = 128
end

-- MARk: update
---comment
---@param dt any delta time
---@param paddle any reference to the game paddle
---@param bricks any reference to the list of bricks
---@return boolean hasCollision if the ball had any collisions
---@return Vector position current position of the ball
---@return Vector collisionResponse the normalized response vector for the collision or Vector(0,0) if no collision happened
---@return boolean hitBrick if the ball hit a brick
---@return boolean hitPaddle if the ball hit the paddle
function Ball:update(dt, paddle, bricks)
	local normVelocity = self.vel:normalized()

	-- update trail particleSystem
	if self.trail == nil and self.served then
		self.trail = PARTICLES:addTrail(self.pos.x, self.pos.y)
	elseif self.trail then
		local trailPos = self.pos - normVelocity * 10
		self.trail:setPosition(trailPos.x, trailPos.y)
		local cur_angle = Utils.round(math.atan2(self.vel.y, self.vel.x), 4)
		self.trail:setDirection(cur_angle - math.pi)
	end

	self.pos = self.pos + normVelocity * self.speed * dt
	if self.collisionX > 0 then self.collisionX = self.collisionX - dt end
	if self.collisionY > 0 then self.collisionY = self.collisionY - dt end
	self.collision = false
	
	local collisionResponse = Vector(0, 0)
	-- check bounds collision
	collisionResponse = collisionResponse + self:boundsCollision()

	-- check paddle collisions
	local paddleResponse, hitPaddle = self:paddleCollision(paddle)
	collisionResponse = collisionResponse + paddleResponse

	-- check bricks collision
	local brickResponse, hitBrick = self:brickCollision(bricks)
	collisionResponse = collisionResponse + brickResponse

	return self.collision, self.pos, collisionResponse, hitBrick, hitPaddle
end

-- MARK: draw
function Ball:draw(style)
	love.graphics.setColor(1, 1, 1)

	if DEBUG then love.graphics.circle('line', self.pos.x, self.pos.y, self.rad) end

	-- -- draw particles
	-- for i, tp in ipairs(self.trail) do
	--     love.graphics.circle('fill', tp.x, tp.y, (self.rad-2) *(i/self.trailMax))
	-- end

	if style == STYLES.basic then
		love.graphics.rectangle('fill', (self.pos.x - self.rad), (self.pos.y - self.rad), (self.rad * 2), (self.rad * 2))
	elseif style == STYLES.textured or style == STYLES.neon then
		if self.collisionY > 0 or self.collisionX > 0 then love.graphics.setColor(.6, .6, .6) end
		-- if self.collisionY > 0 or self.collisionX > 0 then love.graphics.setColor(1,1,1) end
		local quadSize, quadIndex = 12, 1
		if self.collisionY > 0 then quadIndex = 2 end
		if self.collisionX > 0 then quadIndex = 3 end
		local quad = self.quads[style][quadIndex]
		local scale = (self.rad * 2) / quadSize
		love.graphics.draw(self.textures, quad, (self.pos.x - quadSize * scale / 2), (self.pos.y - quadSize * scale / 2), 0, scale, scale)
	else
		-- default draw
		if self.collision then love.graphics.setColor(.6, .2, .2) end
		love.graphics.circle('fill', self.pos.x, self.pos.y, self.rad)
	end

	-- love.graphics.setColor(1, 0, 0)
	-- love.graphics.circle('fill', self.pos.x, self.pos.y, 5)
	
	love.graphics.setColor(1, 1, 1)
end

--- Run collision checks with game bounds
---@return Vector collisionResponse the normalized response vector for the collision or Vector(0,0) if no collision happened
function Ball:boundsCollision()
	local minX, maxX = 10, FIXED_WIDTH - 10
	local minY, maxY = 10, FIXED_HEIGHT
	local responseVector = Vector(0,0)

	local hitRight, hitLeft = (self.pos.x + self.rad > maxX), (self.pos.x - self.rad < minX)
	local invertX = hitRight or hitLeft
	if hitRight then responseVector = Vector(-1, 0) end
	if hitLeft then responseVector = Vector(1, 0) end
	if invertX then
		self.vel.x = -self.vel.x
		self.pos.x = Utils.mid(minX + self.rad, self.pos.x, maxX - self.rad)
		self.collisionX = .1
		self.collision = true
		return responseVector
	end

	local hitTop, hitBottom = (self.pos.y - self.rad < minY), (self.pos.y + self.rad > maxY)
	local invertY = hitTop or hitBottom
	if hitTop then responseVector = Vector(0, 1) end
	if hitBottom then responseVector = Vector(0, -1) end
	if invertY then
		self.vel.y = -self.vel.y
		self.pos.y = Utils.mid(minY + self.rad, self.pos.y, maxY - self.rad)
		self.collisionY = .1
		self.collision = true
		return responseVector
	end
	return responseVector
end

--- Run collision checks with the paddle and deflect the ball if necessary.
---@param paddle Paddle The paddle to check
---@return Vector collisionResponse the normalized response vector for the collision or Vector(0,0) if no collision happened
---@return boolean hasCollision if the ball has collision with the paddle
function Ball:paddleCollision(paddle)
	local paddleCollision, responseVector = Utils.collisionCircRect(
		self.pos.x,
		self.pos.y,
		self.rad,
		paddle.pos.x,
		paddle.pos.y,
		paddle.w,
		paddle.h
	)
	self.collision = self.collision or paddleCollision
	if paddleCollision and responseVector then
		-- deflect vertically
		if responseVector.y ~= 0 then
			self.vel.y = -self.vel.y
			self.pos.y = paddle.pos.y - self.rad
			self.collisionY = .1
		end

		-- deflect horizontally
		local same_dir = Utils.sign(self.vel.x) == Utils.sign(paddle.vel.x)
		local hit_sides = responseVector.x ~= 0

		-- round angle values to avoid float rounding errors
		local cur_angle = Utils.round(math.atan2(self.vel.y, self.vel.x), 4)
		local is30or150Deg = (Utils.round(-math.pi / 6, 4) == cur_angle) or (Utils.round(-math.pi * 5 / 6, 4) == cur_angle)                                                               -- 30°
		local is60or120Deg = (Utils.round(-math.pi / 3, 4) == cur_angle) or (Utils.round(-math.pi * 2 / 3, 4) == cur_angle)                                                               -- 60°

		if hit_sides and (not same_dir or paddle.vel.x == 0) then
			self.vel.x = math.abs(self.vel.x) * Utils.sign(responseVector.x)
			self.collisionX = .1
		elseif paddle.vel.x ~= 0 then
			local dir = Utils.sign(self.vel.x)
			-- raise angle
			if not same_dir and not is60or120Deg then
				self.vel = self.vel:rotated(-dir * math.pi / 12)
			end
			-- lower angle
			if same_dir and not is30or150Deg then
				self.vel = self.vel:rotated(dir * math.pi / 12)
			end
		end
		return responseVector, true
	end
	return Vector(0, 0), false
end

--- Run collision checks with the bricks and deflect the ball if necessary.
---@param bricks Table<Brick> List of bricks to check
---@return Vector collisionResponse the normalized response vector for the collision or Vector(0,0) if no collision happened
---@return boolean hasCollision if the ball has collision with a brick
function Ball:brickCollision(bricks)
	for i, brick in ipairs(bricks) do
		if not brick.collision then
			local brickCollision, responseVector = Utils.collisionCircRect(
				self.pos.x,
				self.pos.y,
				self.rad,
				brick.pos.x,
				brick.pos.y,
				brick.w,
				brick.h
			)
			self.collision = self.collision or brickCollision

			if brickCollision and responseVector then
				if responseVector.y < 0 then
					self.pos.y = brick.pos.y - self.rad
					self.vel.y = math.abs(self.vel.y) * -1
					self.collisionY = .1
				elseif responseVector.y > 0 then
					self.pos.y = brick.pos.y + brick.h + self.rad
					self.vel.y = math.abs(self.vel.y)
					self.collisionY = .1
				elseif responseVector.x < 0 then
					self.pos.x = brick.pos.x - self.rad
					self.vel.x = math.abs(self.vel.x) * -1
					self.collisionX = .1
				elseif responseVector.x > 0 then
					self.pos.x = brick.pos.x + brick.w + self.rad
					self.vel.x = math.abs(self.vel.x)
					self.collisionX = .1
				end
				brick:collide(-responseVector, bricks)

				return responseVector, true
			end
		end
	end
	return Vector(0, 0), false
end

function Ball:getQuads()
	return {
		textured = {
			love.graphics.newQuad(0, 0, 12, 12, self.textures:getWidth(), self.textures:getHeight()),
			love.graphics.newQuad(12, 0, 12, 12, self.textures:getWidth(), self.textures:getHeight()),
			love.graphics.newQuad(24, 0, 12, 12, self.textures:getWidth(), self.textures:getHeight()),
		},
		neon = {
			love.graphics.newQuad(0, 12, 12, 12, self.textures:getWidth(), self.textures:getHeight()),
			love.graphics.newQuad(12, 12, 12, 12, self.textures:getWidth(), self.textures:getHeight()),
			love.graphics.newQuad(24, 12, 12, 12, self.textures:getWidth(), self.textures:getHeight()),
		},
	}
end

return Ball
