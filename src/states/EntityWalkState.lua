EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, directions)
	self.entity = entity
	self.entity:changeAnimation('walk-'..self.entity.direction)

	self.moveDuration = 0
	self.timer = 0

	self.bumped = false

	--The directions the skeleton is allowed to move in
	self.directions = directions or {"left", "right", "up", "down"}
end

function EntityWalkState:update(dt)
	self.bumped = false
	
	if self.entity.direction == "up" then
		self.entity.y = self.entity.y - self.entity.walkSpeed * dt
	elseif self.entity.direction == "down" then
		self.entity.y = self.entity.y + self.entity.walkSpeed * dt
	elseif self.entity.direction == "left" then
		self.entity.x = self.entity.x - self.entity.walkSpeed * dt
	else
		self.entity.x = self.entity.x + self.entity.walkSpeed * dt
	end

    local tiles = self.entity.map:pointToTile(self.entity.x + 1, self.entity.y - self.entity.height / 2 + 1)
	if not (tiles == nil) then
		for y = tiles[1].gridY, tiles[1].gridY + 4 do
			for x = tiles[1].gridX, tiles[1].gridX + 3 do
				local layerOneTile = self.entity.map.layerOne[y][x]
				local layerTwoTile = self.entity.map.layerTwo[y][x]

				if self.entity:collides(layerOneTile) and (layerOneTile:collidable() or layerTwoTile:collidable()) then
					if self.entity.direction == 'left' then
						self.entity.x = layerOneTile.x + layerOneTile.width + 1
						if layerOneTile.collsionSide == "left" then
							self.entity.x = self.entity.x - 16
						end

						self.bumped = true
					elseif self.entity.direction == 'right' then
						self.entity.x = layerOneTile.x - self.entity.width - 1
						if layerOneTile.collsionSide == "right" then
							self.entity.x = self.entity.x + 16
						end
						
						self.bumped = true
					elseif self.entity.direction == 'up' then
						self.entity.y = layerOneTile.y + layerOneTile.height - self.entity.height / 2 + 1

						if layerOneTile.collsionSide == "up" then
							self.entity.y = self.entity.y - 16
						end
						self.bumped = true
					elseif self.entity.direction == 'down' then
						self.entity.y = layerOneTile.y  - self.entity.height + 5

						if layerOneTile.collsionSide == "down" then
							self.entity.y = self.entity.y + 10
						end
						self.bumped = true
					end

					self:adjusment(self.entity.direction, x, y)
				end
				
			end
		end
	end
end

function EntityWalkState:processAI(dt)
	if self.bumped or self.moveDuration == 0 then
		self.moveDuration = math.random(5)
		self.entity.direction = self.directions[math.random(#self.directions)]
		self.entity:changeAnimation("walk-" .. tostring(self.entity.direction))

	elseif self.timer > self.moveDuration and self.entity.walkSpeed < 200 then
		self.timer = 0
		if math.random(3) == 1 then
			self.entity.StateMachine:change("idle")
		else
			self.entity.direction = self.directions[math.random(#self.directions)]
			self.entity:changeAnimation("walk-" .. tostring(self.entity.direction))
		end
	end
	self.timer = self.timer + dt
end

function EntityWalkState:adjusment(direction, x, y)
	local layerOneTile = self.entity.map.layerOne[y][x]
	local layerTwoTile = self.entity.map.layerTwo[y][x]

	if direction == "left" or direction == "right" then
		if not (self.entity.map.layerOne[y + 1][x]:collidable() or self.entity.map.layerTwo[y + 1][x]:collidable() or
				self.entity.map.layerOne[y + 2][x]:collidable() or self.entity.map.layerTwo[y + 2][x]:collidable())  then
			if math.abs(layerOneTile.y + layerOneTile.height - self.entity.y - self.entity.height / 2) <= 9 then
				Timer.tween(0.1, {
					[self.entity] = {y = layerOneTile.y + layerOneTile.height - self.entity.height / 2 + 1}
				})
			end
		elseif not (self.entity.map.layerOne[y - 1][x]:collidable() or self.entity.map.layerTwo[y - 1][x]:collidable() or
					self.entity.map.layerOne[y - 2][x]:collidable() or self.entity.map.layerTwo[y - 2][x]:collidable()) then
			if math.abs(layerOneTile.y + layerOneTile.height - self.entity.y - self.entity.height / 2) >= 14 then
				Timer.tween(0.1, {
					[self.entity] = {y = layerOneTile.y - self.entity.height - 1}
				})
			end
		end
	else
		if not (self.entity.map.layerOne[y][x - 1]:collidable() or self.entity.map.layerTwo[y][x - 1]:collidable() or
				self.entity.map.layerOne[y][x - 2]:collidable() or self.entity.map.layerTwo[y][x - 2]:collidable())  then
			if math.abs(layerOneTile.x + layerOneTile.width - self.entity.x - self.entity.width) <= 14 then
				Timer.tween(0.1, {
					[self.entity] = {x = layerOneTile.x - self.entity.width - 1}
				})
			end
		elseif not (self.entity.map.layerOne[y][x + 1]:collidable() or self.entity.map.layerTwo[y][x + 1]:collidable() or
					self.entity.map.layerOne[y][x + 2]:collidable() or self.entity.map.layerTwo[y][x + 2]:collidable()) then
			if math.abs(layerOneTile.x + layerOneTile.width - self.entity.x - self.entity.width) >= 24 then
				Timer.tween(0.1, {
					[self.entity] = {x = layerOneTile.x + layerOneTile.width + 2}
				})
			end
		end
	end
end

function EntityWalkState:render()
	local animation = self.entity.currentAnimation
	if animation then
		love.graphics.draw(gTextures[animation.texture], 
			gFrames[animation.texture][animation:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
	end
end