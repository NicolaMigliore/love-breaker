-- Load libraries
Camera = require 'libs.hump.camera'
GameState = require 'libs.hump.gamestate'
Vector = require 'libs.hump.vector'
Timer = require 'libs.hump.timer'
Object = require 'libs.classic'
Husl = require 'libs.husl'
Inspect = require 'libs.inspect'
Lume = require 'libs.lume'
Push = require 'libs.push'
Baton = require 'libs.baton'
Flux = require 'libs.flux'
Utils = require 'libs.utils'
Shack = require 'libs.shack'

local initLuis = require 'luis.init'
Luis = initLuis("luis/widgets")
Luis.flux = require("luis.3rdparty.flux")

-- Settings
SCALE = 2
FIXED_WIDTH = 360 * SCALE
FIXED_HEIGHT = 360 * SCALE

-- Fonts
local fontScale = 7 * SCALE
local default = love.graphics.getFont()
local pixelated = love.graphics.newFont(fontScale, "mono")
pixelated:setFilter("nearest")
love.graphics.setFont(pixelated)

FONTS = {
	default = default,
	pixelated = pixelated,
	-- C:\Users\Nick\Documents\MyProjects\love-breaker\assets\fonts\Robotic_Rancor.ttf
	robotic = love.graphics.newFont('assets/fonts/Robotic_Rancor.ttf', fontScale),
	robotic_l = love.graphics.newFont('assets/fonts/Robotic_Rancor.ttf', fontScale * 2),
}

ALIGNMENTS = {
	left = 'left',
	right = 'right',
	center = 'center',
}

PALETTE = {
	black = { .07, .07, .09, 1 },
	grey = Utils.hexToRGB('625565'),
	white = Utils.hexToRGB('c7dcd0'),
	orange_1 = Utils.hexToRGB('f9c22b'),
	orange_2 = Utils.hexToRGB('f79617'),
	orange_3 = Utils.hexToRGB('fb6b1d'),
	red_1 = Utils.hexToRGB('f04f78'),
	red_2 = Utils.hexToRGB('c32454'),
	red_3 = Utils.hexToRGB('831c5d'),
	green_1 = Utils.hexToRGB('8ff8e2'),
	green_2 = Utils.hexToRGB('30e1b9'),
	green_3 = Utils.hexToRGB('0b8a8f'),
	blue_1 = Utils.hexToRGB('8fd3ff'),
	blue_2 = Utils.hexToRGB('4d9be6'),
	blue_3 = Utils.hexToRGB('4d65b4'),
}

THEMES = {
	basic = require 'assets.themes.basic'
}

STYLES = {
	default = 'default',
	basic = 'basic',
	textured = 'textured',
	neon = 'neon',
}

-- Game states
GAME_SCENES = {
	title = require 'scenes.title',
	game = require 'scenes.game',
	gameOver = require 'scenes.gameOver',
	pause = require 'scenes.pause',
}

SHADERS = {
	BlurShader = love.graphics.newShader('shaders/gausianBlur.fs'),
	PerspectiveShader = love.graphics.newShader('shaders/perspective.fs', 'shaders/perspective.vs')
}

TIME = 0
