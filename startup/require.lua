function RequireAll()
    --Import camera
    Camera = require 'Libs.hump.camera'
    MainCamera = Camera()

    -- Import Anim8
    Anim8 = require("Libs.anim8")
    
    Sti = require 'Libs.sti'
    GameMap = Sti('sprites/mapTiles/cityTest.lua')
    
    require('src.bullets.bullet')
    require('src.particles.particles')
    require("player")
    require('Enemy/enemy_base')
    require 'update' 
    
    -- Create new World for physic
    wf = require 'Libs.windfield.init'
    World = wf.newWorld()

    -- Creat classes for different collision
    require 'startup.collisionClasses'   
    CreateCollisionClasses()
end