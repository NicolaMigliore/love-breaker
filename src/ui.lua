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
	if Luis.joystickJustPressed(1, 'dpdown') then
		Luis.moveFocus("next")
	elseif Luis.joystickJustPressed(1, 'dpup') then
		Luis.moveFocus("previous")
	end
end

function UI:mousepressed(x, y, button, istouch)
	Luis.mousepressed(x, y, button, istouch)
end
function UI:mousereleased(x, y, button, istouch)
	Luis.mousereleased(x, y, button, istouch)
end
function UI:keypressed(key)
	if key == "tab" then -- Debug View
		Luis.showGrid = not Luis.showGrid
		Luis.showLayerNames = not Luis.showLayerNames
		Luis.showElementOutlines = not Luis.showElementOutlines
	else
		Luis.keypressed(key)
	end
end
function UI:joystickadded(joystick)
	Luis.initJoysticks()
end

function UI:joystickremoved(joystick)
	Luis.removeJoystick(joystick)
end
function UI:gamepadpressed(joystick, button)
	Luis.gamepadpressed(joystick, button)
end
function UI:gamepadreleased(joystick, button)
	Luis.gamepadreleased(joystick, button)
end

return UI
