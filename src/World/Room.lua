Room = Class{}

function Room:init(def)
    self.tiles = {}
    self.mapHeight = def.mapHeight
    self.mapWidth = def.mapWidth
    self.player = def.player
    --Coordinates of the top left tile
    self.startX = -(self.mapWidth * 4)
    self.startY = -(self.mapHeight * 4)
    self:generatefloor(16, 16)

    self.entities = {}
    self:generateEntities()
end

function Room:generatefloor(width, height)
    for y = 1, self.mapHeight do
        table.insert(self.tiles, {})
        for x = 1, self.mapWidth do
            if y <= 15 or y >= self.mapHeight - 15 or x <= 20 or x >= self.mapWidth - 20 then
                id = WATER
                interval = 0.2
            elseif y == 16 and x == 21 then
                id = TOPLEFTGROUND
            elseif y == 16 and x == self.mapWidth - 21 then
                id = TOPRIGHTGROUND
            elseif y == self.mapHeight - 16 and x == 21 then
                id = BOTTOMLEFTGROUND
            elseif y == self.mapHeight - 16 and x == self.mapWidth - 21 then
                id = BOTTOMRIGHTGROUND
            elseif y == 16 then
                id = TOPSIDE
            elseif x == 21 then
                id = LEFTSIDE
            elseif y == self.mapHeight - 16 then
                id = BOTTOMSIDE
            elseif x == self.mapWidth - 21 then
                id = RIGHTSIDE
            else
                id = GROUND
            end

            table.insert(self.tiles[y], Tile{
                x = self.startX + (width * (x - 1)),
                y = self.startY + (width * (y - 1)),
                width = width,
                height = height,
                type = "terrain",
                id = id,
                interval = interval,
                gridX = x,
                gridY = y
            })
        end
    end
end

function Room:generateEntities()
    local skeleton = Entity{
        x = math.random(VIRTUAL_WIDTH / 2 - 42, VIRTUAL_WIDTH / 2 + 42),
        y = math.random(VIRTUAL_HEIGHT/ 2 - 48, VIRTUAL_HEIGHT/ 2 + 48),
        width = 32,
        height = 48,
        texture = "skeleton",
        animations = ENTITY_DEFS["skeleton"].animations
    }

    skeleton.StateMachine = StateMachine{
        ["idle"] = function() return EntityIdleState(skeleton) end
    }
    skeleton.StateMachine:change("idle")

    table.insert(self.entities, skeleton)
end

function Room:update(dt)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do

            self.tiles[y][x]:update(dt)
        end
    end

    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function Room:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self.tiles[y][x]:render()
        end
    end

    for k, entity in pairs(self.entities) do
        entity:render()
    end
end