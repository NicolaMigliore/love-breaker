local UI = Object:extend()

function UI:new(windowWidth,windowHeight)
	Luis.baseWidth = windowWidth
	Luis.baseHeight = windowHeight
	Luis.setGridSize(18)
	Luis.initJoysticks()
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

function UI:mousepressed(x, y, button, istouch)
	Luis.mousepressed(x, y, button, istouch)
end
function UI:mousereleased(x, y, button, istouch)
	Luis.mousereleased(x, y, button, istouch)
end

return UI
