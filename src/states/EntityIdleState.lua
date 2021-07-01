EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity
    self.entity:changeAnimation("idle-" .. tostring(self.entity.direction))
end

function EntityIdleState:render()
    local animation = self.entity.currentAnimation
    if animation then
        love.graphics.draw(gTextures[animation.texture], 
            gFrames[animation.texture][animation:getCurrentFrame()], self.entity.x, self.entity.y)
    end
end