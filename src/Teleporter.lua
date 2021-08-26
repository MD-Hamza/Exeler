Teleporter = Class{}

function Teleporter:init(x, y, toX, toY)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16

    self.toX = toX
    self.toY = toY
end

function Teleporter:teleport(entity, playState)
    playState.canUpdate = false

    Timer.tween(0.5, {
        [playState] = {
            camX = playState.camX + entity.x - self.toX,
            camY = playState.camY + entity.y - self.toY
        }
    })
    :finish(function()
        playState.canUpdate = true
    end)

    --Change player position after a delay so that the camera doesn't update 
    --to the teleported location rather tweens there
    Timer.after(0.01, function()
        entity.x = self.toX
        entity.y = self.toY
    end)
end

function Teleporter:render()
    love.graphics.draw(gTextures["overworld"], gFrames["overworld"][184], self.x, self.y)
end