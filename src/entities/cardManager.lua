local Card = require 'src.entities.card'
local CardManager = Object:extend()

function CardManager:new()
	self.cards = {}
end

function CardManager:draw()
	for i, card in ipairs(self.cards) do
		card:draw()
	end
end

function CardManager:addCard(msg, time, color, exclusive)
	-- clear other card timers
	if exclusive then
		for i, card in ipairs(self.cards) do
			Timer.cancel(card.clearTimer)
		end
	end
	-- delete all cards
	self.cards = {}

	-- create card with clear timer
	local idToRemove = #self.cards + 1
	local clearTimer = Timer.after(time, function() table.remove(self.cards, idToRemove) end)
	local card = Card(msg, time, color, clearTimer)

	table.insert(self.cards, card)
end

function CardManager:closeCard(card)
	for i, c in ipairs(self.cards) do
		if c == card then
			table.remove(self.cards, i)
			i = i - 1
		end
	end
end

return CardManager
