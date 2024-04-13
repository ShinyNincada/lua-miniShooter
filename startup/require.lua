function RequireAll()
    --Import camera
    Camera = require 'Libs.hump.camera'
    MainCamera = Camera()

    -- Import Anim8
    Anim8 = require("Libs.anim8")
    
    Sti = require 'Libs.sti'
    gamemap = Sti('sprites/mapTiles/cityTest.lua')
    
    require("player")
    require('bullets.bullet')
    require('Enemy/enemy_base')
    require 'update' 
    
    -- Create new World for physic
    wf = require 'Libs.windfield.windfield.init'
    World = wf.newWorld()

    -- Creat classes for different collision
    require 'startup.collisionClasses'   
    CreateCollisionClasses()
end