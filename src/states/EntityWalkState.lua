EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
	self.entity = entity
	self.entity:changeAnimation('walk-'..self.entity.direction)

	self.moveDuration = 0
	self.timer = 0

	self.bumped = false
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

    local ref = self.entity.map:pointToTile(self.entity.x, self.entity.y)
    for y = ref.gridY, ref.gridY + 4 do
        for x = ref.gridX, ref.gridX + 3 do
            local tile = self.entity.map.tiles[y][x]
            if self.entity:collides(tile) and tile:collidable() then
                if self.entity.direction == 'left' then
                    self.entity.x = tile.x + tile.width + 1
                    self.bumped = true
                elseif self.entity.direction == 'right' then
                    self.entity.x = tile.x - self.entity.width - 1
                    self.bumped = true
                elseif self.entity.direction == 'up' then
                    self.entity.y = tile.y + tile.height - self.entity.height / 2 + 1
                    self.bumped = true
                elseif self.entity.direction == 'down' then
                    self.entity.y = tile.y  - self.entity.height - 1
                    self.bumped = true
                end
            end
        end
    end
end

function EntityWalkState:processAI(dt)
	local directions = {"up", "down", "left", "right"}
	if self.bumped or self.moveDuration == 0 then
		self.moveDuration = math.random(5)
		self.entity.direction = directions[math.random(#directions)]
		self.entity:changeAnimation("walk-" .. tostring(self.entity.direction))
	elseif self.timer > self.moveDuration then
		self.timer = 0
		if math.random(3) == 1 then
			self.entity.StateMachine:change("idle")
		else
			self.entity.direction = directions[math.random(#directions)]
			self.entity:changeAnimation("walk-" .. tostring(self.entity.direction))
		end
	end
	self.timer = self.timer + dt
end

function EntityWalkState:render()
	
	local animation = self.entity.currentAnimation
	love.graphics.draw(gTextures[animation.texture], 
		gFrames[animation.texture][animation:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
end