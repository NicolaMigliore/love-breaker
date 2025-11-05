local Paddle = Object:extend()

function Paddle:new(x, y, w, h)
	self.pos = Vector(x, y)
	self.vel = Vector(0, 0)
	self.lastDir = Vector(1, 0)
	self.w = w
	self.h = h
	self.speed = 300
	self.textures = love.graphics.newImage('assets/textures/paddle.png')
	self.quads = self:getQuads()
end

function Paddle:update(dt)
	if self.vel ~= Vector(0, 0) then self.lastDir = self.vel:normalized() end

	self.vel.x = 0
	if INPUT:down('left') then self.vel.x = -1 end
	if INPUT:down('right') then self.vel.x = 1 end

	local normVelocity = self.vel:normalized()
	self.vel = normVelocity * self.speed * dt
	self.pos = self.pos + self.vel

	-- check bounds
	local minX, maxX = 10, GAME_SETTINGS.fixedWidth - 10
	if self.pos.x < minX then self.pos.x = minX end
	if self.pos.x + self.w > maxX then self.pos.x = maxX - self.w end
end

function Paddle:draw(style)
	love.graphics.setColor(1, 1, 1, 1)
	if style == STYLES.textured or style == STYLES.neon then
		local w, h = self.w, self.h
		local xOffset, yOffset = 0, 0
		-- override width and offset based on collision state
		if self.collision then
			w = w * 1.1
			xOffset = (self.w - w) / 2
			h = h * .8
			yOffset = (self.h - h) / 2
		end
		-- calculate quad, position, and scale
		local x, y = self.pos.x + xOffset, self.pos.y + yOffset
		local quadW, quadH, quad = self.quads[style].w, self.quads[style].h, self.quads[style].quad
		local scaleX, scaleY = w / quadW, h / quadH
		
		love.graphics.draw(self.textures, quad, x, y, 0, scaleX, scaleY)
	else
		-- default draw
		if self.collision then love.graphics.setColor(.6, .2, .2) end
		love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
	end
	love.graphics.setColor(1, 1, 1)
end

function Paddle:getQuads()
	local w, h = 70, 7
	return {
		textured = {
			w = w,
			h = h,
			quad = love.graphics.newQuad(0, 0, w, h, self.textures:getWidth(), self.textures:getHeight()),
		},
		neon = {
			w = w,
			h = h,
			quad = love.graphics.newQuad(0, 7, w, h, self.textures:getWidth(), self.textures:getHeight()),
		}
	}
end

function Paddle:setCollision(hasCollision)
	self.collision = hasCollision
	if hasCollision then
		Timer.after(.1, function() self.collision = false end)
	end
end

return Paddle
