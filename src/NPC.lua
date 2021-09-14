NPC = Class{__includes = Entity}

function NPC:init(def, player, text, enterCounter, quest, outfit, nextState, enter)
	Entity.init(self, def)
    self.player = player
    self.text = text
    self.enterCounter = enterCounter
    self.talking = false
    self.quest = quest
    self.outfit = outfit
    
    self.nextState = nextState or "idle"
    self.enter = enter

    self.direction = "left"
end

function NPC:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)    
    end
    
    if self.player.direction == "right" then
        self.player.x = self.player.x + 1
        self.direction = "left"
    elseif self.player.direction == "left" then
        self.player.x = self.player.x - 1
        self.direction = "right"
    elseif self.player.direction == "down" then
        self.player.y = self.player.y + self.player.height / 2 + 1
        self.direction = "up"
    else
        self.player.y = self.player.y - 1
        self.direction = "down"
    end

    if wasPressed("return") and self:collides(self.player) and not self.talking then
        self:changeAnimation("idle-"..self.direction)
        self.talking = true
        self.player:changeState("idle")
        self.player:changeState("text", {
            text = self.text,
            enterCounter = self.enterCounter,
            nextState = self.nextState,
            enter = self.enter
        })
    end

    if self.player.direction == "right" then
        self.player.x = self.player.x - 1
    elseif self.player.direction == "left" then
        self.player.x = self.player.x + 1
    elseif self.player.direction == "down" then
        self.player.y = self.player.y - self.player.height / 2 - 1
    else
        self.player.y = self.player.y + 1
    end

    if self.player.StateMachine.current.state == "idle" then
        self.talking = false
    end

    if self.player:collides(self) then
        if self.player.direction == "right" then
            self.player.x = self.x - self.player.width - 1
        elseif self.player.direction == "left" then
            self.player.x = self.x + self.width + 1
        elseif self.player.direction == "down" then
            self.player.y = self.y - self.player.height - 1
        else
            self.player.y = self.y + self.player.height / 2 + 1
        end
    end
end

function NPC:render()
	local animation = self.currentAnimation
	if animation then
		drawAnimation(animation, self.x, self.y, self.outfit)
	end
end