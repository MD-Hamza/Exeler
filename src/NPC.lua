NPC = Class{__includes = Entity}

function NPC:init(def, player, text, enterCounter)
	Entity.init(self, def)
    self.player = player
    self.text = text
    self.enterCounter = enterCounter
    self.talking = false
end

function NPC:update(dt)
    if wasPressed("return") and self:collides(self.player) and not self.talking then
        self.talking = true
        self.player:changeState("text", {
            text = self.text,
            enterCounter = self.enterCounter,
            nextState = "idle"
        })
    end

    if self.player.StateMachine.current.state == "idle" then
        self.talking = false
    end

    if self.player:collides(self) then
        if self.player.direction == "right" then
            self.player.x = self.x - self.player.width
        elseif self.player.direction == "left" then
            self.player.x = self.x + self.width
        elseif self.player.direction == "down" then
            self.player.y = self.y - self.player.height
        else
            self.player.y = self.y + self.player.height / 2
        end
    end
end

function NPC:render()
	Entity.render(self)
end