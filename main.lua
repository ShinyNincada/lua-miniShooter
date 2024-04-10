require("movement")
anim8 = require("Libs.anim8")

local function moveHandle()
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

    local normalizedX, normalizedY = Normalize(velX, velY)
    player.x = player.x + normalizedX * player.speed;
    player.y = player.y + normalizedY * player.speed;
end

local function shootHandle()
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
    end
end

function love.load()
    love.graphics.setBackgroundColor(255, 0, 0)

    player = {
        x = 400,
        y = 200,
        z = 0,
        speed = 10,
        animations = {}
    }
  
    player.spriteSheet = love.graphics.newImage('sprites/SpritesheetGuns.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    if player.grid then
        player.animations.idle1 = anim8.newAnimation(player.grid(1, 1), 10)
        player.animations.idel2 = anim8.newAnimation(player.grid(1, 2), 10)
        player.animations.shooting1 = anim8.newAnimation(player.grid('1-2', 1), 0.2)
        player.animations.shooting2 = anim8.newAnimation(player.grid('1-2', 2), 0.2)
    else
        love.graphics.printf("Error: player.grid is nil")
    end
    player.currentAnim = player.animations.idel2
end

function love.update(dt)
    moveHandle()
    shootHandle()
    player.currentAnim:update(dt)
end

function love.draw()
    player.currentAnim:draw(player.spriteSheet, player.x, player.y, player.z, 1, 1, 8, 24)
end

