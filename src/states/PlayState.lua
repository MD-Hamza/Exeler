PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player{
        x = (VIRTUAL_WIDTH / 2 - 16),
        y = (VIRTUAL_HEIGHT / 2 - 24),
        width = 32,
        height = 48,
        texture = "character",
        animations = ENTITY_DEFS["player"].animations,
    }

    self.room = Room{
        mapHeight = 58, 
        mapWidth = 72, 
        player = self.player}
    
    self.player.map = GameLevel(self.room.tiles, self.room.mapWidth, self.room.mapHeight, self.room.startX, self.room.startY)

    self.player.StateMachine = StateMachine{
        ["idle"] = function() return PlayerIdleState(self.player) end,
        ["walk"] = function() return PlayerWalkState(self.player) end,
        ["sword"] = function() return PlayerSwordState(self.player) end
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
    love.graphics.translate(math.floor(self.camX), math.floor(self.camY))
    self.room:render()
    self.player:render()
end

function PlayState:updateCamera()
    self.camX = (VIRTUAL_WIDTH / 2 - 16) - self.player.x 
    self.camY = (VIRTUAL_HEIGHT / 2 - 24) - self.player.y
end