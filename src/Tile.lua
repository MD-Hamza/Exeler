Tile = Class{}

function Tile:init(def)
	self.x = def.x
	self.y = def.y
	self.gridX = def.gridX
	self.gridY = def.gridY

	self.width = def.width
	self.height = def.height

	self.id = def.id
	self.type = def.type
	
    --self.animation = Animation{["frames"] = self.id, ["interval"] = def.interval}
end

function Tile:update(dt)
    --self.animation:update(dt)
end

function Tile:collides(target)
	local targetY, targetHeight = target.y + target.height / 2, target.height / 2
    --If theres a certain side of the target the entity can collide with then it checks a hitbox on that side
    if (self.collsionSide) then

        if self.collsionSide == "left" then
           selfX, selfY, selfWidth, selfHeight = self.x, self.y, 0, self.height
        elseif self.collsionSide == "right" then
            selfX, selfY, selfWidth, selfHeight = self.x + self.width, self.y, 0, self.height
        elseif self.collsionSide == "up" then
            selfX, selfY, selfWidth, selfHeight = self.x + self.width, self.y, self.width, 0
        else
            selfX, selfY, selfWidth, selfHeight = self.x, self.y + self.height, self.width, 0
        end

        if target.x + target.width - 1 < selfX or target.x + 1 > selfX + selfWidth or
            targetY + targetHeight - 1 < selfY or targetY + 1 > selfY + selfHeight then
            return false
        end

        return true
    end

    if target.x + target.width - 1 < self.x or target.x + 1 > self.x + self.width or
        targetY + targetHeight - 1 < self.y or targetY + 1 > self.y + self.height then
            return false
    end

    return true
end

function Tile:collidable()
	for k, tile in pairs(COLLIDABLE) do
		if self.id == tile then
    		return true
		end
	end
	return false
end

function Tile:render()
	if self.id and not (self.id == 0) then
		love.graphics.draw(gTextures["overworld"], gFrames[self.type][self.id], 
			self.x, self.y)
	end
end