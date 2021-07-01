push = require "lib/push"
Class = require "lib/class"
Timer = require "lib/knife/timer"

require "src/Util"
require "src/Animation"
require "src/Tile"
require "src/HitBox"
require "src/GameLevel"
require "src/World/Room"
require "src/Entity_def"
require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"

require "src/Entity"
require "src/Player"
require "src/states/EntityIdleState"
require "src/states/player/PlayerIdleState"
require "src/states/player/PlayerWalkState"
require "src/states/player/PlayerSwordState"

gTextures = {
    ["background"] = love.graphics.newImage("graphics/background.png"),
    ["walk"] = {
        ["character"] = love.graphics.newImage("graphics/player/walkcycle/BODY_male.png"),
        ["robe"] = love.graphics.newImage("graphics/player/walkcycle/LEGS_pants_greenish.png"),
        ["belt"] = love.graphics.newImage("graphics/player/walkcycle/BELT_leather.png"),
        ["torso"] = love.graphics.newImage("graphics/player/walkcycle/TORSO_plate_armor_arms_shoulders.png"),
        ["head"] = love.graphics.newImage("graphics/player/walkcycle/HEAD_chain_armor_hood.png"),
    },
    ["slash"] = {
        ["character"] = love.graphics.newImage("graphics/player/slash/BODY_human.png"),
        ["robe"] = love.graphics.newImage("graphics/player/slash/LEGS_pants_greenish.png"),
        ["belt"] = love.graphics.newImage("graphics/player/slash/BELT_leather.png"),
        ["torso"] = love.graphics.newImage("graphics/player/slash/TORSO_plate_armor_arms_shoulders.png"),
        ["head"] = love.graphics.newImage("graphics/player/slash/HEAD_chain_armor_hood.png"),
        ["dagger"] = love.graphics.newImage("graphics/player/slash/WEAPON_dagger.png")
    },
    ["skeleton"] = love.graphics.newImage("graphics/player/walkcycle/BODY_skeleton.png"),
    ["overworld"] = love.graphics.newImage("graphics/Overworld.png"),
    ["dummy"] = love.graphics.newImage("graphics/player/combat_dummy/BODY_animation.png")
}

terrain = tileQuads(16, 16, gTextures["overworld"])
gFrames = {
    ["walk"] = {},
    ["slash"] = {},
    ["skeleton"] = tileQuads(32, 48, gTextures["skeleton"], 17, 15, 32, 16),
    ["terrain"] = table.slice(terrain, {
        {1, 6}, --6
        {41, 44}, --4
        {121, 126}, --6
        {161, 166}, --6
        {201, 206}, --6
        {243, 245}, --3
        {283, 285}, --3
        {323, 325}, --3
        {363, 364}, --2
        {403, 404}, --2
    }),
    ["dummy"] = tileQuads(32, 48, gTextures["dummy"], 17, 15, 32, 16),
}

order = {"character", "robe", "belt", "torso", "head"}
for k, type in pairs(order) do
    gFrames["walk"][type] = tileQuads(32, 48, gTextures["walk"][type], 17, 15, 32, 16)
    gFrames["slash"][type] = tileQuads(64, 49, gTextures["slash"]["character"], 0, 14, 0, 15)
end
gFrames["slash"]["dagger"] = tileQuads(64, 49, gTextures["slash"]["dagger"], 0, 14, 0, 15)

gFonts = {
    ["basic"] = love.graphics.newFont("fonts/font.ttf", 24),
    ["Exeler"] = love.graphics.newFont("fonts/Exeler.ttf", 42),
    ["Exeler-small"] = love.graphics.newFont("fonts/Exeler.ttf", 24)
}