Room = Class{}

function Room:init()
    self.layerOne = {}
    self.layerTwo = {}

    self:generatefloor(16, 16)

    self.map = TileMap(self.layerOne, self.layerTwo)

    self.entities = {}
    --self:generateEntities()

    self.gameObjects = {}
    self:generateObjects()

    self.NPCs = {}
end

function Room:generatefloor(width, height)
    for y = 1, #mapFrames do
        table.insert(self.layerOne, {})
        table.insert(self.layerTwo, {})
        for x = 1, #mapFrames[y] do
            local id = mapFrames[y][x]
            table.insert(self.layerOne[y], Tile{
                x = (width * (x - 1)),
                y = (width * (y - 1)),
                width = width,
                height = height,
                type = "overworld",
                id = id,
                interval = interval,
                gridX = x,
                gridY = y
            })
            
            for k, tile in pairs(COLLIDABLE_TOP) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "up"
                end
            end
            for k, tile in pairs(COLLIDABLE_LEFT) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "left"
                end
            end
            for k, tile in pairs(COLLIDABLE_RIGHT) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "right"
                end
            end
            for k, tile in pairs(COLLIDABLE_BOTTOM) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "down"
                end
            end

            id = mapLayerOne[y][x]
            table.insert(self.layerTwo[y], Tile{
                x = (width * (x - 1)),
                y = (width * (y - 1)),
                width = width,
                height = height,
                type = "overworld",
                id = id,
                interval = interval,
                gridX = x,
                gridY = y
            })
            for k, tile in pairs(COLLIDABLE_TOP) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "up"
                end
            end
            for k, tile in pairs(COLLIDABLE_LEFT) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "left"
                end
            end
            for k, tile in pairs(COLLIDABLE_RIGHT) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "right"
                end
            end
            for k, tile in pairs(COLLIDABLE_BOTTOM) do
                if tile == id then
                    self.layerOne[y][x].collsionSide = "down"
                end
            end
        end
    end
end

function Room:generateNPC()
    local gardenNPC = NPC({
        x = 1100,
        y = 960,
        width = 32,
        height = 48,
        texture = "character",
        animations = ENTITY_DEFS["player"].animations,
    }, self.player, "It seems my garden hasnt gotten enough water lately. Can you traverse up the cliff and get some. My garden isnt ordinary you too have much to gain.", 1)
    
    gardenNPC.StateMachine = StateMachine{
        ["idle"] = function() return PlayerIdleState(gardenNPC) end,
        ["text"] = function() return DisplayTextState(gardenNPC) end,
    }
    gardenNPC.direction = "left"
    gardenNPC.StateMachine:change("idle")
    table.insert(self.NPCs, gardenNPC)
end

function Room:generateEntities()
    for i = 1, 7 do
        local skeleton = Entity{
            x = math.random(VIRTUAL_WIDTH / 2 - 142, VIRTUAL_WIDTH / 2 + 142),
            y = math.random(VIRTUAL_HEIGHT/ 2 - 148, VIRTUAL_HEIGHT/ 2 + 148),
            width = 32,
            height = 48,
            texture = "skeleton",
            animations = ENTITY_DEFS["skeleton"].animations,
            walkSpeed = ENTITY_DEFS["skeleton"].walkSpeed,
            map = self.map
        }

        skeleton.StateMachine = StateMachine{
            ["idle"] = function() return EntityIdleState(skeleton) end,
            ["walk"] = function() return EntityWalkState(skeleton) end
        }
        skeleton.StateMachine:change("idle")

        table.insert(self.entities, skeleton)
    end
end

function Room:generateObjects()
    table.insert(self.gameObjects, GameObject(
        GAME_OBJECT_DEFS["sign"], 1148, 668
    ))
end

function Room:update(dt)
    for y = 1, #mapFrames do
        for x = 1, #mapFrames[y] do
            self.layerOne[y][x]:update(dt)
            self.layerTwo[y][x]:update(dt)
        end
    end

    for k, entity in pairs(self.entities) do
        entity:update(dt)
        entity:processAI(dt)
        if entity:collides(Box(self.player.x + 5, self.player.y + 10, self.player.width - 10, self.player.height - 20)) and not self.player.invulnerable then
            self.player:damage(1)
            self.player:goInvulnerable(1)
        end
    end

    for k, NPC in pairs(self.NPCs) do
        NPC:update(dt)
    end

    for k, object in pairs(self.gameObjects) do
        object:update(dt)
        for i, entity in pairs(self.entities) do
            -- if entity:collides(Box(object.x - 50, object.y, object.width + 50, object.height)) then
            --     entity:changeState("idle")
            -- end
            if entity:collides(Box(object.x - 20, object.y - 30, object.width + 40, object.height + 20)) then
                entity.walkSpeed = 400
                entity:changeState("walk")
                entity.direction = entity.x < 1170 and "right" or "left"
                Timer.after(0.5, function()
                    entity.walkSpeed = 160
                end)
            end
            if object:collides(entity) and object.deadly then
                table.remove(self.entities, i)
                table.remove(self.gameObjects, k)
            elseif object:collides(entity) then
                if object.solid then
                    if entity.direction == 'left' then
						entity.x = object.x + object.width + 1
					elseif entity.direction == 'right' then
						entity.x = object.x - entity.width - 1
					elseif entity.direction == 'up' then
						entity.y = object.y + object.height - entity.height / 2 + 1
					elseif entity.direction == 'down' then
						entity.y = object.y  - entity.height - 1
					end
                end
            end
        end
        if self.player:collides(object) then
            if object.solid then
                if self.player.direction == 'left' then
                    self.player.x = object.x + object.width + 1
                elseif self.player.direction == 'right' then
                    self.player.x = object.x - self.player.width - 1
                elseif self.player.direction == 'up' then
                    self.player.y = object.y + object.height - self.player.height / 2 + 1
                elseif self.player.direction == 'down' then
                    self.player.y = object.y  - self.player.height - 1
                end
            end
        end
    end
end

function Room:render()
    for y = 1, #mapFrames do
        for x = 1, #mapFrames[y] do
            self.layerOne[y][x]:render()
            self.layerTwo[y][x]:render()
        end
    end

    for k, entity in pairs(self.entities) do
        entity:render()
    end

    for k, NPC in pairs(self.NPCs) do
        NPC:render()
    end

    for k, object in pairs(self.gameObjects) do
        object:render()
    end
    
end