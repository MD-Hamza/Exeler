PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.room = Room{
        mapHeight = 58, 
        mapWidth = 72}

    self.player = Player{
        x = (VIRTUAL_WIDTH / 2 - 16),
        y = (VIRTUAL_HEIGHT / 2 - 24),
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
    self.player.StateMachine = StateMachine{
        ["idle"] = function() return PlayerIdleState(self.player) end,
        ["walk"] = function() return PlayerWalkState(self.player) end,
        ["sword"] = function() return PlayerSwordState(self.player) end,
        ["bow"] = function() return PlayerBowState(self.player) end
    }
    self.player.StateMachine:change("idle")

    self.camX = 0
    self.camY = 0
end

function PlayState:update(dt)
    self.room:update(dt)
    self.player:update(dt)
    self:updateCamera()
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
            heartFrame = 1
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 5
        end

        love.graphics.draw(gTextures['objects'], gFrames['hearts'][heartFrame],
            (i - 1) * (16) + 5, 5)
        
        healthLeft = healthLeft - 2
    end
    
end

function PlayState:updateCamera()
    self.camX = (VIRTUAL_WIDTH / 2 - 16) - self.player.x 
    self.camY = (VIRTUAL_HEIGHT / 2 - 24) - self.player.y
end