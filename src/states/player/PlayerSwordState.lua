PlayerSwordState = Class{__includes = BaseState}

function PlayerSwordState:init(player)
    self.player = player
    self.player.offsetX = -17
    self.player.offsetY = 0
end

function PlayerSwordState:update(dt)
    if wasPressed('space') then
        self.player:changeState("sword")
    end

    if self.player.currentAnimation.timesPlayed >= 1 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState("idle")
    end
end

function PlayerSwordState:render()
    if self.player.direction == 'left' then
        self.player:changeAnimation('slash-left')
    elseif self.player.direction == 'right' then
        self.player:changeAnimation('slash-right')
    elseif self.player.direction == 'up' then
        self.player:changeAnimation('slash-up')
    elseif self.player.direction == 'down' then
        self.player:changeAnimation('slash-down')
    end

    local animation = self.player.currentAnimation
    if animation then
        drawAnimation(animation, math.floor(self.player.x + self.player.offsetX), self.player.y)
        love.graphics.draw(gTextures[animation.texture]["dagger"], gFrames[animation.texture]["dagger"][animation:getCurrentFrame()], 
                math.floor(self.player.offsetX + self.player.x), self.player.y)
    end
end