
function shootHandle()
    if(love.mouse.isDown(1)) then
        local mouseX, mouseY = love.mouse.getPosition()

        -- Calculate direction from player to mouse position
        local dx = mouseX - player.x
        local dy = mouseY - player.y
    
        -- Calculate angle in radians
        local angle = math.atan2(dy, dx)
    
        -- Update player rotation angle
        player.z = angle
        -- Your other update code here

        player.currentAnim = player.animations["attack_" .. player.weaponId]
        
    else 
        player.currentAnim = player.animations["idle_" .. player.weaponId]
    end
end

function moveHandle()
    velX, velY = 0 , 0;

    if love.keyboard.isDown('right', 'd') then
        velX = 1
    end

    if love.keyboard.isDown("left", 'a') then
        velX = -1
    end

    if love.keyboard.isDown('up', 'w') then
        velY = -1 
    end

    if love.keyboard.isDown('down', 's') then
        velY = 1
    end

    if love.keyboard.isDown('1') then
        player.weaponId = 'handgun'     
    end

    if love.keyboard.isDown('2') then
        player.weaponId = 'minigun'     
    end
    
    local normalizedX, normalizedY = Normalize(velX, velY)
    player.x = player.x + normalizedX * player.speed;
    player.y = player.y + normalizedY * player.speed;

    shootHandle()
end