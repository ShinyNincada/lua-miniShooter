local cursor_idle = love.mouse.newCursor('sprites/crosshair013.png', 0, 0)
local cursor_attack = love.mouse.newCursor('sprites/crosshair015.png', 0, 0)
angle = 0
local shootCooldown = 0.01
local normalizedX, normalizedY
local currentTime = os.time()
local lastShootTime = os.time()
Ray = {
    hitlist = {}
}

local function GetMovementNormalized()
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

    normalizedX, normalizedY = Normalize(velX, velY)
    return normalizedX, normalizedY
end


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

local function ChangeWeapon()
    if love.keyboard.isDown('1') then
        player.weaponId = 'handgun'   
        player.bulletType = "circle"  
    end

    if love.keyboard.isDown('2') then
        player.weaponId = 'minigun'     
        player.bulletType = "rect"  
    end
end

function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
	local hit = {}
	hit.fixture = fixture
	hit.x, hit.y = x, y
	hit.xn, hit.yn = xn, yn
	hit.fraction = fraction

	table.insert(Ray.hitList, hit)

	return 1 -- Continues with ray cast through all shapes.
end

function moveHandle()
    GetMovementNormalized()
    ChangeWeapon()
    player.collider:setLinearVelocity(normalizedX * player.speed, normalizedY * player.speed)
    shootHandle()
end

