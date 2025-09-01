local Brick = Object:extend()

function Brick:new(x, y, w, h)
	local startY = -20 - love.math.random(100)
	-- local startX = (love.math.random(720))
	-- self.pos = Vector(startX, startY)
	self.pos = Vector(x, startY)
	self.offset = Vector(0, 0)
	self.w = w
	self.h = h
	self.collision = false
	self.collisionEdge = 0
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

	if DEBUG then love.graphics.rectangle('line', x, y, self.w, self.h) end

	if style == STYLES.basic then
		love.graphics.rectangle('fill', x, y, self.w, self.h)
	elseif style == STYLES.textured then
		local quadW, quadH, quad = self.quads[style].w, self.quads[style].h, self.quads[style].quad
		local scaleX, scaleY = self.w / quadW, self.h / quadH
		love.graphics.draw(self.textures, quad, x, y, 0, scaleX, scaleY)
	else
		if self.collision then love.graphics.setColor(.6, .2, .2) end
		love.graphics.rectangle('fill', x, y, self.w, self.h)
	end
end

function Brick:getQuads()
	local w, h = 40, 15
	return {
		textured = {
			w = w,
			h = h,
			quad = love.graphics.newQuad(0, 0, w, h, self.textures:getWidth(), self.textures:getHeight()),
		}
	}
end

function Brick:collide(collisionEdge, offset)
	self.collision = true
	self.collisionEdge = collisionEdge
	self.offset = offset * 10
	Flux.to(self.offset, .5 + love.math.random(), { x = 0, y = 0 }):ease("elasticout")
end

return Brick
