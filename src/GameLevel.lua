GameLevel = Class{}

function GameLevel:init(tiles, width, height, startX, startY)
    self.tiles = tiles
    self.mapWidth = width
    self.mapHeight = height
    self.startX = startX
    self.startY = startY
end

function GameLevel:pointToTile(x, y)
    --[[
	if (x < 0 or y < 0 or x > self.mapWidth * 16 or y > self.mapHeight * 16) then
		return nil
	end]]

	return self.tiles[math.floor((y - self.startY) / 16)][math.floor((x - self.startX) / 16)]
end