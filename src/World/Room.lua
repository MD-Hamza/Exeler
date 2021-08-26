Room = Class{}

function Room:init(playState)
    self.playState = playState

    self.layerOne = {}
    self.layerTwo = {}

    self:generatefloor(16, 16)

    self.map = TileMap(self.layerOne, self.layerTwo)

    self.entities = {}
    --self:generateEntities()

    self.gameObjects = {}
    self.teleporters = {}
    self:generateObjects()

    self.NPCs = {}

    self.spawnedCliffSkeletons = false
    self.collectedWater = false

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
        y = 1360,
        width = 32,
        height = 48,
        texture = "character",
        animations = ENTITY_DEFS["player"].animations,
    }, self.player, "It seems my garden hasnt gotten enough water lately. Can you traverse up the cliff and get some. My garden isnt ordinary you too have much to gain.", 
        2, "water", {
        robe = "robe",
        torso = "purple-jacket",
        belt = "belt",
        head = "hair",
    })
    
    gardenNPC.action = function()
        gardenNPC:changeAnimation("right")
        Timer.tween(0.5, {
            [gardenNPC] = {x = gardenNPC.x + 25}
        }):finish(function()
            gardenNPC:changeAnimation("idle-right")
        end)
    end
    gardenNPC.StateMachine = StateMachine{
        ["idle"] = function() return PlayerIdleState(gardenNPC) end,
        ["text"] = function() return DisplayTextState(gardenNPC) end,
        ["walk"] = function() return PlayerWalkState(gardenNPC) end
    }
    gardenNPC.direction = "left"
    gardenNPC.StateMachine:change("idle")
    table.insert(self.NPCs, gardenNPC)
end

function Room:generateEntities(xMin, xMax, yMin, yMax)
    for i = 1, 5 do
        local skeleton = Entity{
            x = math.random(xMin, xMax),
            y = math.random(yMin, yMax),
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

        --initializes a particle system with a particle and number of particles
        self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

        --Sets lifetime of particles from 2 - 3 seconds
        self.psystem:setParticleLifetime(2, 3)

        --gives it acceleration of anywhere between x1, y1 and x2, y2
        --generally upward acceleration
        self.psystem:setLinearAcceleration(-15, -10, 15, -25)

        --spread of particles; normal is more natural than uniform which is clumpy
        -- are amount of standard deviation from X and Y axis
        self.psystem:setEmissionArea('ellipse', 10, 10)
        
        self.psystem:setColors(
			0.65, 0.65, 0.65, 1, 
            0.65, 0.65, 0.65, 0
		)

	    self.psystem:emit(64)
        table.insert(self.entities, skeleton)
    end
end

function Room:generateObjects()
    table.insert(self.gameObjects, GameObject(
        GAME_OBJECT_DEFS["sign"], 1148, 1068
    ))

    local teleporter1 = Teleporter(1808, 1040, 1945, 540)
    table.insert(self.teleporters, teleporter1)

    local teleporter2 = Teleporter(3056, 432, 1737, 1212)
    table.insert(self.teleporters, teleporter2)

    local teleporter3 = Teleporter(2128, 1258, 2535, 534)
    table.insert(self.teleporters, teleporter3)

    local teleporter4 = Teleporter(1808, 1232, 3114, 407)
    table.insert(self.teleporters, teleporter4)
end

function Room:update(dt)
    -- if wasPressed("space") then
    --     print(self.player.x, self.player.y)
    -- end

    if self.quest == "water" then
        if self.player:collides(Box(900, 1100, 30, 60)) and not self.spawnedCliffSkeletons then
            self.spawnedCliffSkeletons = true
            self:generateEntities(760, 855, 1075, 1100)
        end

        if wasPressed("return") and not self.collectedWater then
            local tempX = self.player.x
            local tempY = self.player.y

            self.player.y = self.player.direction == "up" and self.player.y - 33 or self.player.y
            self.player.y = self.player.direction == "down" and self.player.y + 33 or self.player.y
            self.player.x = self.player.direction == "left" and self.player.x - 33 or self.player.x
            self.player.x = self.player.direction == "right" and self.player.x + self.player.width + 33 or self.player.x

            if self.map:pointToTile(self.player.x, self.player.y)[1].id == 284 then
                self.player.y = tempY
                self.player.x = tempX

                self.player:changeState("text", {
                    text = "Successfully collected water", 
                    enterCounter = 1,
                    nextState = "idle"
                })
                self.collectedWater = true    
            end

            self.player.y = tempY
            self.player.x = tempX
        end
    end

    for y = 1, #mapFrames do
        for x = 1, #mapFrames[y] do
            self.layerOne[y][x]:update(dt)
            self.layerTwo[y][x]:update(dt)
        end
    end

    for k, entity in pairs(self.entities) do
        if self.psystem then
            self.psystem:update(dt)
        end
        entity:update(dt)
        entity:processAI(dt)
        if entity:collides(Box(self.player.x + 5, self.player.y + 10, self.player.width - 10, self.player.height - 20)) and not self.player.invulnerable then
            self.player:damage(1)
            self.player:goInvulnerable(1)
        end
    end

    for k, teleporter in pairs(self.teleporters) do
        if self.player:collides(teleporter) then
            teleporter:teleport(self.player, self.playState)
        end
    end

    for k, NPC in pairs(self.NPCs) do
        NPC:update(dt)
        if NPC.talking then
            self.quest = NPC.quest
        end
    end

    for k, object in pairs(self.gameObjects) do
        object:update(dt)
        for i, entity in pairs(self.entities) do
            if entity:collides(Box(object.x - 20, object.y - 30, object.width + 40, object.height + 20)) then
                entity.walkSpeed = 400
                entity:changeState("walk")
                entity.direction = "right"
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

    if self.collectedWater then
        self.NPCs[1].text = "I see you have brought me water, now rise my plants.\n\nThere you see a piece of Exeler from my revived garden, its all yours. I sense you will be the one."
        if self.NPCs[1].talking then
            self.map.layerTwo[65][73].id = 1362
            self.map.layerTwo[65][72].id = 1362
            self.map.layerTwo[67][71].id = 1362
            self.map.layerTwo[67][72].id = 1362
            self.map.layerTwo[66][73].id = 1362
            self.map.layerTwo[66][72].id = 1362
            self.map.layerTwo[66][71].id = 1362

            self.map.layerTwo[58][71].id = 1362
            self.map.layerTwo[58][72].id = 1362
            self.map.layerTwo[60][73].id = 1362
            self.map.layerTwo[60][72].id = 1362
            self.map.layerTwo[59][73].id = 1362
            self.map.layerTwo[59][72].id = 1362
            self.map.layerTwo[59][71].id = 1362
            self.NPCs[1].action()
            self.collectedWater = false
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
        if self.psystem then
            love.graphics.draw(self.psystem, entity.x + 16, entity.y + 50)
        end
    end

    for k, NPC in pairs(self.NPCs) do
        NPC:render()
    end

    for k, object in pairs(self.gameObjects) do
        object:render()
    end

    for k, teleporter in pairs(self.teleporters) do
        teleporter:render()
    end
end