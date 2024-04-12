require("movement")
require("player")
anim8 = require("Libs.anim8")
wf = require 'Libs.windfield.windfield.init'
require('bullets.bullet_base')
require('Enemy/enemy_base')

function love.load()
    
    world = wf.newWorld()
    player = 
    loadbullet()
    player = {
        x = 400,
        y = 200,
        z = 0,
        speed = 300,
        weaponId = "minigun",
        bulletType = "circle",
        animations = {},
        interactRange = {}
    }
    
    -- Collider
    player.collider = world:newCircleCollider(player.x, player.y, 8)
    player.collider:setFixedRotation(true)
    
    love.mouse.setCursor(cursor)
    player.spriteSheet = love.graphics.newImage('sprites/SpritesheetGuns.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    if player.grid then
        player.animations.idle_handgun = anim8.newAnimation(player.grid(1, 1), 10)
        player.animations.idle_minigun = anim8.newAnimation(player.grid(1, 2), 10)
        player.animations.attack_handgun = anim8.newAnimation(player.grid('1-2', 1), 0.1)
        player.animations.attack_minigun = anim8.newAnimation(player.grid('1-2', 2), 0.1)
    else
        love.graphics.printf("Error: player.grid is nil")
    end

  
    player.currentAnim = player.animations.attack_handgun
    player.collider:setX(player.x + 16 * math.cos(angle))
    player.collider:setY(player.y + 16 * math.sin(angle))

    CreateEnemy()
end

local function animatorHandle(dt)
    player.currentAnim:update(dt)
end

function love.update(dt)
    player.x = player.collider:getX() - 16 * math.cos(angle)
    player.y = player.collider:getY() - 16 * math.sin(angle)
    moveHandle()
    animatorHandle(dt)
    updateBullet(dt)
    UpdateEnemies(dt)
    world:update(dt)
end

function love.draw()
    player.currentAnim:draw(player.spriteSheet, player.x, player.y, player.z, 1, 1, 10, 24)
    DrawBullets()
    DrawEnemies()
    world:draw()
end