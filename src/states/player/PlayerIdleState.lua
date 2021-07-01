PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter()
    self.player = self.entity
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or 
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.player:changeState("walk")
    end

    if wasPressed("space") then
        self.player:changeState("sword")
    end

    --self.player.hitBox = HitBox(self.player.x, self.player.y + self.player.height/2, self.player.width, self.player.height)
end

function PlayerIdleState:render()
    local animation = self.entity.currentAnimation
    if animation then
        drawAnimation(animation, self.entity.x, self.entity.y)
    end
end