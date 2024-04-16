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
        if(self.health <= 0) then
            self.health = 0
        end
        self.flashTimer = 0.175
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

        spawned:moveLogic(dt)
    end

    table.insert(Enemies, spawned)
end

function Enemies:destroyDead()
    local i = #Enemies
    while i > 0 do
        if Enemies[i].dead then
            if Enemies[i].physics then
                Enemies[i].physics:destroy()
            end
            table.remove(Enemies, i)
        end
        i = i - 1
    end
end

function Enemies:update(dt)
    for i,e in ipairs(self) do
        e:update(dt)
        e:genericUpdate(dt)
    end

    -- Iterate through all enemies in reverse to remove the dead ones
    for i=#Enemies,1,-1 do
        if Enemies[i].dead then
            if Enemies[i].physics ~= nil then
                Enemies[i].physics:destroy()
            end
            Logtest = "testtt"

            table.remove(Enemies, i)
        end
    end
  
end

function Enemies:draw()
    for i = 1, #self  do
        if self[i].flashTimer > 0 then love.graphics.setShader(shaders.whiteout) end
        Enemies[i]:draw()
        love.graphics.setShader()
    end
end