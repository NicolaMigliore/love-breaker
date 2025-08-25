require 'globals'

function love.load()
     love.graphics.setDefaultFilter("nearest", "nearest")

    -- camera setup
    local gameWidth, gameHeight = FIXED_WIDTH,FIXED_HEIGHT --fixed game resolution
    local windowWidth, windowHeight = 720,720--love.window.getDesktopDimensions()
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true, pixelperfect = true})

    -- game states setup
    GameState.registerEvents()
    GameState.switch(GAME_SCENES.game)

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
  INPUT:update()
end

function love.draw()

end

function love.resize(w, h)
  Push:resize(w, h)
end
