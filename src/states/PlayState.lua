PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.room = Room(self)

    self.player = Player{
        x = 950,
        y = 1124,
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
    }
    self.player.StateMachine:change("idle")

    self.canUpdate = true
    self.camX = 0
    self.camY = 0
end

function PlayState:update(dt)
    if not self.canUpdate then
        return
    end

    self.player:update(dt)
    self.room:update(dt)
    self:updateCamera(dt)

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
    
end

function PlayState:updateCamera(dt)
    self.camX = (VIRTUAL_WIDTH / 2 - 16) - self.player.x 
    self.camY = (VIRTUAL_HEIGHT / 2 - 24) - self.player.y
end