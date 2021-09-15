PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter()
    self.player = self.entity
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left', 'down', 'right', 'left', 'w', 'a', 's', 'd') then
            self.player:changeState("walk")
    end

    if wasPressed("space") then
        self.player:changeState("sword")
    end

    if wasPressed("b") then
        self.player:changeState("bow")
    end

    if (wasPressed("return")) then
        self.player.y = self.player.y - 1
        for k, object in pairs(self.entity.room.gameObjects) do
            if self.player:collides(object) and object.type == "sign" then
                object.onCollide()
            end
        end
        self.player.y = self.player.y + 1
    end
end

function PlayerIdleState:render()
    local animation = self.player.currentAnimation
    drawAnimation(animation, math.floor(self.player.x), math.floor(self.player.y))
end