StartState = Class{__includes = BaseState}

function StartState:init()
    self.opacity = 0
    self.position = VIRTUAL_HEIGHT / 2 - 40
    Timer.tween(1, {
    	[self] = {opacity = 1, position = VIRTUAL_HEIGHT / 2 - 30}
    })
end

function StartState:render()
    love.graphics.draw(gTextures["background"], 0, 0, 0,
        VIRTUAL_WIDTH/gTextures["background"]:getWidth(),
        VIRTUAL_HEIGHT/gTextures["background"]:getHeight())

    love.graphics.setFont(gFonts['Exeler'])
    love.graphics.setColor(34/255, 34/255, 34/255, self.opacity)
    love.graphics.printf('Exeler', 2, self.position, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(12/255, 153/255, 42/255, self.opacity)
    love.graphics.printf('Exeler', 0, self.position - 2, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['Exeler-small'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 15, VIRTUAL_WIDTH, 'center')
end