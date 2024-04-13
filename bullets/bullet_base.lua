local BulletTypes = {
    CIRCLE = "circle",
    RECTANGLE = "rect",
    NONE = "none"
}


local Bullet = {}
Bullet.__index = Bullet

Bullets = {}
function Bullets:load()
    Bullets.BulletSpeed = 20
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
    table.insert(Bullets, bullet)
    return bullet
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

function createBullet(shootAngle)
    local shootingOffsetX = 48 * math.cos(shootAngle)
    local shootingOffsetY = 48 * math.sin(shootAngle)
    local startX = Player.x + shootingOffsetX
    local startY = Player.y + shootingOffsetY
    local bulletDy = Bullets.BulletSpeed * math.sin(shootAngle)
    local bulletDx = Bullets.BulletSpeed * math.cos(shootAngle)
   
    Bullet:create(startX, startY, bulletDx, bulletDy, Player.bulletType)
end



function Bullets:update(dt)
    for i = 1, #self do 
        self[i]:update(dt)
    end
end

function Bullets:draw()
    for i = 1, #self  do
        self[i]:draw()
     end
 end