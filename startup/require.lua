function RequireAll()
    --Import camera
    Camera = require 'Libs.hump.camera'
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

    require('src.ultils.shaders')
    require('src.bullets.bullet')
    require('src.particles.particles')
    require('src.enemies.enemy')
    require 'update' 
    

    -- Creat classes for different collision
    require 'startup.collisionClasses'   
    CreateCollisionClasses()
end