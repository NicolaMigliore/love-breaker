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
local particles = {x=-137, y=62.5}

local image1 = LG.newImage("circle.png")
image1:setFilter("nearest", "nearest")
local image2 = LG.newImage("spiral.png")
image2:setFilter("nearest", "nearest")

local ps = LG.newParticleSystem(image1, 16)
ps:setColors(0.125, 0.109375, 0.109375, 1, 0.26171875, 0.17277526855469, 0.17277526855469, 1, 0.12969970703125, 0.14302730560303, 0.1953125, 0)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("ellipse", 50, 35, 0, false)
ps:setEmissionRate(500)
ps:setEmitterLifetime(0.029999999329448)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(1, 0.20000000298023)
ps:setSizeVariation(0.2172524034977)
ps:setSpeed(90, 100)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(2.9022331237793)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="alpha", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=0, y=0})

local ps = LG.newParticleSystem(image1, 5)
ps:setColors(1, 0, 0, 1, 0.92578125, 0.37214326858521, 0.15550231933594, 1, 1, 0.5546875, 0.5546875, 1, 0.75390625, 0.57472467422485, 0.23265075683594, 0.9140625)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("ellipse", 50, 35, 0, false)
ps:setEmissionRate(138.85339355469)
ps:setEmitterLifetime(0.029999999329448)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.69999998807907, 0.20000000298023)
ps:setSizeVariation(0.2172524034977)
ps:setSpeed(90, 100)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(2.9022331237793)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="alpha", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=0, y=0})

local ps = LG.newParticleSystem(image2, 5)
ps:setColors(0, 0, 0, 1, 0, 0, 0, 1)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(138.85339355469)
ps:setEmitterLifetime(0.029999999329448)
ps:setInsertMode("top")
ps:setLinearAcceleration(-512, 772, 441.41513061523, 1103)
ps:setLinearDamping(0.70999997854233, 0.70999997854233)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(703, 703)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(1, 0.029999999329448)
ps:setSizeVariation(0.2172524034977)
ps:setSpeed(90, 100)
ps:setSpin(-6.7854218482971, 1.7860153913498)
ps:setSpinVariation(0.5)
ps:setSpread(2.9022331237793)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="alpha", shader=nil, texturePath="spiral.png", texturePreset="spiral", shaderPath="", shaderFilename="", x=0, y=0})

return particles
