local Brick = Object:extend()

local BrickTypes = {
	base = 'base',
	hard = 'hard',
	explosive = 'explosive',
	drop = 'drop',
}

function Brick:new(x, y, w, h, type)
	local startY = -20 - love.math.random(100)
	-- local startX = (love.math.random(720))
	-- self.pos = Vector(startX, startY)
	self.pos = Vector(x, startY)
	self.offset = Vector(0, 0)
	self.w = w
	self.h = h
	self.type = type
	self.scale = 1
	self.lives = type == BrickTypes.hard and 2 or 1
	self.collision = false
	self.breakTimer = .1
	self.textures = love.graphics.newImage('assets/textures/brick.png')
	self.quads = self:getQuads()

	Flux.to(self.pos, .5 + love.math.random(), { x = x, y = y }):ease("elasticout")
end

function Brick:update(dt)
	if self.collision then
		self.breakTimer = self.breakTimer - dt
	end
end

function Brick:draw(style)
	love.graphics.setColor(1, 1, 1)

	local x, y = self.pos.x + self.offset.x, self.pos.y + self.offset.y
	local w, h = self.w, self.h

	if DEBUG then love.graphics.rectangle('line', x, y, w, h) end

	if style == STYLES.basic then
		love.graphics.rectangle('fill', x, y, w, h)
	elseif style == STYLES.textured then
		local quadW, quadH, quad = self.quads[style].w, self.quads[style].h, self.quads[style].quad
		local scaleX, scaleY = w / quadW, h / quadH
		love.graphics.draw(self.textures, quad, x, y, 0, scaleX, scaleY)
	else
		if self.lives > 1 then love.graphics.setColor(.3, .2, .5) end
		if self.type == BrickTypes.explosive then love.graphics.setColor(.5, .2, .3) end
		if self.collision then love.graphics.setColor(.6, .2, .2) end
		
		local rectOx, rectOy = self.w / 2, self.h / 2
		local quadW, quadH, quad = self.quads.basic.w, self.quads.basic.h, self.quads.basic.quad
		local quadOx, quadOy = quadW / 2, quadH / 2
		local scaleX, scaleY = w / quadW * self.scale, h / quadH * self.scale
		local angle = 0

		
		love.graphics.draw(quad, x + rectOx, y + rectOy, angle, scaleX, scaleY, quadOx, quadOy)
		
		-- love.graphics.setColor(1, 0, 0)
		-- love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h)
		-- love.graphics.circle('fill', self.pos.x + rectOx, self.pos.y + rectOy, 5)
	end
end

function Brick:getQuads()
	local w, h = 40, 20

	local basicBrick = love.graphics.newCanvas(w, h)
	love.graphics.setCanvas(basicBrick)
	love.graphics.rectangle('fill', 0, 0, w, h)
	love.graphics.setCanvas()

	return {
		basic = {
			w = w,
			h = h,
			quad = basicBrick,
		},
		textured = {
			w = w,
			h = h,
			quad = love.graphics.newQuad(0, 0, w, h, self.textures:getWidth(), self.textures:getHeight()),
		}
	}
end

function Brick:collide(offset, bricks)
	self.lives = self.lives - 1
	self.collision = true
	self.offset = offset * 10
	Flux.to(self.offset, .5 + love.math.random(), { x = 0, y = 0 }):ease("elasticout")

	if self.type == BrickTypes.explosive then
		self.lives = self.lives + 1
		self.collision = false
		for i, brick in ipairs(bricks) do
			-- get bricks in range
			local range = self.w + 10
			local impactVector = self.pos - brick.pos
			local dist = impactVector:len()
			if brick ~= self and not brick.collision and dist <= range then
				-- collide bricks
				Flux.to(self, .5, { scale = 1.2 })
					:ease('elasticin')
					:oncomplete(function()
						self.lives = self.lives - 1
						self.collision = true
						print('completing explosion')
						brick:collide(impactVector:normalized(), bricks)
					end)
			end
		end
	end
end

return { Brick, BrickTypes }
