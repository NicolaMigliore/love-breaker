local UI = Object:extend()

function UI:new(windowWidth, windowHeight)
	Luis.baseWidth = windowWidth
	Luis.baseHeight = windowHeight
	Luis.setGridSize(18)
	self:initJoysticks()

	love.graphics.setFont(FONTS.robotic)
	Luis.setTheme(THEMES.basic)
end

function UI:update(dt)
	TIME = TIME + dt
	if TIME >= 1 / 60 then
		Luis.flux.update(TIME)
		TIME = 0
	end
	Luis.updateScale()
	Luis.update(dt)

	
	-- handle inputs from controller
	if INPUT:pressed('action1') then Luis.gamepadpressed(INPUT.joystick, 'a') end
	if INPUT:released('action1') then Luis.gamepadreleased(INPUT.joystick, 'a') end
	if INPUT:released('debug') then
		Luis.showGrid = not Luis.showGrid
		Luis.showLayerNames = not Luis.showLayerNames
		Luis.showElementOutlines = not Luis.showElementOutlines
	end

	if INPUT:pressed('down') then
		Luis.moveFocus("next")
	elseif INPUT:pressed('up') then
		Luis.moveFocus("previous")
	end
end

function UI:draw()
	Luis:draw()
end

function UI:mousepressed(x, y, button, istouch)
	Luis.mousepressed(x, y, button, istouch)
end
function UI:mousereleased(x, y, button, istouch)
	Luis.mousereleased(x, y, button, istouch)
end

function UI:initJoysticks()
	Luis.initJoysticks()
end

function UI:getMaxCol()
	local gridCellSize = Luis.getGridSize()
	local screenW, screenH = love.window.getMode()
	return math.floor(screenW / gridCellSize)
end

function UI:getMaxRow()
	local gridCellSize = Luis.getGridSize()
	local screenW, screenH = love.window.getMode()
	return math.floor(screenH / gridCellSize)
end

--- Create new container
---@param layerName string
---@param w number
---@param h number
---@param row number
---@param col number
---@param decorator any decorator configuration to apply
---@param containerName string
---@return any container the new container
function UI:newContainer(layerName, w, h, row, col, decorator, containerName)
	local container = Luis.createElement(layerName, 'Container', w, h, row, col, false, false, nil, containerName)
	container.focusable = false
	if container and decorator then
		container:setDecorator(
			'CustomSlice9Decorator',
			decorator.img,
			decorator.left,
			decorator.right,
			decorator.top,
			decorator.bottom
		)
	end
	return container
end

function UI:newButton(layerName, text, w, h, decorator, onClick, onRelease)
	local btn = Luis.createElement(layerName, 'Button', text, w, h, onClick, onRelease, 1, 1, nil)
	if btn and decorator then
		btn:setDecorator(
			'CustomSlice9Decorator',
			decorator.img,
			decorator.left,
			decorator.right,
			decorator.top,
			decorator.bottom,
			decorator.hoverImg
		)
	end
	return btn
end

function UI:newLabel(layerName, text, w, h, align, customTheme)
	local defaultTheme = {
		color = { 1, 1, 1, 1 },
		font = FONTS.robotic,
		align = align or 'left',
	}
	customTheme = customTheme or defaultTheme
	local label = Luis.createElement(layerName, 'Label', text, w, h, 1, 1, align, customTheme)

	return label
end

return UI
