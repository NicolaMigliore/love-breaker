
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
    GameState.registerEvents()
    GameState.switch(GAME_SCENES.game)
end

function love.update(dt)

end

function love.draw()

end

love.keypressed= function( k )
 if KEYS[k] then KEY_DOWN[KEYS[k]]= 1 end
end
love.keyreleased= function( k )
 if KEYS[k] then KEY_DOWN[KEYS[k]]= nil end
end