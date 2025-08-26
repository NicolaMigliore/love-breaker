require 'globals'
local UIClass = require 'ui'
local UI

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- camera setup
	local gameWidth, gameHeight = FIXED_WIDTH, FIXED_HEIGHT --fixed game resolution
	local windowWidth, windowHeight = 720, 720           --love.window.getDesktopDimensions()
	Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight,
		{ fullscreen = false, resizable = true, pixelperfect = true })

	-- UI setup
	UI = UIClass(windowWidth, windowHeight)

	-- game states setup
	GameState.registerEvents()
	GameState.switch(GAME_SCENES.title)

	-- inputs setup
	INPUT = Baton.new({
		controls = {
			left = { 'key:left', 'key:a', 'axis:leftx-', 'button:dpleft' },
			right = { 'key:right', 'key:d', 'axis:leftx+', 'button:dpright' },
			action1 = { 'key:space', 'button:a' },
			reload = { 'key:r', 'button:y' }
		},
		pairs = {},
		joystick = love.joystick.getJoysticks()[1],
	})
end

function love.update(dt)
	UI:update(dt)
	INPUT:update()
end

function love.draw()
end

function love.resize(w, h)
	Push:resize(w, h)
end

function love.mousepressed(x, y, button, istouch)
	UI:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	UI:mousereleased(x, y, button, istouch)
end

function love.keypressed(key)
	UI:keypressed(key)
end

function love.joystickadded(joystick)
	UI:joystickadded(joystick)
end

function love.joystickremoved(joystick)
	UI:joystickremoved(joystick)
end

function love.gamepadpressed(joystick, button)
	UI:gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
	UI:gamepadreleased(joystick, button)
end
