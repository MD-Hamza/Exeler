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

    if wasPressed("b") then
        self.player:changeState("bow")
    end

    if (wasPressed("return")) then
        self.player.y = self.player.y - 1
        for k, object in pairs(self.entity.room.gameObjects) do
            if self.player:collides(object) then
                self.player.x = object.x - 8
                self.player:changeState("text", {
                    text = "This is skeleton shooting range, defeat the skeletons within sixty seconds to recieve a piece of Exeler. These skeletons are trained to dodge arrows and you can shoot arrows every one second. Good Luck.", 
                    enterCounter = 1,
                    nextState = "skeletonShooting"
                })
            end
        end
        self.player.y = self.player.y + 1
    end
    --self.player.hitBox = HitBox(self.player.x, self.player.y + self.player.height/2, self.player.width, self.player.height)
end

function PlayerIdleState:render()
    local animation = self.player.currentAnimation
    drawAnimation(animation, math.floor(self.player.x), math.floor(self.player.y))
end