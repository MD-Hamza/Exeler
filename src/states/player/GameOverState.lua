GameOverState = Class{__includes = BaseState}

function GameOverState:enter()
    self.event = false
    self.player:changeAnimation('hurt')
end

function GameOverState:init(player)
	self.player = player
    self.player.invulnerable = false
    --Has the event been triggered yet
    self.event = false
end

function GameOverState:update(dt)
    if self.player.currentAnimation.timesPlayed >= 1 and not self.event then
        self.event = true
        Event.dispatch("death")
    end
end

function GameOverState:render()
    local animation = self.player.currentAnimation
    drawAnimation(animation, math.floor(self.player.x), math.floor(self.player.y))
end