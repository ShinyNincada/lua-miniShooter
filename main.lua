function love.load() 
    require('startup.gameStart')
    GameStart()
  
    Bullets:load()
    -- Collider
    Player:load()
    CreateEnemy(0, 0, 'SPIDER', nil)
    LogTest = "NO"

    
    walls = {}

    if(GameMap.layers['Walls']) then
        for i, obj in pairs(GameMap.layers['Walls'].objects) do
            -- -- table.insert()
            local wall = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setCollisionClass('Wall')
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

-- function TestClone() 
--     print("test 2")
--     Ltest = "minh 2"
-- end

function love.update(dt)
    UpdateAll(dt)
    MainCamera:lookAt(Player.x, Player.y)
end

function love.draw()
    MainCamera:attach()
        GameMap:drawLayer(GameMap.layers['Tile Layer 1'])
        Player:draw()
        World:draw()
        Bullets:draw()
        Enemies:draw()
        Particles:draw()
    MainCamera:detach()
    -- TestClone()
    local debugTextX = 10  -- Adjust these values as needed
    local debugTextY = 10   -- Adjust these values as needed
    love.graphics.print(LogTest, debugTextX, debugTextY)
 end