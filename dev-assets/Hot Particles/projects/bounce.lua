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
local particles = {x=16, y=-28.1875}

local image1 = LG.newImage("circle.png")
image1:setFilter("nearest", "nearest")

local ps = LG.newParticleSystem(image1, 5)
ps:setColors(0.26953125, 0.22215270996094, 0.22215270996094, 1, 0.331298828125, 0.33332443237305, 0.4609375, 1, 0.72265625, 0.72265625, 0.72265625, 0.3984375)
ps:setDirection(0)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(11.27397441864, 20)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(0, 139.73808288574)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.050000000745058, 0.20000000298023)
ps:setSizeVariation(0.75079870223999)
ps:setSpeed(25.00790977478, 383.16201782227)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.69813168048859)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=128, kickStartDt=0.0062500000931323, emitAtStart=5, blendMode="alpha", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=15, y=0})

local ps = LG.newParticleSystem(image1, 5)
ps:setColors(0.26953125, 0.22215270996094, 0.22215270996094, 1, 0.331298828125, 0.33332443237305, 0.4609375, 1, 0.72265625, 0.72265625, 0.72265625, 0.3984375)
ps:setDirection(-3.1415927410126)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(11.27397441864, 20)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(0, 139.73808288574)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.050000000745058, 0.20000000298023)
ps:setSizeVariation(0.75079870223999)
ps:setSpeed(25.00790977478, 383.16201782227)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.69813168048859)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=128, kickStartDt=0.0062500000931323, emitAtStart=5, blendMode="alpha", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=-15, y=0})

return particles
