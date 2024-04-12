local BulletTypes = {
    CIRCLE = "circle",
    RECTANGLE = "rect",
    NONE = "none"
}


Bullet = {}
Bullet.__index = Bullet

function loadbullet()
    bullets = {}
    bulletSpeed = 20
end

function Bullet:create(x, y, dx, dy, bulletType)
    local bullet = {}
    setmetatable(bullet, Bullet)

    bullet.x = x
    bullet.y = y
    bullet.dx = dx
    bullet.dy = dy
    bullet.type = bulletType
    bullet.radius = 5
    bullet.width = 10
    bullet.height = 10

    -- Customize properties based on bullet type
    if bullet.type == BulletTypes.CIRCLE then
        bullet.radius = 5
    elseif bullet.type == BulletTypes.RECTANGLE then
        bullet.width = 10
        bullet.height = 10
    elseif bullet.type == BulletTypes.NONE then
        
    end

    return bullet
end


function createBullet(shootAngle)
    local shootingOffsetX = 48 * math.cos(shootAngle)
    local shootingOffsetY = 48 * math.sin(shootAngle)
    local startX = player.x + shootingOffsetX
    local startY = player.y + shootingOffsetY
    local bulletDy = bulletSpeed * math.sin(shootAngle)
    local bulletDx = bulletSpeed * math.cos(shootAngle)
    table.insert(bullets, Bullet:create(startX, startY, bulletDx, bulletDy, player.bulletType))
end


function Bullet:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bullet:draw()
    if self.type == BulletTypes.CIRCLE then
        love.graphics.setColor(1, 0, 0) -- Red color for circle bullets
        love.graphics.circle("fill", self.x, self.y, self.radius)
    elseif self.type == BulletTypes.RECTANGLE then
        love.graphics.setColor(0, 0, 1) -- Blue color for rectangle bullets
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
    love.graphics.setColor(1,1,1)
end


function updateBullet(dt)
    for i = 1, #bullets do 
        bullets[i]:update(dt)
    end
end

function DrawBullets()
    for i = 1, #bullets  do
        bullets[i]:draw()
     end
 end