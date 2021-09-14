--Lets the player teleport from a (x, y) position to another (x, y) position
Teleporter = Class{}

--[[
    Constructor
    @param {number} x - The initial x position
    @param {number} y - The initial y position
    @param {number} toX - The final x position
    @param {number} toY - The final y position
]]
function Teleporter:init(x, y, toX, toY)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16

    self.toX = toX
    self.toY = toY
end

--[[
    This function changes the values of the player and the camera
    @param entity - The entity that will be teleported
    @param playState - a state where the position of the camera is updated
]]
function Teleporter:teleport(entity, playState)
    playState.canUpdate = false
    playState.room.renderWholeMap = true

    --Moves camera position recieved from playstate to the teleported spot
    Timer.tween(0.5, {
        [playState] = {
            camX = playState.camX + entity.x - self.toX,
            camY = playState.camY + entity.y - self.toY
        }
    })
    :finish(function()
        playState.canUpdate = true
        playState.room.renderWholeMap = false
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