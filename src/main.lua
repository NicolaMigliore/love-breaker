require 'globals'

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- camera setup
  local gameWidth, gameHeight = FIXED_WIDTH, FIXED_HEIGHT  --fixed game resolution
  local windowWidth, windowHeight = 720, 720               --love.window.getDesktopDimensions()
  Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight,
    { fullscreen = false, resizable = true, pixelperfect = true })

  -- UI setup
  Luis.baseWidth = windowWidth
  Luis.baseHeight = windowHeight
  Luis.setGridSize(18)
  Luis.initJoysticks()

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

  INPUT:update()
end

function love.draw()
end

function love.resize(w, h)
  Push:resize(w, h)
end

function love.mousepressed(x, y, button, istouch)
    Luis.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    Luis.mousereleased(x, y, button, istouch)
end
function love.keypressed(key)
  if key == "tab" then -- Debug View
    Luis.showGrid = not Luis.showGrid
    Luis.showLayerNames = not Luis.showLayerNames
    Luis.showElementOutlines = not Luis.showElementOutlines
  else
    Luis.keypressed(key)
  end
end
function love.joystickadded(joystick)
    Luis.initJoysticks()
end
function love.joystickremoved(joystick)
    Luis.removeJoystick(joystick)
end
function love.gamepadpressed(joystick, button)
    Luis.gamepadpressed(joystick, button)
end
function love.gamepadreleased(joystick, button)
    Luis.gamepadreleased(joystick, button)
end
