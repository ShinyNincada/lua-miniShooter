require("movement")
require("player")
anim8 = require("Libs.anim8")


function love.load()
    player = {
        x = 400,
        y = 200,
        z = 0,
        speed = 1,
        weaponId = "minigun",
        animations = {}
    }
    

    love.mouse.setCursor(cursor)
    love.graphics.setBackgroundColor(255, 0, 0)

    player.spriteSheet = love.graphics.newImage('sprites/SpritesheetGuns.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    if player.grid then
        player.animations.idle_handgun = anim8.newAnimation(player.grid(1, 1), 10)
        player.animations.idle_minigun = anim8.newAnimation(player.grid(1, 2), 10)
        player.animations.attack_handgun = anim8.newAnimation(player.grid('1-2', 1), 0.2)
        player.animations.attack_minigun = anim8.newAnimation(player.grid('1-2', 2), 0.2)
    else
        love.graphics.printf("Error: player.grid is nil")
    end

    player.currentAnim = player.animations.attack_handgun
end


local cursor_idle = love.mouse.newCursor('sprites/crosshair012.png', 0, 0)
local cursor_attack = love.mouse.newCursor('sprites/crosshair012.png', 0, 0)

local function animatorHandle(dt)
    player.currentAnim:update(dt)
end

function love.update(dt)
    moveHandle()
    animatorHandle(dt)
end

function love.draw()
    player.currentAnim:draw(player.spriteSheet, player.x, player.y, player.z, 1, 1, 8, 24)
end

