push = require "lib/push"
Class = require "lib/class"
Timer = require "lib/knife/timer"

require "src/Util"
require "src/Animation"
require "src/TileMap"
require "src/Tile"
require "src/Box"
require "src/Arrow"
require "src/Teleporter"
require "src/GameLevel"
require "src/map_def"
require "src/World/Room"
require "src/Entity_def"
require "src/GameObject_def"
require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/PlayState"

require "src/Entity"
require "src/GameObject"
require "src/NPC"
require "src/Player"
require "src/states/EntityIdleState"
require "src/states/EntityWalkState"
require "src/states/player/PlayerIdleState"
require "src/states/player/PlayerWalkState"
require "src/states/player/PlayerSwordState"
require "src/states/player/PlayerBowState"
require "src/states/player/DisplayTextState"
require "src/states/player/SkeletonShootingRange"

gTextures = {
    ["background"] = love.graphics.newImage("graphics/background.png"),
    ["walk"] = {
        ["character"] = love.graphics.newImage("graphics/player/walkcycle/BODY_male.png"),
        ["robe"] = love.graphics.newImage("graphics/player/walkcycle/LEGS_pants_greenish.png"),
        ["belt"] = love.graphics.newImage("graphics/player/walkcycle/BELT_leather.png"),
        ["rope"] = love.graphics.newImage("graphics/player/walkcycle/BELT_rope.png"),
        ["torso"] = love.graphics.newImage("graphics/player/walkcycle/TORSO_plate_armor_arms_shoulders.png"),
        ["purple-jacket"] = love.graphics.newImage("graphics/player/walkcycle/TORSO_chain_armor_jacket_purple.png"),
        ["head"] = love.graphics.newImage("graphics/player/walkcycle/HEAD_chain_armor_hood.png"),
        ["hood"] = love.graphics.newImage("graphics/player/walkcycle/HEAD_robe_hood.png"),
        ["hair"] = love.graphics.newImage("graphics/player/walkcycle/HEAD_hair_blonde.png"),
        ["armoured-hat"] = love.graphics.newImage("graphics/player/walkcycle/HEAD_chain_armor_helmet.png")
    },
    ["slash"] = {
        ["character"] = love.graphics.newImage("graphics/player/slash/BODY_human.png"),
        ["robe"] = love.graphics.newImage("graphics/player/slash/LEGS_pants_greenish.png"),
        ["belt"] = love.graphics.newImage("graphics/player/slash/BELT_leather.png"),
        ["rope"] = love.graphics.newImage("graphics/player/slash/BELT_rope.png"),
        ["torso"] = love.graphics.newImage("graphics/player/slash/TORSO_plate_armor_arms_shoulders.png"),
        ["purple-jacket"] = love.graphics.newImage("graphics/player/slash/TORSO_chain_armor_jacket_purple.png"),
        ["head"] = love.graphics.newImage("graphics/player/slash/HEAD_chain_armor_hood.png"),
        ["hood"] = love.graphics.newImage("graphics/player/slash/HEAD_robe_hood.png"),
        ["armoured-hat"] = love.graphics.newImage("graphics/player/slash/HEAD_chain_armor_helmet.png"),
        ["hair"] = love.graphics.newImage("graphics/player/slash/HEAD_hair_blonde.png"),
        ["dagger"] = love.graphics.newImage("graphics/player/slash/WEAPON_dagger.png")
    },
    ["bow"] = {
        ["character"] = love.graphics.newImage("graphics/player/bow/BODY_animation.png"),
        ["robe"] = love.graphics.newImage("graphics/player/bow/LEGS_pants_greenish.png"),
        ["belt"] = love.graphics.newImage("graphics/player/bow/BELT_leather.png"),
        ["rope"] = love.graphics.newImage("graphics/player/bow/BELT_rope.png"),
        ["torso"] = love.graphics.newImage("graphics/player/bow/TORSO_plate_armor_arms_shoulders.png"),
        ["purple-jacket"] = love.graphics.newImage("graphics/player/bow/TORSO_chain_armor_jacket_purple.png"),
        ["head"] = love.graphics.newImage("graphics/player/bow/HEAD_chain_armor_hood.png"),
        ["hood"] = love.graphics.newImage("graphics/player/bow/HEAD_robe_hood.png"),
        ["bow"] = love.graphics.newImage("graphics/player/bow/WEAPON_bow.png"),
        ["armoured-hat"] = love.graphics.newImage("graphics/player/bow/HEAD_chain_armor_helmet.png"),
        ["hair"] = love.graphics.newImage("graphics/player/bow/HEAD_hair_blonde.png"),
        ["arrow"] = love.graphics.newImage("graphics/player/bow/WEAPON_arrow.png")
    },
    ["skeleton"] = love.graphics.newImage("graphics/player/walkcycle/BODY_skeleton.png"),
    ["overworld"] = love.graphics.newImage("graphics/Overworld.png"),
    ["dummy"] = love.graphics.newImage("graphics/player/combat_dummy/BODY_animation.png"),
    ["objects"] = love.graphics.newImage("graphics/objects.png"),
    ["font"] = love.graphics.newImage("graphics/font.png"),
    ["particle"] = love.graphics.newImage("graphics/particle.png")
}

gFrames = {
    ["walk"] = {},
    ["slash"] = {},
    ["bow"] = {},
    ["skeleton"] = tileQuads(32, 48, gTextures["skeleton"], 17, 15, 32, 16),
    ["overworld"] = tileQuads(16, 16, gTextures["overworld"]),
    ["dummy"] = tileQuads(32, 48, gTextures["dummy"], 17, 15, 32, 16),
    ["objects"] = tileQuads(16, 16, gTextures["objects"])
}

for type, image in pairs(gTextures["walk"]) do
    gFrames["walk"][type] = tileQuads(32, 48, gTextures["walk"][type], 17, 15, 32, 16)
    gFrames["slash"][type] = tileQuads(64, 49, gTextures["slash"][type], 0, 14, 0, 15)
    gFrames["bow"][type] = tileQuads(64, 63, gTextures["bow"][type], 0, 4, 0, 0)
end

gFrames["slash"]["dagger"] = tileQuads(64, 49, gTextures["slash"]["dagger"], 0, 14, 0, 15)
gFrames["bow"]["bow"] = tileQuads(64, 63, gTextures["bow"]["bow"], 0, 4, 0, 0)
gFrames["bow"]["arrow"] = tileQuads(64, 63, gTextures["bow"]["arrow"], 0, 4, 0, 0)

gFonts = {
    ["basic"] = love.graphics.newFont("fonts/font.ttf", 24),
    ["Exeler"] = love.graphics.newFont("fonts/Exeler.ttf", 42),
    ["Exeler-small"] = love.graphics.newFont("fonts/Exeler.ttf", 24),
    ["Exeler-xsmall"] = love.graphics.newFont("fonts/Exeler.ttf", 20)
}