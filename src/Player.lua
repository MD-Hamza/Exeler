Player = Class{__includes = Entity}

function Player:init(def)
	Entity.init(self, def)
	self.pieces = {
		["yellow"] = false,
		["blue"] = false,
		["purple"] = false,
	}
	self.restored = false
end

function Player:update(dt)
	Entity.update(self, dt)
end

function Player:render()
	Entity.render(self)
end