push = require "lib/push"
Class = require "lib/class"
Timer = require "lib/knife/timer"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"

gTextures = {
    ["background"] = love.graphics.newImage("graphics/background.png")
}

gFonts = {
    ["Exeler"] = love.graphics.newFont("fonts/Exeler.ttf", 36),
    ["Exeler-small"] = love.graphics.newFont("fonts/Exeler.ttf", 18)
}