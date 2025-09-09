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
ps:setColors(0.26953125, 0.22215270996094, 0.22215270996094, 1, 0.331298828125, 0.33332443237305, 0.4609375, 1, 0.72265625, 0.72265625, 0.72265625, 0.3984375)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(500)
ps:setEmitterLifetime(0.029999999329448)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(11.27397441864, 20)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.30000001192093, 0.80000001192093)
ps:setRadialAcceleration(0, 1024)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.25, 1.25)
ps:setSizeVariation(0.75079870223999)
ps:setSpeed(25.00790977478, 91.641235351563)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(3.1415927410126)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="alpha", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=0, y=0})

return particles
