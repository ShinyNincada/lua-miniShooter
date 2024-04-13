require("movement")
require("Player")
anim8 = require("Libs.anim8")
wf = require 'Libs.windfield.windfield.init'
require('bullets.bullet_base')
require('Enemy/enemy_base')
require 'update'
function love.load() 
    -- Create new World for physic
    World = wf.newWorld()
    Bullets:load()
    -- Collider
    Player:load()
    CreateEnemy()
end

function love.update(dt)
    UpdateAll(dt)
end

function love.draw()
    Player:draw()
    Bullets:draw()
    Enemies:draw()
    World:draw()
end