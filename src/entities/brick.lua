local Brick = Object:extend()

function Brick:new(x, y, w, h)
	self.pos = Vector(x, y)
	self.vel = Vector(0, 0)
	self.w = w
	self.h = h
	self.collision = false
	self.breakTimer = .1
	self.textures = love.graphics.newImage('assets/textures/brick.png')
	self.quads = self:getQuads()
end

function Brick:update(dt)
	if self.collision then
		self.breakTimer = self.breakTimer - dt
	end
end

function Brick:draw(style)
	love.graphics.setColor(1, 1, 1)

	if style == STYLES.basic then
		love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
	elseif style == STYLES.textured then
		local quad = self.quads[style]
		love.graphics.draw(self.textures, quad, self.pos.x, self.pos.y)
	else
		if self.collision then love.graphics.setColor(.6, .2, .2) end
		love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
	end
end

function Brick:getQuads()
	return {
		textured = love.graphics.newQuad(0, 0, 40, 10, self.textures:getWidth(), self.textures:getHeight())
	}
end

return Brick
