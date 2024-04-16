local Enemy = {}
local Spider = require('src.enemies.Spider')
Enemy.__index = Enemy

Enemies = {}

function Enemy:create(x, y, dx, dy)
    local enemy = {}
    setmetatable(enemy, Enemy)
    enemy.x = x
    enemy.y = y
    enemy.dx = dx
    enemy.dy = dy
    enemy.radius = 10

    table.insert(Enemies, enemy)
    return enemy
end

function Enemy:createSpider(x, y)
    Spider:create(x, y)     
end

-- function Enemy:update(dt) 
--     -- Move the enemy
--     self.x = self.x + self.dx * dt
--     self.y = self.y + self.dy * dt

--     -- -- Check for collisions with screen edges
--     if self.x + self.radius > love.graphics.getWidth() or self.x - self.radius < 0 then
--         self.dx = -self.dx
--     end
--     if self.y + self.radius > love.graphics.getHeight() or self.y - self.radius < 0 then
--         self.dy = -self.dy
--     end
-- end

function Enemy:draw()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", self.x, self.y, 11.18, 11.18)
    love.graphics.setColor(1,1,1)
end

function CreateEnemy()
    local randX = math.random(1, 250)
    local randY = math.random(1, 250)
    -- Enemy:create(Player.x, Player.y, 200, 200)
    Spider:create(Player.x + randX, Player.y +  randY)
end

function Enemies:update(dt)
    for i = 1, #self do 
        self[i]:update(dt)
    end
end

function Enemies:draw()
    for i = 1, #Enemies  do
        Enemies[i]:draw()
    end
end