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
    self.map = def.map
    self.hitBox = def.hitBox

    for k, animation in pairs(def.animations) do
        self.animations[k] =  Animation{
            ["texture"] = animation.texture,
            ["frames"] = animation.frames,
            ["interval"] = animation.interval
        }
    end
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

    self.StateMachine:update(dt)
end

function Entity:render()
    self.StateMachine:render()
end