function UpdateAll(dt)
    -- Update the world physics
    World:update(dt)

    -- Player update
    Player:update(dt)

    -- Bullets projectiles update
    Bullets:update(dt)

    -- Particles update
    Particles:update(dt)
    
    -- Enemies update
    Enemies:update(dt)
end