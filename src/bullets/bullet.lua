local BulletTypes = {
    CIRCLE = "circle",
    RECTANGLE = "rect",
    NONE = "none"
}


Bullets = {}

local Bullet = require 'src.bullets.handgun_bullet'
function Bullets:load()
    Bullets.BulletSpeed = 20
end

function Bullets:createBullet(shootAngle)
    -- Logtest = "Create Bullet"
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