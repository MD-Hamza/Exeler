Player = Class{__includes = Entity}

function Player:init(def)
	Entity.init(self, def)
end

function Player:update(dt)
	Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    if self.x + self.width < target.x or self.x > target.x + target.width or
        selfY + selfHeight < target.y or selfY > target.y + target.height then
            return false
    end

    return true
end

function Player:render()
	Entity.render(self)
end