--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
local particles = {x=0, y=0}

local image1 = LG.newImage("circle.png")
image1:setFilter("nearest", "nearest")

local ps = LG.newParticleSystem(image1, 14)
ps:setColors(0.98000001907349, 0.76309335231781, 0.16660000383854, 1, 0.98000001907349, 0.41944000124931, 0.11760000139475, 1, 0.68000000715256, 0.13600000739098, 0.20853333175182, 1, 0.68000000715256, 0.13600000739098, 0.20853333175182, 0.25)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("normal", 2.5, 2.5, 0, false)
ps:setEmissionRate(25)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.15000000596046, 0.5)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.090000003576279, 0.029999999329448)
ps:setSizeVariation(0.25)
ps:setSpeed(50, 75)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.78539818525314)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="add", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=0, y=0})

return particles
