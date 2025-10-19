local Card = Object:extend()

function Card:new(msg, time, color, clearTimer)
	self.time = time
	self.clearTimer = clearTimer
	self.color = { color[1], color[2], color[3], 1 }

	self.msg = msg
	self.showText = false
	local textColor = { self.color[1] + .25, self.color[2] + .25, self.color[3] + .25 }
	self.text = love.graphics.newText(FONTS.robotic, { textColor, self.msg })
	-- self.text = love.graphics.newText(FONTS.robotic, { { 1, 1, 1, 1 }, self.msg })

	self.pos = Vector(FIXED_WIDTH / 2, FIXED_HEIGHT / 2)
	self.w = FIXED_WIDTH - 120
	self.h = 100
	self.maxW, self.maxH = self.w, self.h

	-- animate card
	self:open()
end

function Card:draw()
	local color = self.color
	-- background
	color[4] = .30
	love.graphics.setColor(color)
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h, 5)

	-- frame
	color[4] = 1
	love.graphics.setColor(color)
	love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h, 5)

	-- text
	if self.showText then
		local textW, textH = self.text:getWidth(), self.text:getHeight()
		local textX, textY = FIXED_WIDTH / 2 - textW / 2, FIXED_HEIGHT / 2 - textH / 2
		love.graphics.draw(self.text, textX, textY)
	end
end


function Card:open()
	self.w, self.h = 0, 0
	local afterOpen = function()
		self.showText = true
	end

	local animTime = .1
	Timer.tween(animTime, self, { w = self.maxW, h = self.maxH }, 'linear', afterOpen)
	Timer.tween(animTime, self.pos, { x = FIXED_WIDTH / 2 - self.maxW / 2, y = FIXED_HEIGHT / 2 - self.maxH / 2 }, 'linear')
end

return Card
