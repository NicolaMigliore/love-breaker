require 'globals'
DEBUG = false
local UIClass = require 'ui'
UI = nil

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- camera setup
	local gameWidth, gameHeight = FIXED_WIDTH, FIXED_HEIGHT --fixed game resolution
	local windowWidth, windowHeight = 720, 720           --love.window.getDesktopDimensions()
	Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight,
		{ fullscreen = false, resizable = true, pixelperfect = true })
	Shack:setDimensions(gameWidth, gameHeight)

	-- load shader effects
	loadEffects(windowWidth, windowHeight)

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
			up = { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' },
			down = { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' },
			action1 = { 'key:space', 'button:a' },
			reload = { 'key:r', 'button:y' },
			start = { 'key:escape', 'key:insert', 'button:start' },
			debug = { 'key:tab' },
		},
		pairs = {},
		joystick = love.joystick.getJoysticks()[1],
	})
end

function love.update(dt)
	Timer.update(dt)
	Flux.update(dt)
	UI:update(dt)
	Shack:update(dt)
	INPUT:update()

	if INPUT:pressed('debug') then DEBUG = not DEBUG end
end

function love.draw()
	Shack:apply()
	UI:draw()

	love.graphics.setColor(1, 1, 1, 1)
	-- draw basic canvas
	love.graphics.draw(CANVAS.basic, 0, 0)
	-- draw effect canvas
	EFFECT(function()
		love.graphics.draw(CANVAS.effects, 0, 0)
	end)

	-- clear canvases
	for name, canvas in pairs(CANVAS) do
		love.graphics.setCanvas(canvas)
		love.graphics.clear(PALETTE.black)
	end
	love.graphics.setCanvas()
end

function love.resize(w, h)
	Push:resize(w, h)
	if EFFECT then 
		EFFECT.resize(w, h)
	end
end

function love.mousepressed(x, y, button, istouch)
	UI:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	UI:mousereleased(x, y, button, istouch)
end

function love.joystickadded(joystick)
	INPUT.joystick = joystick
end

function loadEffects(windowWidth, windowHeight)
	EFFECT = Moonshine(windowWidth, windowHeight, Moonshine.effects.glow)
		.chain(Moonshine.effects.scanlines)
		.chain(Moonshine.effects.vignette)
	
	-- configure glow
	EFFECT.glow.min_luma = .4
	EFFECT.glow.strength = 15

	-- configure scan lines
	EFFECT.width = 4
	EFFECT.scanlines.opacity = 0.2
	EFFECT.scanlines.frequency = windowHeight / 3
	EFFECT.scanlines.color = { PALETTE.blue_1[1], PALETTE.blue_1[2], PALETTE.blue_1[3] }
	
	-- configure vignette	
	EFFECT.vignette.softness = .3
	EFFECT.vignette.opacity = 0.2
end
