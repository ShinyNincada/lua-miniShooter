local BulletTypes = {
    CIRCLE = require 'src.bullets.handgun_bullet'
    -- RECTANGLE = "rect",
    -- NONE = "none"
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
   
    local spawned = BulletTypes['CIRCLE'](startX, startY, bulletDx, bulletDy, Player.bulletType)
    
    table.insert(Bullets, spawned)
end

function Bullets:update(dt)
    for _, b in ipairs(Bullets) do
        b:update(dt)
    end

   for i=#self,1,-1 do
    if self[i].dead then
        table.remove(self, i)
    end
end
end

function Bullets:draw()
    for i = 1, #self  do
        self[i]:draw()
     end
 end