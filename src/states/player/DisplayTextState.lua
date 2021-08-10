DisplayTextState = Class{__includes = BaseState}

function DisplayTextState:enter(params)
    self.text = params.text
    self.enterCounter = params.enterCounter
    self.nextState = params.nextState
    self.y = (self.entity.y - VIRTUAL_HEIGHT / 3 + 16)
end

function DisplayTextState:init(entity)
    self.entity = entity
end

function DisplayTextState:update(dt)
    if wasPressed("return") then
        print(self.enterCounter)
        if (self.enterCounter == 0) then
            self.entity:changeState(self.nextState)
        end

        Timer.tween(0.5, {
            [self] = {y = self.y - 75}
        })
        self.enterCounter = self.enterCounter - 1
    end
end

function DisplayTextState:render()
    local animation = self.entity.currentAnimation
    drawAnimation(animation, math.floor(self.entity.x), math.floor(self.entity.y))

    love.graphics.draw(gTextures["font"], love.graphics.newQuad(0, 72, 360, 120, gTextures["font"]:getDimensions()), (self.entity.x - 164), self.entity.y - VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(0, 0, 0)
    love.graphics.stencil(function() 
        love.graphics.rectangle("fill", (self.entity.x - 150), self.entity.y - VIRTUAL_HEIGHT / 3 - 40, 360, 55)
        love.graphics.rectangle("fill", (self.entity.x - 150), (self.entity.y - VIRTUAL_HEIGHT / 3 + 90), 360, 1000)
    end, "replace", 1)
    love.graphics.setStencilTest("less", 1)
    love.graphics.setFont(gFonts["Exeler-xsmall"])
    love.graphics.printf(self.text, (self.entity.x - 148), self.y,
        328, "left")
    love.graphics.setStencilTest()
end