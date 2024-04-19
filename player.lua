local cursor_idle = love.mouse.newCursor('sprites/crosshair013.png', 0, 0)
local cursor_attack = love.mouse.newCursor('sprites/crosshair015.png', 0, 0)
angle = 0
local shootCooldown = 0.01
local normalizedX, normalizedY
local currentTime = os.time()
local lastShootTime = os.time()

function Normalize(velX, velY)
    local length = math.sqrt(velX^2 + velY^2)

    if length == 0 then
        return 0, 0
    else
        return velX / length, velY / length
    end
end


Player = {
    x = 400,
    y = 200,
    z = 0,
    speed = 300,
    weaponId = "minigun",
    bulletType = "circle",
    animations = {},
    interactRange = {}
}

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
        local mouseX, mouseY = MainCamera:mousePosition()    
        -- Calculate direction from Player to mouse position
        local dx = mouseX - Player.x
        local dy = mouseY - Player.y
    
        -- Calculate angle in radians
        angle = math.atan2(dy, dx)
    
        -- Update Player rotation angle
        Player.z = angle
        -- Your other update code here

        Player.currentAnim = Player.animations["attack_" .. Player.weaponId]
        
        Bullets:createBullet(Player.z)  

    else 
        love.mouse.setCursor(cursor_idle)
        Player.currentAnim = Player.animations["idle_" .. Player.weaponId]
    end
end

local function ChangeWeapon()
    if love.keyboard.isDown('1') then
        Player.weaponId = 'handgun'   
        Player.bulletType = "circle"  
        -- Bullets:createBullet(angle)
        -- Particles:CreateRed(Player.x, Player.y, 0, 0)
    end

    if love.keyboard.isDown('2') then
        Player.weaponId = 'minigun'     
        Player.bulletType = "rect"  
    end
end

function WorldRayCastCallback(fixture, x, y, xn, yn, fraction)
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
    Player.collider:setLinearVelocity(normalizedX * Player.speed, normalizedY * Player.speed)
    shootHandle()
end

function Player:GetPosition()
    return self.x, self.y
end

function Player:load()
    Player.collider = World:newBSGRectangleCollider(Player.x, Player.y, 15,15,3)
    Player.collider:setFixedRotation(true)
    Player.collider:setCollisionClass('Player')

    
    love.mouse.setCursor(cursor)
    Player.spriteSheet = love.graphics.newImage('sprites/SpritesheetGuns.png')
    Player.grid = Anim8.newGrid(48, 48, Player.spriteSheet:getWidth(), Player.spriteSheet:getHeight())
    if Player.grid then
        Player.animations.idle_handgun = Anim8.newAnimation(Player.grid(1, 1), 10)
        Player.animations.idle_minigun = Anim8.newAnimation(Player.grid(1, 2), 10)
        Player.animations.attack_handgun = Anim8.newAnimation(Player.grid('1-2', 1), 0.1)
        Player.animations.attack_minigun = Anim8.newAnimation(Player.grid('1-2', 2), 0.1)
    else
        love.graphics.printf("Error: Player.grid is nil")
    end

  
    Player.currentAnim = Player.animations.attack_handgun
    Player.collider:setX(Player.x + 16 * math.cos(angle))
    Player.collider:setY(Player.y + 16 * math.sin(angle))
end

function Player:update(dt)
    Player.x = Player.collider:getX() - 16 * math.cos(angle)
    Player.y = Player.collider:getY() - 16 * math.sin(angle)
    moveHandle()
    Player.currentAnim:update(dt)
end

function Player:draw()
    Player.currentAnim:draw(Player.spriteSheet, Player.x, Player.y, Player.z, 1, 1, 10, 24)
end
