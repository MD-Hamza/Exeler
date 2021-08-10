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

function Tile:collidable()
	for k, tile in pairs(COLLIDABLE) do
		if self.id == tile then
    		return true
		end
	end
	return false
end

function Tile:render()
	if not (self.id == 0) then
		love.graphics.draw(gTextures["overworld"], gFrames[self.type][self.id], 
			self.x, self.y)

	end
end