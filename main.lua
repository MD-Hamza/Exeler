require "src/dependancies"

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PLAYER_WALKING_SPEED = 120

COLLIDABLE = {
    643, 728, 645, 647, 765, 766, 687, 726, 686, 727, 764, 565, 
    566, 567, 525, 526, 527, 485, 486, 487, 192, 193, 153, 152, 
    601, 564, 523, 562, 522, 603, 604, 524, 602, 641, 561, 642, 
    644, 646, 685, 723, 725, 681, 721, 683, 205, 204, 206, 491, 
    490, 450, 451, 168, 167, 127, 128, 87, 88, 89, 49, 48, 47, 
    8, 9, 7, 10, 50, 90, 130, 170, 129, 171, 131, 91, 51, 11, 
    208, 445, 405, 446, 447, 407, 361, 362, 442, 443, 441, 
    367, 285, 324, 325, 323, 283, 41, 82, 81, 42, 44, 43, 83, 
    339, 379, 341, 299, 260, 810, 770, 730, 690, 691, 731, 771, 
    811
}

COLLIDABLE_TOP = {
    442
}

COLLIDABLE_RIGHT = {
    367, 407
}

COLLIDABLE_LEFT = {
    365, 405
}

COLLIDABLE_BOTTOM = {
    446
}

width = 64
height = 55
startX = 0
startY = 10
jumpY = 15
jumpX = 0

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
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
    
    --[[if key == "q" then
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
    elseif key == "d" then
        jumpY = jumpY + 1
    elseif key == "f" then
        jumpY = jumpY - 1
    elseif key == "g" then
        height = height + 1
    elseif key == "h" then
        height = height - 1
    else
        print(width, startX, jumpX, jumpY, startY, height)
    end]]
    
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