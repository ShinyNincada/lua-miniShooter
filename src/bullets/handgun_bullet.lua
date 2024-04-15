local Bullet = {}
Bullet.__index = Bullet

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

    table.insert(Bullets, bullet)
    return bullet
end

function Bullet:explode()
    Particles:CreateRed(self.x, self.y, 0, 0)
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
    love.graphics.setColor(1, 0, 0) -- Red color for circle bullets
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(1,1,1)

    -- Query for walls
    local hitWalls = World:queryCircleArea(self.x, self.y, self.radius, {'Wall'})
    if #hitWalls > 0 then
        self:explode()
        self.dead = true
    end
end

return Bullet