Arrow = Class{}

function Arrow:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.direction = def.direction
    self.deadly = true

    if self.direction == "up" then
        self.dy = -290
        self.dx = 0
        self.rotation = math.rad(90)
        
        self.offsetX = 55
        self.offsetY = 0
    elseif self.direction == "left" then
        self.dx = -290
        self.dy = 0
        self.rotation = math.rad(0)

        self.offsetX = 0
        self.offsetY = -20
    elseif self.direction == "down" then
        self.dy = 290
        self.dx = 0
        self.rotation = math.rad(270)
        
        self.offsetX = -25
        self.offsetY = 57

    elseif self.direction == "right" then
        self.dy = 0
        self.dx = 290
        self.rotation = math.rad(180)
        
        self.offsetY = 60
        self.offsetX = 25
    else
        self.dy = -290 * math.sin(self.direction)
        self.dx = 290 * math.cos(self.direction)
        self.rotation = self.direction + (math.pi - 2 * self.direction)

        self.offsetY = -45 * math.sin(self.direction - 1.1) + 20 - math.abs(5 * math.cos(self.direction))
        self.offsetX = 44 * math.sin(self.direction + 0.28) + 12.5
    end
end

function Arrow:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.hitBox = Box(self.x + 12, self.direction == "down" and self.y + 44 or self.y + 14, self.width, self.height)
end

function Arrow:collides(target)
	return not (self.hitBox.x > target.x + target.width or self.hitBox.x + self.hitBox.width < target.x or
		self.hitBox.y > target.y + target.height or self.hitBox.y + self.hitBox.height < target.y)
end

function Arrow:render()
    love.graphics.draw(gTextures["bow"]["arrow"], gFrames["bow"]["arrow"][26], self.x + self.offsetX, self.y + self.offsetY, self.rotation)
end