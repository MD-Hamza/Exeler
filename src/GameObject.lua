GameObject = Class{}

function GameObject:init(def, x, y)
	self.type = def.type

	self.x = x
	self.y = y

	self.dx = 0
	self.dy = 0

	self.width = def.width
	self.height = def.height

	self.texture = def.texture
	self.animation = def.animation

	self.solid = def.solid
	self.consumable = def.consumable
	self.collidable = def.collidable

	self.onCollide = function() end
	self.onConsume = function() end
end

function GameObject:update(dt)
    self.animation:update(dt)
end

function GameObject:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function GameObject:collides(target)
	return not (self.x > target.x + target.width or self.x + self.width < target.x or
		self.y > target.y + target.height or self.y + self.height < target.y)
end

function GameObject:render()
	love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.animation:getCurrentFrame()], 
		self.x, self.y)
end