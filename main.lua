require "src/dependancies"

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Exeler')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine{
        ["start"] = function() return StartState() end,
    }

    gStateMachine:change("start")
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end