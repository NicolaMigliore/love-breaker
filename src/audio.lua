local Audio = Object:extend()

function Audio:new()
	self.sfx = {}
	self.music = {}
end

function Audio:loadSfx()
	self.sfx = {
		click = love.audio.newSource('assets/sfx/click.wav', 'static'),
		slide = love.audio.newSource('assets/sfx/slide_open.wav', 'static'),
		bounce_0 = love.audio.newSource('assets/sfx/bounce_0.wav', 'static'),
		bounce_1 = love.audio.newSource('assets/sfx/bounce_1.wav', 'static'),
		bounce_2 = love.audio.newSource('assets/sfx/bounce_2.wav', 'static'),
		bounce_3 = love.audio.newSource('assets/sfx/bounce_3.wav', 'static'),
		fail = love.audio.newSource('assets/sfx/fail.wav', 'static'),
		powerup = love.audio.newSource('assets/sfx/powerup.wav', 'static'),
		expl_wind = love.audio.newSource('assets/sfx/explosion_wind.wav', 'static'),
		explosion = love.audio.newSource('assets/sfx/fail.wav', 'static'),
	}
	self:setVolume()
end

function Audio:setVolume()
	-- set volume
	for k, sfx in pairs(self.sfx) do
		sfx:setVolume(GAME_SETTINGS.volumeSfx)
	end
end

return Audio
