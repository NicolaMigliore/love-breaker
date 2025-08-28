local Ball = Object:extend()

function Ball:new(x, y, r)
	self.pos = Vector(x, y)
	self.rad = r
	self.speed = 0
	local angle = -math.pi / 4
	self.vel = Vector.fromPolar(angle, 1) --Vector(1,1)
	self.collision = false
	self.textures = love.graphics.newImage('assets/textures/ball.png')
	self.quads = self:getQuads()

	-- -- TODO: implement advanced trails (https://love2d.org/forums/viewtopic.php?p=247592#p247592)
	-- self.trail = {}
	-- self.trailMax = 128
end

function Ball:update(dt, paddle, bricks)
	-- table.insert(self.trail, self.pos)
	-- if #self.trail > self.trailMax then table.remove(self.trail, 1) end

	local normVelocity = self.vel:normalized()
	self.pos = self.pos + normVelocity * self.speed * dt

	self.collision = false
	-- check bounds collision
	self:boundsCollision()

	-- check paddle collisions
	self:paddleCollision(paddle)

	-- check bricks collision
	self:brickCollision(bricks)
end

function Ball:draw(style)
	love.graphics.setColor(1, 1, 1)

	-- -- draw particles
	-- for i, tp in ipairs(self.trail) do
	--     love.graphics.circle('fill', tp.x, tp.y, (self.rad-2) *(i/self.trailMax))
	-- end

	if style == STYLES.basic then
		love.graphics.rectangle('fill', (self.pos.x - self.rad), (self.pos.y - self.rad), (self.rad * 2), (self.rad * 2))
	elseif style == STYLES.textured then 
		local quad = self.quads[style]
		love.graphics.draw(self.textures, quad, (self.pos.x - self.rad), (self.pos.y - self.rad))
	else
		-- default draw
		if self.collision then love.graphics.setColor(.6, .2, .2) end
		love.graphics.circle('fill', self.pos.x, self.pos.y, self.rad)
	end
	love.graphics.setColor(1, 1, 1)
end

--- Run collision checks with game bounds
function Ball:boundsCollision()
	local maxX = FIXED_WIDTH
	local maxY = FIXED_HEIGHT

	local invertX = (self.pos.x + self.rad > maxX) or (self.pos.x - self.rad < 0)
	if invertX then
		self.vel.x = -self.vel.x
		self.pos.x = Utils.mid(0 + self.rad, self.pos.x, maxX - self.rad)
	end

	local invertY = (self.pos.y + self.rad > maxY) or (self.pos.y - self.rad < 0)
	if invertY then
		self.vel.y = -self.vel.y
		self.pos.y = Utils.mid(0 + self.rad, self.pos.y, maxY - self.rad)
	end
end

--- Run collision checks with the paddle and deflect the ball if necessary.
---@param paddle Paddle The paddle to check
function Ball:paddleCollision(paddle)
	local paddleCollision, collRectLeft, collRectRight, collRectTop, collRectBottom = Utils.collisionCircRect(
		self.pos.x,
		self.pos.y,
		self.rad,
		paddle.pos.x,
		paddle.pos.y,
		paddle.w,
		paddle.h
	)
	self.collision = self.collision or paddleCollision
	if paddleCollision then
		-- deflect vertically
		if collRectTop or collRectBottom then
			self.vel.y = -self.vel.y
			self.pos.y = paddle.pos.y - self.rad
		end

		-- deflect horizontally
		local same_dir = Utils.sign(self.vel.x) == Utils.sign(paddle.vel.x)
		local hit_sides = collRectLeft or collRectRight

		-- round angle values to avoid float rounding errors
		local cur_angle = Utils.round(math.atan2(self.vel.y, self.vel.x), 4)
		local is30or150Deg = (Utils.round(-math.pi / 6, 4) == cur_angle) or (Utils.round(-math.pi * 5 / 6, 4) == cur_angle)                                                               -- 30°
		local is60or120Deg = (Utils.round(-math.pi / 3, 4) == cur_angle) or (Utils.round(-math.pi * 2 / 3, 4) == cur_angle)                                                               -- 60°

		if hit_sides and (not same_dir or paddle.vel.x == 0) then
			self.vel.x = -self.vel.x
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
	end
end

--- Run collision checks with the bricks and deflect the ball if necessary.
---@param bricks Table<Brick> List of bricks to check
function Ball:brickCollision(bricks)
	for i, brick in ipairs(bricks) do
		if not brick.collision then
			local brickCollision, collRectLeft, collRectRight, collRectTop, collRectBottom = Utils.collisionCircRect(
				self.pos.x,
				self.pos.y,
				self.rad,
				brick.pos.x,
				brick.pos.y,
				brick.w,
				brick.h
			)
			self.collision = self.collision or brickCollision
			brick.collision = brick.collision or brickCollision

			if brickCollision then
				if collRectTop or collRectBottom then
					self.vel.y = -self.vel.y
				elseif collRectLeft or collRectRight then
					self.vel.x = -self.vel.x
				end
			end
		end
	end
end

function Ball:getQuads()
	return {
		textured = love.graphics.newQuad(0, 0, 8, 8, self.textures:getWidth(), self.textures:getHeight())
	}
end

return Ball
