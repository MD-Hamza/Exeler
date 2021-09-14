PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.room = Room(self)

    self.player = Player{
        x = 1000,
        y = 1375,
        width = 32,
        height = 48,
        texture = "character",
        animations = ENTITY_DEFS["player"].animations,
        walkSpeed = ENTITY_DEFS["player"].walkSpeed,
        map = self.room.map,
        room = self.room,
        health = 6,
    }

    self.room.player = self.player
    self.room:generateNPC()
    self.player.StateMachine = StateMachine{
        ["idle"] = function() return PlayerIdleState(self.player) end,
        ["walk"] = function() return PlayerWalkState(self.player) end,
        ["sword"] = function() return PlayerSwordState(self.player) end,
        ["bow"] = function() return PlayerBowState(self.player) end,
        ["text"] = function() return DisplayTextState(self.player) end,
        ["skeletonShooting"] = function() return SkeletonShootingRange(self.player) end,
        ["over"] = function() return GameOverState(self.player) end,
    }
    self.player.StateMachine:change("idle")
    self.player.StateMachine:change("text", {
        text = "Explore the world of Exeler to find and combine the three pieces of Exeler scattered across the map. Use space to use your sword and press b to shoot your bow, to interact with anything use enter. Good luck on your quest.", 
        enterCounter = 2,
        nextState = "idle"
    })

    self.canUpdate = true
    self.canRender = true
    self.camX = 0
    self.camY = 0
    self.opacity = 0

    Event.on('fade', function()
        Timer.tween(1, {
            [self] = {opacity = 1}
        }):finish(function()
            Event.dispatch("spawnNPC")
            Timer.tween(1, {
                [self] = {opacity = 0}
            })
        end)
    end)

    Event.on('death', function()
        Timer.tween(1, {
            [self] = {opacity = 1}
        }):finish(function()
            self.player.x = 1064
            self.player.y = 1060
            self.player.health = 6
            self.player:changeState("idle")
            self.player.direction = "down"
            Timer.tween(1, {
                [self] = {opacity = 0}
            })
        end)
    end)
end

function PlayState:update(dt)
    if not self.canUpdate then
        return
    end

    self.player:update(dt)
    self.room:update(dt)
    self:updateCamera(dt)

    if self.player.health <= 0 and self.opacity == 0 then
        self.player.StateMachine:change("over")
    end
    if wasPressed("b") then
        print(self.player.x, self.player.y)
    end
    if love.mouse.isDown(1) then
        local x, y = push:toGame(love.mouse.getPosition())
        print(x - self.camX, y - self.camY)
        print(self.room.map:pointToTile(x - self.camX, y - self.camY)[2].gridX, self.room.map:pointToTile(x - self.camX, y - self.camY)[2].gridY)
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(math.floor(self.camX), math.floor(self.camY))
    self.room:render()
    self.player:render()
    
    love.graphics.pop()

    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, 3 do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 7
        else
            heartFrame = 9
        end

        love.graphics.draw(gTextures['objects'], gFrames['objects'][heartFrame],
            (i - 1) * (16) + 5, 5)
        
        healthLeft = healthLeft - 2
    end
    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function PlayState:updateCamera(dt)
    self.camX = (VIRTUAL_WIDTH / 2 - 16) - self.player.x 
    self.camY = (VIRTUAL_HEIGHT / 2 - 24) - self.player.y
end