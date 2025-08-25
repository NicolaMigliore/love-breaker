require 'globals'

KEYS = {
    left = 'left',
    a = 'left',
    right = 'right',
    d = 'right',
    r = 'r',
    space = 'space',
}
KEY_DOWN = {}

function love.load()
     love.graphics.setDefaultFilter("nearest", "nearest")
     
    -- camera setup
    local gameWidth, gameHeight = FIXED_WIDTH,FIXED_HEIGHT --fixed game resolution
    local windowWidth, windowHeight = 720,720--love.window.getDesktopDimensions()
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true, pixelperfect = true})

    GameState.registerEvents()
    GameState.switch(GAME_SCENES.game)
end

function love.update(dt)

end

function love.draw()

end

function love.resize(w, h)
  Push:resize(w, h)
end

love.keypressed= function( k )
 if KEYS[k] then KEY_DOWN[KEYS[k]]= 1 end
end
love.keyreleased= function( k )
 if KEYS[k] then KEY_DOWN[KEYS[k]]= nil end
end