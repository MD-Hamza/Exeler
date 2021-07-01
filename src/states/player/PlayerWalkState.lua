PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player)
    self.player = player
    self.player.offsetX = 0
    self.player.offsetY = 0
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player:changeAnimation('left')
        self.player.x = self.player.x - 120 * dt
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player:changeAnimation('right')
        self.player.x = self.player.x + 120 * dt
    elseif love.keyboard.isDown('up') then
        self.player.direction = 'up'
        self.player:changeAnimation('up')
        self.player.y = self.player.y - 120 * dt
    elseif love.keyboard.isDown('down') then
        self.player.direction = 'down'
        self.player:changeAnimation('down')
        self.player.y = self.player.y + 120 * dt
    else
        self.player:changeState("idle")
    end
    
    if wasPressed("space") then
        self.player:changeState("sword")
    end
    --Reference tile that checks in a 3x4 rectangle around the player for collisons
    local ref = self.player.map:pointToTile(self.player.x, self.player.y)
    for y = ref.gridY, ref.gridY + 4 do
        for x = ref.gridX, ref.gridX + 3 do
            local tile = self.player.map.tiles[y][x]
            if self.player:collides(tile) and tile:collidable() then
                if self.player.direction == 'left' then
                    self.player.x = tile.x + tile.width + 1
                elseif self.player.direction == 'right' then
                    self.player.x = tile.x - self.player.width - 1
                elseif self.player.direction == 'up' then
                    self.player.y = tile.y + tile.height - self.player.height / 2 + 1
                elseif self.player.direction == 'down' then
                    self.player.y = tile.y  - self.player.height - 1
                end
            end
        end
    end
end

function PlayerWalkState:render()
    local animation = self.player.currentAnimation
    if animation then
        drawAnimation(animation, self.player.x, self.player.y)
    end
end