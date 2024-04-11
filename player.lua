local cursor_idle = love.mouse.newCursor('sprites/crosshair013.png', 0, 0)
local cursor_attack = love.mouse.newCursor('sprites/crosshair015.png', 0, 0)
local angle = 0
local shootCooldown = 0.01

function loadbullet()
    bullets = {}
    bulletSpeed = 1000
end

-- Function to convert degrees to radians
function degToRad(degrees)
    return degrees * math.pi / 180
end

function createBullet(z)
    local startX = player.x + 48 * math.cos(z) - 0
    local startY = player.y + 48 * math.sin(z) + 0
    local bulletDy = bulletSpeed * math.sin(z);
    local bulletDx = bulletSpeed * math.cos(z);

    table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
end

function updateBullet(dt)
    for i = 1, #bullets do 
        bullets[i].x = bullets[i].x + bullets[i].dx * dt
        bullets[i].y = bullets[i].y + bullets[i].dy * dt
    end
end

local currentTime = os.time()
local lastShootTime = os.time()
function shootHandle()
    if(love.mouse.isDown(1)) then
        love.mouse.setCursor(cursor_attack)
        local mouseX, mouseY = love.mouse.getPosition()

        -- Calculate direction from player to mouse position
        local dx = mouseX - player.x
        local dy = mouseY - player.y
    
        -- Calculate angle in radians
        angle = math.atan2(dy, dx)
    
        -- Update player rotation angle
        player.z = angle
        -- Your other update code here

        player.currentAnim = player.animations["attack_" .. player.weaponId]
        
        createBullet(player.z)  

    else 
        love.mouse.setCursor(cursor_idle)
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


function drawBullets()
   for i = 1, #bullets  do
        love.graphics.setColor(0, 255, 0)
        love.graphics.circle("fill", bullets[i].x, bullets[i].y, 1)
        love.graphics.setColor(1,1,1)
    end
end