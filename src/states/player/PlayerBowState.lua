PlayerBowState = Class{__includes = BaseState}

function PlayerBowState:init(player)
    self.player = player
    self.player.offsetX = -17
    self.player.offsetY = -12
    self.fire = false

    if self.player.direction == 'left' then
        self.player:changeAnimation('bow-left')
    elseif self.player.direction == 'right' then
        self.player:changeAnimation('bow-right')
    elseif self.player.direction == 'up' then
        self.player:changeAnimation('bow-up')
    elseif self.player.direction == 'down' then
        self.player:changeAnimation('bow-down')
    end
end

function PlayerBowState:update(dt)
    if not love.keyboard.isDown("b") and self.player.currentAnimation.timesPlayed >= 1 then
        if not self.fire then
            self.fire = true
            self.arrow = Arrow{
                x = self.player.x,
                y = self.player.y,
                direction = self.player.direction,
                width = 8,
                height = 8
            }
            table.insert(self.player.room.gameObjects, self.arrow)
        end

        if self.player.direction == 'left' then
            self.player:changeAnimation('fire-left')
        elseif self.player.direction == 'right' then
            self.player:changeAnimation('fire-right')
        elseif self.player.direction == 'up' then
            self.player:changeAnimation('fire-up')
        elseif self.player.direction == 'down' then
            self.player:changeAnimation('fire-down')
        end
        
        if self.player.currentAnimation.timesPlayed >= 1 then
            self.player.animations["bow-" .. self.player.direction].timesPlayed = 0
            self.player.currentAnimation.timesPlayed = 0

            --Resets the frame number so when animation starts again it starts from the beginning
            self.player.animations["bow-" .. self.player.direction].frame = 1
            self.player.currentAnimation.frame = 1
            self.player:changeState("idle")
        end
    elseif self.player.currentAnimation.timesPlayed >= 1 and not self.fire then
        if love.keyboard.isDown('left') then
            self.player.currentAnimation.frame = 1
            self.player.currentAnimation.timesPlayed = 0

            self.player.direction = 'left'
            self.player:changeAnimation('bow-left')

            self.player.currentAnimation.frame = #self.player.currentAnimation.frames
            self.player.currentAnimation.timesPlayed = 1
        elseif love.keyboard.isDown('right') then
            self.player.currentAnimation.frame = 1
            self.player.currentAnimation.timesPlayed = 0

            self.player.direction = 'right'
            self.player:changeAnimation('bow-right')

            self.player.currentAnimation.frame = #self.player.currentAnimation.frames
            self.player.currentAnimation.timesPlayed = 1
        elseif love.keyboard.isDown('up') then
            self.player.currentAnimation.frame = 1
            self.player.currentAnimation.timesPlayed = 0
            
            self.player.direction = 'up'
            self.player:changeAnimation('bow-up')

            self.player.currentAnimation.frame = #self.player.currentAnimation.frames
            self.player.currentAnimation.timesPlayed = 1
        elseif love.keyboard.isDown('down') then
            self.player.currentAnimation.frame = 1
            self.player.currentAnimation.timesPlayed = 0

            self.player.direction = 'down'
            self.player:changeAnimation('bow-down')

            self.player.currentAnimation.frame = #self.player.currentAnimation.frames
            self.player.currentAnimation.timesPlayed = 1
        end
    end
end

function PlayerBowState:render()
    local animation = self.player.currentAnimation
    drawAnimation(animation, math.floor(self.player.x + self.player.offsetX), math.floor(self.player.offsetY + self.player.y))
    love.graphics.draw(gTextures[animation.texture]["bow"], gFrames[animation.texture]["bow"][animation:getCurrentFrame()], 
            math.floor(self.player.offsetX + self.player.x), math.floor(self.player.offsetY + self.player.y))
    if not self.fire then
        love.graphics.draw(gTextures[animation.texture]["arrow"], gFrames[animation.texture]["arrow"][animation:getCurrentFrame()], 
                math.floor(self.player.offsetX + self.player.x), math.floor(self.player.offsetY + self.player.y))
    end
end