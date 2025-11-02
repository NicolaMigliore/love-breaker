local Vector2D = require("luis.3rdparty.vector")

local padInputTheme = {
	color = { 1, 1, 1 }, --PALETTE.white,
	padding = 5,
	-- font = FONTS.robotic,
}

local PadInput = {}

local luis -- This will store the reference to the core library
function PadInput.setluis(luisObj)
	luis = luisObj
end

function PadInput.new(row, col, width, height, nChars, value, onChange)
	local iconImage = love.graphics.newImage('assets/textures/icons.png')
	return {
		type = "PadInput",
		position = Vector2D.new((col - 1) * luis.gridSize, (row - 1) * luis.gridSize),
		width = width * luis.gridSize,
		height = height * luis.gridSize,
		value = value,
		onChange = onChange,
		nChars = nChars,
		characters = { " ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" },
		theme = padInputTheme,
		focusable = true,
		focused = false,
		internalFocusIndex = 1,
		iconImage = iconImage,
		iconQuads = {
			up = love.graphics.newQuad(0, 0, 16, 16, iconImage:getWidth(), iconImage:getHeight()),
			down = love.graphics.newQuad(16, 0, 16, 16, iconImage:getWidth(), iconImage:getHeight()),
		},
		visible = true,

		update = function(self)
			
		end,
		draw = function(self)
			if not self.visible then return end
			
			love.graphics.setColor(self.theme.color)
			-- love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height)
			
			-- draw characters
			for i = 1, self.nChars do
				local x, y = self.position.x + (i-1) * 24, self.position.y

				if self.focused and self.internalFocusIndex == i then
					love.graphics.rectangle('line', x, y, 24, self.height, 3)
				end

				love.graphics.draw(self.iconImage, self.iconQuads.up, x + 4, y)

				y = y + 15
				love.graphics.printf(string.sub(self.value, i, i), x - 7, y + 3, 40, 'center')
				y = y + 23

				love.graphics.draw(self.iconImage, self.iconQuads.down, x + 4, y)
			end
		end,
		click = function(args)
		end,
		-- Joystick-specific functions
		gamepadpressed = function(self, id, button)
			if button == 'up' and self.focused then
				local curCharindex = Lume.find(self.characters, string.sub(self.value, self.internalFocusIndex, self.internalFocusIndex))
				local newCharIndex = curCharindex - 1
				if newCharIndex < 1 then
					newCharIndex = #self.characters
				end
				local newChar = self.characters[newCharIndex]
				self.value = Utils.replace_char(self.value, self.internalFocusIndex, newChar)
			elseif button == 'down' and self.focused then
				local curCharindex = Lume.find(self.characters, string.sub(self.value, self.internalFocusIndex, self.internalFocusIndex))
				local newCharIndex = curCharindex + 1
				if newCharIndex > #self.characters then
					newCharIndex = 1
				end
				local newChar = self.characters[newCharIndex]
				self.value = Utils.replace_char(self.value, self.internalFocusIndex, newChar)
			elseif button == 'action1' then
				if self.onChange then
					self.onChange(self.value)
				end
				luis.moveFocus("next")
			end
		end,

		gamepadreleased = function(self, id, button)
			if button == 'left' and self.focused then
				self.internalFocusIndex = self.internalFocusIndex - 1
				if self.internalFocusIndex < 1 then
					self.internalFocusIndex = self.nChars
				end
			elseif button == 'right' and self.focused then
				self.internalFocusIndex = self.internalFocusIndex + 1
				if self.internalFocusIndex > self.nChars then
					self.internalFocusIndex = 1
				end
			end
			return false
		end
	}
end

return PadInput
