local Title = {
	layers = {}
}

function Title:enter(prev)
	-- UI - create main layer
	self.layers.main = Luis.newLayer('main')
	Luis.setCurrentLayer('main')

	local b_start = Luis.createElement('main', 'Button', 'START PLAYING', 8, 2, nil, function() GameState.switch(GAME_SCENES.game) end, 1, 1)
	local b_test = Luis.createElement('main', 'Button', 'TEST', 8, 2, nil, function() print 'pressed' end, 1, 1)

	local c_main = Luis.createElement('main', 'Container', 10, 7, 10, 16, false, false, nil, nil)
	c_main:addChild(b_start, 2, 2)
	c_main:addChild(b_test, 5, 2)
end

function Title:update(dt)
	TIME = TIME + dt
	if TIME >= 1 / 60 then
		Luis.flux.update(TIME)
		TIME = 0
	end
	Luis.update(dt)
end

function Title:draw()
	Luis:draw()
end

function Title:leave()
	Luis.disableLayer('main')
	Luis.removeLayer('main')
end

return Title
