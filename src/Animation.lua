Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture
    self.looping = def.looping == nil and true or def.looping
    self.frame = 1
    self.timer = 0
    self.timesPlayed = 0
end

function Animation:refresh()
	self.timesPlayed = 0
	self.frame = 1
	self.timer = 0
end

function Animation:update(dt)
    if not self.looping and self.timesPlayed > 0 then
		return
	end
	
	if #self.frames == 1 then
		return
	end

    self.timer = self.timer + dt
    if self.timer >= self.interval then
        self.timer = 0
        self.frame = self.frame + 1 > #self.frames and 1 or self.frame + 1
        if self.frame == 1 then
            self.timesPlayed = self.timesPlayed + 1
            if not self.looping then
                self.frame = #self.frames
            end
        end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.frame]
end