
-- Load libraries
Camera = require 'libs.hump.camera'
GameState = require 'libs.hump.gamestate'
Vector = require 'libs.hump.vector'
Object = require 'libs.classic'
Husl = require 'libs.husl'
Inspect = require 'libs.inspect'
Lume = require 'libs.lume'
Push = require 'libs.push'
Baton = require 'libs.baton'
Utils = require 'libs.utils'

local initLuis = require 'luis.init'
Luis = initLuis("luis/widgets")
Luis.flux = require("luis.3rdparty.flux")

-- Settings
FIXED_WIDTH = 360
FIXED_HEIGHT = 360

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
    robotic = love.graphics.newFont('assets/fonts/Robotic_Rancor.ttf',fontScale),
    robotic_l = love.graphics.newFont('assets/fonts/Robotic_Rancor.ttf',fontScale*2),
}

ALIGNMENTS = {
    left = 'left',
    right = 'right',
    center = 'center',
}

-- Game states
GAME_SCENES = {
    title = require 'scenes.title',
    game = require 'scenes.game',
    gameOver = require 'scenes.gameOver',
}

TIME = 0