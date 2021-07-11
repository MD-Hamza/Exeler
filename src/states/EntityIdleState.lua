EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity
    self.entity:changeAnimation("idle-" .. tostring(self.entity.direction))

    self.timer = 0
    self.duration = math.random(3)
end

function EntityIdleState:processAI(dt)
    self.timer = self.timer + dt
	if self.timer >= self.duration then
		self.entity.StateMachine:change("walk")
	end
end

function EntityIdleState:render()
    local animation = self.entity.currentAnimation
    love.graphics.draw(gTextures[animation.texture], 
        gFrames[animation.texture][animation:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
end