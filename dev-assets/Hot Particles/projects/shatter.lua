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

local ps = LG.newParticleSystem(image1, 16)
ps:setColors(1, 1, 1, 0.5, 1, 1, 1, 1, 1, 1, 1, 0)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("normal", 10, 5, 0, false)
ps:setEmissionRate(500)
ps:setEmitterLifetime(0.029999999329448)
ps:setInsertMode("top")
ps:setLinearAcceleration(-512, 772.13201904297, 512, 1102.8488769531)
ps:setLinearDamping(0.71063297986984, 0.71063297986984)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(703.181640625, 703.181640625)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.050000000745058, 0.11999999731779)
ps:setSizeVariation(0.5)
ps:setSpeed(90, 100)
ps:setSpin(1.256637096405, 0)
ps:setSpinVariation(0.30000001192093)
ps:setSpread(0.31415927410126)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="add", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=0, y=0})

return particles
