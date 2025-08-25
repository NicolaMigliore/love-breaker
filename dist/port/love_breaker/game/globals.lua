
-- Load libraries
Camera = require 'libs.hump.camera'
GameState = require 'libs.hump.gamestate'
Vector = require 'libs.hump.vector'
Object = require 'libs.classic'
Husl = require 'libs.husl'
Inspect = require 'libs.inspect'
Lume = require 'libs.lume'
Utils = require 'libs.utils'

-- Fonts
local fontScale = 7
local default = love.graphics.getFont()
local pixelated = love.graphics.newFont(fontScale, "mono")
pixelated:setFilter("nearest")
love.graphics.setFont(pixelated)

FONTS = {
    default = default,
    pixelated = pixelated,
    -- C:\Users\Nick\Documents\MyProjects\love-breaker\assets\fonts\Robotic_Rancor.ttf
    robotic = love.graphics.newFont('assets/fonts/Robotic_Rancor.ttf',fontScale)
}

ALIGNMENTS = {
    left = 'left',
    right = 'right',
    center = 'center',
}

-- Game states
GAME_SCENES = {
    game = require 'scenes.game',
    gameOver = require 'scenes.gameOver',
}