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
        self.player.currentAnimation.frame = 1
        self.player:changeState("idle")
    end

    if self.player.direction == "up" then
        self.hurtbox = Box(self.player.x + 10, self.player.y - 20, self.player.width - 20, 40)
    elseif self.player.direction == "left" then
        self.hurtbox = Box(self.player.x - 20, self.player.y + 20, 40, self.player.width - 20)
    elseif self.player.direction == "right" then
        self.hurtbox = Box(self.player.x + 10, self.player.y + 20, 40, self.player.width - 20)
    else
        self.hurtbox = Box(self.player.x + 10, self.player.y + 20, self.player.width - 20, 40)
    end

    for k, entity in pairs(self.player.room.entities) do
        if entity:collides(self.hurtbox) then
            table.remove(self.player.room.entities, k)
        end
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

    drawAnimation(animation, math.floor(self.player.x + self.player.offsetX), self.player.y)
    love.graphics.draw(gTextures[animation.texture]["dagger"], gFrames[animation.texture]["dagger"][animation:getCurrentFrame()], 
            math.floor(self.player.offsetX + self.player.x), math.floor(self.player.y))
end