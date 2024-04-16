EnemyType = {
    SPIDER = require('src.enemies.Spider')
}
Enemies = {}

function CreateEnemy(startX, startY, type, args)
    local randX = math.random(1, 250)
    local randY = math.random(1, 250)

    local spawned = EnemyType[type](Player.x + randX, Player.y +  randY)
    
    function spawned:lookForPlayer() 
        if self.physics == nil then 
            return false
        end

        local ex = self.physics:getX()
        local ey = self.physics:getY()

        -- The listening threshold 
        if(distanceBetween(ex, ey, Player.collider:getX(), Player.collider:getY()) <= 30) then
            return true
        end
    end

    function spawned:hit() 
        self.health = self.health - 1
    end

    function spawned:moveLogic(dt)
        if self.health <= 0 then
            self.dead = true
        end   
    end

    function spawned:genericUpdate(dt)
        if(self.flashTimer > 0) then
            self.flashTimer = self.flashTimer - dt
        end 
    end

    table.insert(Enemies, spawned)
end

function Enemies:update(dt)
    for i = 1, #self do 
        self[i]:update(dt)
    end
end

function Enemies:draw()
    for i = 1, #self  do
        if self[i].flashTimer > 0 then love.graphics.setShader(shaders.whiteout) end
        Enemies[i]:draw()
        love.graphics.setShader()
    end
end