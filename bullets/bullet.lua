Bullets = {}

local BulletTypes = {
    CIRCLE = "circle",
    RECTANGLE = "rect",
    NONE = "none"
}


local Bullet = {}
Bullet.__index = Bullet

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
    bullet.timer = 5
    bullet.dead = false

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
    self.timer = self.timer - dt
    if self.timer < 0 then
        self.dead = true
    end

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

    -- Query for walls
    local hitWalls = World:queryCircleArea(self.x, self.y, self.radius, {'Wall'})
    if #hitWalls > 0 then
        self.dead = true
    end
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
    for _, b in ipairs(Bullets) do
        b:update(dt)
    end

    local i = #self
    while(i > 0) do
        if self[i].dead then
            table.remove(self, i)
        end
        i = i - 1
    end
end

function Bullets:draw()
    for i = 1, #self  do
        self[i]:draw()
     end
 end