require 'globals'
local Audio = require 'audio'
local UIClass = require 'ui'
UI = nil

local secondTimer = 0
local frames = 0
local fps = 0
local function drawFrames()
	if GAME_SETTINGS.debugMode then
		love.graphics.setCanvas(CANVAS.basic)
		love.graphics.print("FPS: " .. tostring(fps), GAME_SETTINGS.fixedWidth - 95, 15)
		love.graphics.setCanvas()
	end
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- camera setup
	local gameWidth, gameHeight = GAME_SETTINGS.fixedWidth, GAME_SETTINGS.fixedHeight --fixed game resolution
	local windowWidth, windowHeight = 720, 720           --love.window.getDesktopDimensions()
	Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight,
		{ fullscreen = false, resizable = true, pixelperfect = true })
	Shack:setDimensions(gameWidth, gameHeight)

	-- load shader effects
	loadEffects(windowWidth, windowHeight)

	-- load audio files
	AUDIO = Audio()
	AUDIO:loadSfx()

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
			action2 = { 'button:b' },
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

	if INPUT:pressed('debug') then GAME_SETTINGS.debugMode = not GAME_SETTINGS.debugMode end

	-- calculate fps
	secondTimer = secondTimer + dt
	frames = frames + 1
	if secondTimer >= 1 then
		fps = frames
		secondTimer = secondTimer - 1
		frames = 0
	end
		
end

function love.draw()
	-- reset font
	love.graphics.setFont(FONTS.robotic)

	Shack:apply()
	UI:draw()
	drawFrames()

	love.graphics.setColor(1, 1, 1, 1)
	-- draw basic canvas
	love.graphics.draw(CANVAS.basic, 0, 0)
	-- draw effect canvas
	if GAME_SETTINGS.enableShaders then
		EFFECT(function()
			love.graphics.draw(CANVAS.effects, 0, 0)
		end)
	end
	
	-- clear canvases
	for name, canvas in pairs(CANVAS) do
		love.graphics.setCanvas(canvas)
		love.graphics.clear(PALETTE.black)
	end
	love.graphics.setCanvas()

	if DEBUG_MSG ~= nil then
		love.graphics.print(DEBUG_MSG, 10, 10)
	end
end

function love.resize(w, h)
	Push:resize(w, h)
	if EFFECT then 
		EFFECT.resize(w, h)
	end
end

function love.textinput(text)
	UI:textinput(text)
end
function love.keypressed(k)
	UI:keypressed(k)
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
