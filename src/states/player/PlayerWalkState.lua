PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:enter()
    self.player = self.entity
end

function PlayerWalkState:update(dt)    
    if wasPressed("space") then
        self.player:changeState("sword")
    end
    
    if wasPressed("b") then
        self.player:changeState("bow")
    end

    EntityWalkState.update(self, dt)
end

function PlayerWalkState:render()
    if love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player:changeAnimation('left')
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player:changeAnimation('right')
    elseif love.keyboard.isDown('up') then
        self.player.direction = 'up'
        self.player:changeAnimation('up')
    elseif love.keyboard.isDown('down') then
        self.player.direction = 'down'
        self.player:changeAnimation('down')
    else
        self.player:changeState("idle")
    end
    
    local animation = self.player.currentAnimation
    if animation then
        drawAnimation(animation, math.floor(self.player.x), math.floor(self.player.y))
    end
end