Entity = Class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y 

    self.width = def.width
    self.height = def.height
    self.direction = "down"

    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.StateMachine = def.StateMachine
    self.animations = {}
    self.room = def.room
    self.map = def.map
    self.hitBox = def.hitBox
    self.health = def.health
    self.dead = false

    self.walkSpeed = def.walkSpeed
    for k, animation in pairs(def.animations) do
        self.animations[k] =  Animation{
            ["texture"] = animation.texture,
            ["frames"] = animation.frames,
            ["interval"] = animation.interval,
            ["looping"] = animation.looping
        }
    end

    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0
end

function Entity:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    if self.x + self.width < target.x or self.x > target.x + target.width or
        selfY + selfHeight < target.y or selfY > target.y + target.height then
            return false
    end

    return true
end

function Entity:changeState(name)
    self.StateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)    
    end

    if self.invulnerable then
		self.invulnerableTimer = self.invulnerableTimer + dt
		self.flashTimer = self.flashTimer + dt

		if self.invulnerableTimer >= self.invulnerableDuration then
			self.invulnerableDuration = 0
    		self.invulnerableTimer = 0
    		self.flashTimer = 0
    		self.invulnerable = false
		end
	end
    
    self.StateMachine:update(dt)
end

function Entity:goInvulnerable(time)
	self.invulnerable = true
	self.invulnerableDuration = time
end

function Entity:damage(dmg)
    self.health = self.health - 1
end

function Entity:processAI(dt)
	self.StateMachine:processAI(dt)
end

function Entity:render()
    if self.invulnerable and self.flashTimer > 0.06 then
		self.flashTimer = 0
		love.graphics.setColor(1, 1, 1, 64/255)
	end

    self.StateMachine:render()
    love.graphics.setColor(255, 255, 255, 255)
end