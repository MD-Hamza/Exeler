require "src/dependancies"

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PLAYER_WALKING_SPEED = 120

GROUND = {1}
WATER = {7, 8, 9, 10}

TOPSIDE = {36}
LEFTSIDE = {34}
BOTTOMSIDE = {30}
RIGHTSIDE = {32}

TOPLEFTGROUND = {38}
TOPRIGHTGROUND = {39}
BOTTOMLEFTGROUND = {40}
BOTTOMRIGHTGROUND = {41}

COLLIDABLE = {
    WATER,
    TOPRIGHTGROUND,
    TOPLEFTGROUND,
    BOTTOMLEFTGROUND,
    BOTTOMRIGHTGROUND,
    TOPSIDE,
    LEFTSIDE,
    BOTTOMSIDE,
    RIGHTSIDE
}
width = 44
height = 49
startX = 3
startY = 14
jumpX = 22
jumpY = 15
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
        ["play"] = function() return PlayState() end,
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
    --[[
    if key == "q" then
        width = width + 1
    elseif key == "w" then
        width = width - 1
    elseif key == "t" then
        startX = startX + 1
    elseif key == "y" then
        startX = startX - 1
    elseif key == "u" then
        startY = startY + 1
    elseif key == "i" then
        startY = startY - 1
    elseif key == "a" then
        jumpX = jumpX + 1
    elseif key == "s" then
        jumpX = jumpX - 1
    else
        print(width, startX, jumpX, startY)
    end
    ]]
    love.keyboard.keysPressed[key] = true
end

function love.draw()
    push:start()
        gStateMachine:render()
    push:finish()
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function conf(t)
	t.console = true
end

function quadVisualizer(width, height, atlas, startX, startY, jumpX, jumpY)
    startX = startX or 0
    startY = startY or 0
    jumpX = jumpX or 0
    jumpY = jumpY or 0

    local cols = math.floor((atlas:getWidth() + jumpX) / (width + jumpX))
	local rows = math.floor((atlas:getHeight() + jumpY) / (height + jumpY))
    for y = 0, rows - 1 do
		for x = 0, cols - 1 do
            local posX = startX + x * (width + jumpX)
            local posY = startY + y * (height + jumpY)
            love.graphics.setColor(1, 1, 1, 1)
			love.graphics.rectangle("line", posX, posY, width, height)
		end
	end
end

function wasPressed(key)
    return love.keyboard.keysPressed[key]
end