local Drop = Object:extend()
local DropTypes = {
	life = 'life',
	bigBall = 'bigBall',
	speedPaddle = 'speedPaddle',
	multiBall = 'multiBall',
}
local DropTypeColors = {
	life = PALETTE.red_2,
	bigBall = PALETTE.orange_2,
	speedPaddle = PALETTE.green_2,
	multiBall = PALETTE.orange_3,
}

function Drop:new(x, y)
	self.pos = Vector(x, y)
	self.w = 32
	self.h = 32
	
	-- set random type
	local typeStrings = Lume.keys(DropTypes)
	local typeIndex = math.floor(love.math.random() * #typeStrings) + 1
	self.type = DropTypes[typeStrings[typeIndex]]

	-- add drop to global list
	if DROPS then
		table.insert(DROPS, self)
	end

	self.textures = love.graphics.newImage('assets/textures/drop.png')
	self.quads = self:getQuads()
end

function Drop:update(dt)
	self.pos.y = self.pos.y + dt * 200
end

function Drop:draw(style)
	love.graphics.setColor(1, 1, 1, 1)

	if style == STYLES.neon then
		local quadW, quadH, quad = self.quads.basic.w, self.quads.basic.h, self.quads[style][self.type]
		local scaleX, scaleY = self.w / quadW, self.h / quadH
		love.graphics.draw(self.textures, quad, self.pos.x, self.pos.y, 0, scaleX, scaleY)
	else
		local quadW, quadH, quad = self.quads.basic.w, self.quads.basic.h, self.quads.basic[self.type]
		local scaleX, scaleY = self.w / quadW, self.h / quadH
		love.graphics.setColor(DropTypeColors[self.type])
		love.graphics.draw(quad, self.pos.x, self.pos.y, 0, scaleX, scaleY)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

function Drop:getQuads()
	local w, h = 16, 16
	local textureWidth, textureHeight = self.textures:getWidth(), self.textures:getHeight()

	-- define basic drawables
	local basicDrop = love.graphics.newCanvas(w, h)
	love.graphics.setCanvas(basicDrop)
	love.graphics.circle('fill', w / 2, h / 2, w / 2)
	love.graphics.setCanvas()

	return {
		basic = {
			w = w,
			h = h,
			life = basicDrop,
			bigBall = basicDrop,
			speedPaddle = basicDrop,
			multiBall = basicDrop,
		},
		-- textured = {},
		neon = {
			w = w,
			h = h,
			life = love.graphics.newQuad(0, 16, w, h, textureWidth, textureHeight),
			bigBall = love.graphics.newQuad(16, 16, w, h, textureWidth, textureHeight),
			speedPaddle = love.graphics.newQuad(32, 16, w, h, textureWidth, textureHeight),
			multiBall = love.graphics.newQuad(48, 16, w, h, textureWidth, textureHeight),
		}
	}
end

return { Drop, DropTypes, DropTypeColors }
