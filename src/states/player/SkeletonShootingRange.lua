SkeletonShootingRange = Class{__includes = BaseState}

function SkeletonShootingRange:init(player)
    self.player = player
    
    self.camX = 0
    self.camY = 0
    self.start = false
    self.angle = math.pi / 2
    self.cooldown = 0

    self.player:changeAnimation("right")
    Timer.tween(1, {
        [self.player] = {x = self.player.x + 35}
    }):finish(function()
        self.player:changeAnimation("up")
        Timer.tween(1, {
            [self.player] = {y = self.player.y - VIRTUAL_HEIGHT / 2 + 35},
            [self] = {camY = VIRTUAL_HEIGHT / 2 - 55}
        }):finish(function()
            self.player:changeAnimation("bow-up")
            self.start = true
            self.player.offsetX = -17
            self.player.offsetY = -12
            self.timer = 60
            self.endX = self.player.x + 16
            self.endY = self.player.y - 125
            self.player.room.entities = {}
            for y = 0, 2 do
                for x = 0, 4 do
                    local skeleton = Entity{
                        x = self.player.x + (100 * (x - 2)),
                        y = self.player.y - 100 + (65 * y),
                        width = 32,
                        height = 48,
                        texture = "skeleton",
                        animations = ENTITY_DEFS["skeleton"].animations,
                        walkSpeed = ENTITY_DEFS["skeleton"].walkSpeed,
                        map = self.player.map
                    }
            
                    skeleton.StateMachine = StateMachine{
                        ["idle"] = function() return EntityIdleState(skeleton) end,
                        ["walk"] = function() return EntityWalkState(skeleton, {"left", "right"}) end
                    }
                    skeleton.StateMachine:change("idle")
            
                    table.insert(self.player.room.entities, skeleton)
                end
            end
        end)
    end)
end

function SkeletonShootingRange:update(dt)
    if self.start then
        self.timer = self.timer - dt

        if (#self.player.room.entities == 0) then
            if not self.player.pieces["yellow"] then
                table.insert(self.player.room.gameObjects, GameObject(GAME_OBJECT_DEFS["yellow"], 2290, 1850))
                self.start = false
                Timer.after(2, function()
                    Timer.tween(1, {
                        [self.player.room.gameObjects[#self.player.room.gameObjects]] = {y = self.player.y * 2 + VIRTUAL_HEIGHT / 2}
                    }):finish(function()
                        table.remove(self.player.room.gameObjects)
                        self.player:changeAnimation("idle-up")
                        self.player.y = self.player.y - 35 + VIRTUAL_HEIGHT / 2
                        self.player:changeState("text", {
                            text = "You received a piece of Exeler",
                            enterCounter = 1,
                            nextState = "idle"
                        })
                        self.player.pieces["yellow"] = true
                    end)
                end)
            else
                self.player:changeAnimation("idle-up")
                self.player.y = self.player.y - 35 + VIRTUAL_HEIGHT / 2
                self.player:changeState("text", {
                    text = "Youve defeated all the skeletons",
                    enterCounter = 1,
                    nextState = "idle"
                })
            end
        end
        if wasPressed("space") and self.cooldown > 1 then
            local arrow = Arrow{
                x = self.player.x,
                y = self.player.y + 125,
                direction = self.angle,
                width = 8,
                height = 8
            }
            table.insert(self.player.room.gameObjects, arrow)
            self.cooldown = 0
        end
    end

    self.cooldown = self.cooldown + dt

    if love.keyboard.isDown("left") then
        self.angle = math.min(8 * math.pi / 9, self.angle + 3 * math.pi / 180)
    elseif love.keyboard.isDown("right") then
        self.angle = math.max(math.pi / 9, self.angle - 3 * math.pi / 180)
    end
    self.endY = -135 * math.sin(self.angle) + self.player.y + 10
    self.endX = 135 * math.cos(self.angle) + self.player.x + 16
    self.player.invulnerable = true

    if self.start and self.timer <= 0 then
        self.player:changeAnimation("idle-up")
        self.player.y = self.player.y - 35 + VIRTUAL_HEIGHT / 2
        self.player.room.entities = {}
        self.player:changeState("text", {
            text = "Try again",
            enterCounter = 1,
            nextState = "idle"
        })
    end
end

function SkeletonShootingRange:render()
    love.graphics.push()
    love.graphics.translate(math.floor(self.camX), math.floor(self.camY))

    if self.start then
        love.graphics.line(self.player.x + 16, self.player.y + 10, self.endX, self.endY)
    end
    love.graphics.pop()
    for k, object in pairs(self.player.room.gameObjects) do  
        object:render()
    end
    love.graphics.push()
    love.graphics.translate(math.floor(self.camX), math.floor(self.camY))
    local animation = self.player.currentAnimation
    drawAnimation(animation, math.floor(self.player.x + self.player.offsetX), 
        math.floor(self.player.y + self.player.offsetY))

    if self.timer then
        love.graphics.setFont(gFonts["basic-small"])
        love.graphics.printf(tostring(math.floor(self.timer)), self.player.x - VIRTUAL_WIDTH / 2, 
            self.player.y - VIRTUAL_HEIGHT + 80, VIRTUAL_WIDTH, "right")
    end
    love.graphics.pop()
end