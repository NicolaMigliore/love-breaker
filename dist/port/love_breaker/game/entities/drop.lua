local Drop = Object:extend()
local DropTypes = {
	life = 'life',
	bigBall = 'bigBall',
	speedPaddle = 'speedPaddle',
	multiBall = 'multiBall',
}

function Drop:new(x, y)
	self.pos = Vector(x, y)
	self.w = 50
	self.h = 25
	
	-- set random type
	local typeStrings = Lume.keys(DropTypes)
	local typeIndex = math.floor(love.math.random() * #typeStrings) + 1
	self.type = DropTypes[typeStrings[typeIndex]]

	-- add drop to global list
	if DROPS then
		table.insert(DROPS, self)
	end
end

function Drop:update(dt)
	self.pos.y = self.pos.y + dt * 200
end

function Drop:draw()
	love.graphics.setColor(.5, .6, .3)
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
end

return { Drop, DropTypes }
