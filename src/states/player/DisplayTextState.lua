DisplayTextState = Class{__includes = BaseState}

function DisplayTextState:enter(params)
    self.text = params.text
    self.enterCounter = params.enterCounter
    --The name of the next state and the parameters to enter into it
    self.nextState = params.nextState
    self.enter = params.enter
    
    self.finish = params.finish == nil and function() end or params.finish
    self.y = (self.entity.y - VIRTUAL_HEIGHT / 3 + 16)
    self.input = params.input
end

function DisplayTextState:init(entity)
    self.entity = entity
end

function DisplayTextState:update(dt)
    if keyPressed() and self.input then
        if wasPressed("backspace") then
            self.text = self.text:sub(1, -2)
        elseif not wasPressed("return") then
            self.text = getText(self.text)
        end
    end

    if wasPressed("return") or wasPressed("enter") then
        if self.input then
            self.result = self.text
        else
            Timer.tween(0.5, {
                [self] = {y = self.y - 75}
            })
            self.enterCounter = self.enterCounter - 1
            if (self.enterCounter == 0) then
                self.finish()
                self.entity:changeState(self.nextState, self.enter)
            end
        end
    end
end

function DisplayTextState:render()
    local animation = self.entity.currentAnimation
    drawAnimation(animation, math.floor(self.entity.x), math.floor(self.entity.y))

    love.graphics.draw(gTextures["font"], love.graphics.newQuad(0, 72, 360, 120, gTextures["font"]:getDimensions()), (self.entity.x - 164), self.entity.y - VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(0, 0, 0)
    love.graphics.stencil(function() 
        love.graphics.rectangle("fill", (self.entity.x - 180), self.entity.y - VIRTUAL_HEIGHT / 3 - 40, 390, 55)
        love.graphics.rectangle("fill", (self.entity.x - 180), (self.entity.y - VIRTUAL_HEIGHT / 3 + 90), 390, 1000)
    end, "replace", 1)
    love.graphics.setStencilTest("less", 1)
    if self.input then
        love.graphics.setFont(gFonts["basic"])
    else
        love.graphics.setFont(gFonts["Exeler-xsmall"])
    end

    love.graphics.printf(self.text, (self.entity.x - 148), self.y,
        328, self.input and "center" or "left")
    love.graphics.setStencilTest()
end