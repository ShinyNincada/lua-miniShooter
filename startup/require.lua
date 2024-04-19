function RequireAll()
    --Import camera
    Camera = require 'Libs.hump.camera'
    Vector = require "Libs.hump.vector"
    MainCamera = Camera()

    -- Import Anim8
    Anim8 = require("Libs.anim8")

    Sti = require 'Libs.sti'
    GameMap = Sti('sprites/mapTiles/cityTest.lua')

    -- Create new World for physic
    wf = require 'Libs.windfield.init'
    World = wf.newWorld()
    
    require("player")
    Tick = require('Libs.tick.tick')

    Flux = require('Libs.flux.flux')
    require('src.ultils.shaders')
    require('src.bullets.bullet')
    require('src.particles.particles')
    require('src.enemies.enemy')
    require 'update' 
    require('src.ultils.ultils')
    require('startup.resources')

    -- Creat classes for different collision
    require 'startup.collisionClasses'   
    CreateCollisionClasses()
end