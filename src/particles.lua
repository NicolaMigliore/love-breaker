local Particles = Object:extend()

-- reference: https://dev.to/jeansberg/make-a-shooter-in-lualove2d---animations-and-particles
function Particles:new()
	self.list = {}

	-- images
	local size = 50
	love.graphics.setColor(1, 1, 1, 1)

	local puff = love.graphics.newCanvas(size, size)
	love.graphics.setCanvas(puff)
	love.graphics.circle('fill', size/2, size/2, size/2)
	self.puffImg = puff
	
	local shatter = love.graphics.newCanvas(size, size)
	love.graphics.setCanvas(shatter)
	love.graphics.rectangle('fill', 0, 0, size, size)
	self.shatterImg = shatter

	love.graphics.setCanvas()
end

function Particles:update(dt)
	for i,p in ipairs(self.list) do
		p:update(dt)
		if p:getCount() == 0 then
			table.remove(self.list,i)
			i = i - 1
		end
	end
end

function Particles:draw()
	-- love.graphics.setColor(1,.5,0,1)
	love.graphics.setColor(1, 1, 1, 1)
	for i,p in ipairs(self.list) do
		local x, y = p:getPosition()
		love.graphics.draw(p)
		if DEBUG then
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.circle('fill', x, y, 10)
		end
	end
end

--- Add puff particles
---@param x number position x
---@param y number position y
---@param r number direction rotation
function Particles:addPuff(x, y, r)
	local ps = love.graphics.newParticleSystem(self.puffImg, 30)
	ps:setColors(0.26953125, 0.22215270996094, 0.22215270996094, 1, 0.331298828125, 0.33332443237305, 0.4609375, 1, 0.72265625, 0.72265625, 0.72265625, 0.3984375)
	ps:setDirection(r)
	ps:setEmissionArea("none", 0, 0, 0, false)
	ps:setEmissionRate(0)
	ps:setEmitterLifetime(-1)
	ps:setInsertMode("top")
	ps:setLinearAcceleration(0, 0, 0, 0)
	ps:setLinearDamping(11.27397441864, 20)
	ps:setOffset(50, 50)
	ps:setParticleLifetime(0.1, 0.3)
	ps:setRadialAcceleration(0, 139.73808288574)
	ps:setRelativeRotation(false)
	ps:setRotation(0, 0)
	ps:setSizes(0.050000000745058, 0.20000000298023)
	ps:setSizeVariation(0.75079870223999)
	ps:setSpeed(25.00790977478, 383.16201782227)
	ps:setSpin(0, 0)
	ps:setSpinVariation(0)
	ps:setSpread(0.69813168048859)
	ps:setTangentialAcceleration(0, 0)

	ps:setPosition(x, y)
	ps:emit(5)

	table.insert(self.list, ps)
end

function Particles:addShatter(x, y, r)
	local ps = love.graphics.newParticleSystem(self.shatterImg, 1050)
	ps:setColors(1, 1, 1, 0.5, 1, 1, 1, 1, 1, 1, 1, 0)
	ps:setDirection(r)
	ps:setEmissionArea("normal", 10, 5, 0, false)
	ps:setEmissionRate(500)
	ps:setEmitterLifetime(0.03)
	ps:setInsertMode("top")
	ps:setLinearAcceleration(-512, 772.13201904297, 512, 1102.8488769531)
	ps:setLinearDamping(0.71063297986984, 0.71063297986984)
	ps:setOffset(50, 50)
	ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
	ps:setRadialAcceleration(703.181640625, 703.181640625)
	ps:setRelativeRotation(false)
	ps:setRotation(0, 0)
	ps:setSizes(0.050000000745058, 0.11999999731779)
	ps:setSizeVariation(0.5)
	ps:setSpeed(90, 100)
	ps:setSpin(1.256637096405, 0)
	ps:setSpinVariation(0.30000001192093)
	ps:setSpread(0.31415927410126)
	ps:setTangentialAcceleration(0, 0)

	ps:setPosition(x, y)
	ps:emit(5)

	table.insert(self.list, ps)
end

return Particles
