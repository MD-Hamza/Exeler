TileMap = Class{}

function TileMap:init(layerOne, layerTwo)
	self.layerOne = layerOne
    self.layerTwo = layerTwo
end

function TileMap:render()
	for y = 1, #mapLayerOne do
		for x = 1, #mapLayerOne[1] do
            self.layerOne[y][x]:render()
            self.layerTwo[y][x]:render()
		end
	end
end

function TileMap:pointToTile(x, y)
	if (x < 0 or y < 0 or x > #mapLayerOne * 16 or y > #mapLayerOne[1] * 16) then
		return nil
	end

    return {
        self.layerOne[math.floor(y / 16) + 1][math.floor(x / 16) + 1],
        self.layerTwo[math.floor(y / 16) + 1][math.floor(x / 16) + 1]
    }
end