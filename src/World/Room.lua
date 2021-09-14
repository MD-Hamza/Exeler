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
    self.renderWholeMap = false

    Event.on("spawnNPC", function()
        self.player:changeState("text", {
            text = "Were free, youve assembled the pieces of Exeler and restored balance to our village. We were trapped inside these pieces and roamed around as skeletons but now that the world is free balance is restored.",
            enterCounter = 2,
            nextState = "idle",
        })
        for x = 550, 800, 50 do
            local heads = {"head", "hood", "hair", "armoured-hat", "leather-hat", "helmet"}
            local torsos = {"purple-jacket", "torso", "chain", "bracer", "white", "leather-torso"}
            local belts = {"belt", "rope"}
            local robes = {"robe", "armoured-legs"}
            local NPC = NPC({
                x = x,
                y = 1080,
                width = 32,
                height = 48,
                texture = "character",
                animations = ENTITY_DEFS["player"].animations,
            }, self.player, "Thanks for freeing us", 
                1, "", {
                robe = robes[math.random(#robes)],
                torso = torsos[math.random(#torsos)],
                belt = belts[math.random(#belts)],
                head = heads[math.random(#heads)],
            })

            NPC.StateMachine = StateMachine{
                ["idle"] = function() return PlayerIdleState(NPC) end,
                ["text"] = function() return DisplayTextState(NPC) end,
                ["walk"] = function() return PlayerWalkState(NPC) end
            }
            NPC.direction = "up"
            NPC.StateMachine:change("idle")

            table.insert(self.NPCs, NPC)
        end
    end)
end

function Room:generatefloor(width, height)
    for y = 1, #mapFrames do
        table.insert(self.layerOne, {})
        table.insert(self.layerTwo, {})
        for x = 1, #mapFrames[1] do
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

    local mazeNPC = NPC({
        x = 3500,
        y = 730,
        width = 32,
        height = 48,
        texture = "character",
        animations = ENTITY_DEFS["player"].animations,
    }, self.player, "You have done well to have finished the maze so tell me how many teleporters are in the maze. If you answer correctly youll be closer to completing your quest, so tell me", 
        2, "maze", {
        robe = "robe",
        torso = "purple-jacket",
        belt = "belt",
        head = "hood",
    }, "text", {
        text = "",
        enterCounter = 1,
        nextState = "idle",
        input = true
    })
    mazeNPC.StateMachine = StateMachine{
        ["idle"] = function() return PlayerIdleState(mazeNPC) end,
        ["text"] = function() return DisplayTextState(mazeNPC) end,
        ["walk"] = function() return PlayerWalkState(mazeNPC) end
    }
    mazeNPC.direction = "left"
    mazeNPC.StateMachine:change("idle")
    
    table.insert(self.NPCs, mazeNPC)
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
    local sign1 = GameObject(
        GAME_OBJECT_DEFS["sign"], 1148, 1068
    )
    sign1.onCollide = function()
        self.player.x = sign1.x - 8
        self.player:changeState("text", {
            text = "This is skeleton shooting range, defeat the skeletons within sixty seconds to recieve a piece of Exeler. These skeletons are trained to dodge arrows and you can shoot arrows every one second. Press space to shoot arrows, good Luck.", 
            enterCounter = 3,
            nextState = "skeletonShooting"
        })
    end

    table.insert(self.gameObjects, sign1)

    local sign2 = GameObject(
        GAME_OBJECT_DEFS["sign"], 655, 985
    )
    sign2.onCollide = function()
        self.player.x = sign2.x - 8
        local exeler = true
        for k, piece in pairs(self.player.pieces) do
            if not piece then
                exeler = false
            end
        end
        if not exeler then
            self.player:changeState("text", {
                text = "Come back here once you have collected the three pieces of Exeler", 
                enterCounter = 1,
                nextState = "idle"
            })
        elseif not self.player.restored then
            self.player.restored = true
            self.player:changeState("text", {
                text = "The pieces seem to be reacting with its surroundings", 
                enterCounter = 1,
                nextState = "idle",
                finish = function()
                    Event.dispatch("fade")
                end
            })
            table.insert(self.gameObjects, GameObject(GAME_OBJECT_DEFS["blue"], 1230, 1750))
            table.insert(self.gameObjects, GameObject(GAME_OBJECT_DEFS["yellow"], 1070, 1930))
            table.insert(self.gameObjects, GameObject(GAME_OBJECT_DEFS["purple"], 1390, 1930))
            
        end
    end

    table.insert(self.gameObjects, sign2)

    local teleporter1 = Teleporter(1808, 1040, 1945, 540)
    table.insert(self.teleporters, teleporter1)

    local teleporter2 = Teleporter(3056, 432, 1737, 1212)
    table.insert(self.teleporters, teleporter2)

    local teleporter3 = Teleporter(2128, 1258, 2535, 534)
    table.insert(self.teleporters, teleporter3)

    local teleporter4 = Teleporter(1808, 1232, 3114, 407)
    table.insert(self.teleporters, teleporter4)

    local teleporter5 = Teleporter(2680, 1072, 2122, 1082)
    table.insert(self.teleporters, teleporter5)
end

function Room:update(dt)
    -- if wasPressed("space") then
    --     print(self.player.x, self.player.y)
    -- end

    if self.quest == "water" then
        if self.player:collides(Box(900, 1500, 30, 60)) and not self.spawnedCliffSkeletons then
            self.spawnedCliffSkeletons = true
            self:generateEntities(760, 855, 1475, 1500)
        end

        if (wasPressed("return") or wasPressed("enter")) and not self.collectedWater then
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
        if object.type == "Exeler Piece" then
            object:updateExeler(dt)
        else
            object:update(dt)
        end

        for i, entity in pairs(self.entities) do
            if entity:collides(Box(object.x - 30, object.y - 40, object.width + 60, object.height + 40)) then
                entity.walkSpeed = 400
                entity:changeState("walk")

                if object.x < 1190 then
                    entity.direction = "right"
                else
                    entity.direction = "left"
                end

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
    
    if (wasPressed("return") or wasPressed("enter")) and self.player.StateMachine.current.result then
        if self.quest == "maze" then
            if self.player.StateMachine.current.result == '5' then
                self.player:changeState("text", {
                    text = "That is correct, your awareness of the surroundings has enabled you to succeed. You must be the one to restore Exeler, take it and bring glory to the world once more\n\nYou receive the Exeler piece",
                    enterCounter = 3,
                    nextState = "idle"
                })
                self.player.pieces["purple"] = true
                --Once the player has correctly answered the NPC will no longer take a number input for the number of teleporters
                self.NPCs[2].text = "You must be the one to restore Exeler"
                self.NPCs[2].enterCounter = 1
                self.NPCs[2].nextState = "idle"
            else
                self.player:changeState("text", {
                    text = "Hmmmmmmmmmmm",
                    enterCounter = 1,
                    nextState = "idle"
                })
            end
        end
    end

    if self.collectedWater then
        self.NPCs[1].text = "I see you have brought me water, rise my plants.\n\nThere you see a piece of Exeler from my revived garden, its all yours. I sense you will be the one."
        if self.NPCs[1].talking then
            self.map.layerTwo[90][73].id = 1362
            self.map.layerTwo[90][72].id = 1362
            self.map.layerTwo[92][71].id = 1362
            self.map.layerTwo[92][72].id = 1362
            self.map.layerTwo[91][73].id = 1362
            self.map.layerTwo[91][72].id = 1362
            self.map.layerTwo[91][71].id = 1362

            self.map.layerTwo[83][71].id = 1362
            self.map.layerTwo[83][72].id = 1362
            self.map.layerTwo[85][73].id = 1362
            self.map.layerTwo[85][72].id = 1362
            self.map.layerTwo[84][73].id = 1362
            self.map.layerTwo[84][72].id = 1362
            self.map.layerTwo[84][71].id = 1362

            self.NPCs[1].action()
            table.insert(self.gameObjects, GameObject(GAME_OBJECT_DEFS["blue"], 2250, 2650))
            self.collectedWater = false
            
            Timer.after(3, function()
                Timer.tween(1, {
                    [self.gameObjects[#self.gameObjects]] = {x = self.player.x * 2 - self.player.width, y = self.player.y * 2 - self.player.height}
                }):finish(function()
                    table.remove(self.gameObjects)
                    self.player.pieces["blue"] = true
                end)
            end)
        end
    end
end

--[[
    Calculates the top left tile index depending on the position of the player
    Used to render tiles only in the players view
    @param {number} x - the player's x coordinate
    @param {number} y - the player's y coordinate
    
    @return {number} - The x and y indices of the top left tile
]]
function Room:topLeftTile(x, y)
    local topLeftTile = self.map:pointToTile(x - VIRTUAL_WIDTH / 2, y - VIRTUAL_HEIGHT / 2)
    return topLeftTile[1].gridX, topLeftTile[1].gridY
end

function Room:render()
    if not self.renderWholeMap then
        local topX, topY = self:topLeftTile(self.player.x, self.player.y)
        for y = topY, topY + 24 do
            for x = topX, topX + 41 do
                if y - 24 < #self.layerOne and x - 41 < #self.layerOne[1] then
                    self.layerOne[y][x]:render()
                    self.layerTwo[y][x]:render()
                end
            end
        end
    else
        for y = 1, #mapFrames do
            for x = 1, #mapFrames[y] do
                self.layerOne[y][x]:render()
                self.layerTwo[y][x]:render()
            end
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
        if object.type == "Exeler Piece" then
            love.graphics.scale(0.5, 0.5)
            object:render()
            love.graphics.scale(2, 2)
        else
            object:render()
        end
        
    end

    for k, teleporter in pairs(self.teleporters) do
        teleporter:render()
    end
end