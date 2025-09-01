local Particles = Object:extend()

-- reference: https://dev.to/jeansberg/make-a-shooter-in-lualove2d---animations-and-particles
function Particles:new()
	self.list = {}
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
		-- love.graphics.circle('fill', x, y, 2)
	end
end

--- Add puff particles
---@param x number position x
---@param y number position y
---@param r number direction rotation
function Particles:addPuff(x, y, r)
	local getBlast = function(size)
		local blast = love.graphics.newCanvas(size, size)
		love.graphics.setCanvas(blast)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.circle('fill', size/2, size/2, size/2)
		love.graphics.setCanvas()
		return blast
	end

	local ps = love.graphics.newParticleSystem(getBlast(50), 30)
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

return Particles