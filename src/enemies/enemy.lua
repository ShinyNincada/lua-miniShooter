EnemyType = {
    SPIDER = require('src.enemies.Spider')
}
Enemies = {}

function CreateEnemy(startX, startY, type, args)
    local randX = math.random(1, 250)
    local randY = math.random(1, 250)

    local spawned = EnemyType[type](Player.x - 200, Player.y - 300 +  randY)
    
    -- Enemy states:
    -- 0: idle, standing
    -- 1: wander, stopped
    -- 1.1: wander, moving
    -- 99: alert
    -- 100: attacking
    spawned.state = 1

    spawned.wanderRadius = 30
    spawned.wanderSpeed = 15
    spawned.wanderTimer =  0.5 + math.random() * 2
    spawned.wanderBufferTimer = 0
    spawned.wanderDir = Vector(1,1)
    spawned.chase = false
    spawned.grounded = true

    function spawned:floatDown(dest)
        self.tween = flux.to(self, self.floatTIme, {floatY = dest}):ease('sineinout'):oncomplete(function() self:floatUp(self.floatMax) end)
    end

    function spawned:floatUp(dest)
        self.tween = flux.to(self, self.floatTIme, {floatY = dest}):ease('sineinout'):oncomplete(function() self:floatDown(self.floatMax*-1) end)
    end

    function spawned:lookForPlayer() 
        if self.physics == nil then 
            return false
        end

        local ex, ey = self.physics:getPosition()

        -- The listening threshold 
        -- if(distanceBetween(ex, ey, Player.collider:getX(), Player.collider:getY()) < 30) then
        --     return true
        -- end

        -- Only look at the player if they are in the direction enemy facing
        -- if self.state >= 1 and self.state < 2 then
        --     -- If idle or wandering 
        --     if self.scaleX == 1 and ex > Player.collider:getX() then
        --         return false
        --     end
        --     if self.scaleX == -1 and ex < Player.collider:getX() then
        --         return false
        --     end
        -- end
        
        -- line of queries going towards the player
        
        -- local obstacles = World:queryLine(ex, ey, Player.x, Player.y, {'Wall'})
        -- if #obstacles > 0 then
        --     Logtest = "YES"
        --     return false
        -- end
        local toPlayerVector = getPlayerToSelfVector(ex, ey)
        local hitPlayer = World:queryLine(ex, ey, Player.x, Player.y, {'Player'})
        if #hitPlayer > 0 then
            -- Logtest = "Found"
            return true
        end

        return false
    end

    function spawned:wanderUpdate(dt)
        Logtest = tostring(self.state)
        if(self.state < 1 or self.state >= 2) then
            -- If not idle or wandering
            return
        end

        if(self.wanderTimer > 0) then
            self.wanderTimer = self.wanderTimer - dt
        end

        if(self.wanderBufferTimer > 0) then
            self.wanderBufferTimer = self.wanderBufferTimer - dt
        end

        if(self.wanderTimer < 0) then
            -- if idle for a while -> wandering
            self.state = 1.1
            self.wanderTimer = 0

            local ex = self.physics:getX()
            local ey = self.physics:getY()

            if(ex < self.x and ey < self.y) then
                self.wanderDir = Vector(0, 1)
            elseif ex < self.x and ey > self.y then
                self.wanderDir = Vector(0, -1)
            elseif(ex > self.x and ey < self.y) then
                self.wanderDir = Vector(-1, 0)
            else
                self.wanderDir = Vector(1, 0)  
            end

            self.wanderBufferTimer = 0.2
            self.wanderDir:rotateInplace(math.pi/-2 * math.random())
        end

        if self.state == 1.1 and self.physics then
            -- if wandering and has a physics body
            local vx = self.wanderDir.x * self.wanderSpeed
            local vy = self.wanderDir.y * self.wanderSpeed

            self.physics:setLinearVelocity(vx, vy)

            if(distanceBetween(self.physics:getX(), self.physics:getY(), self.x, self.y) > self.wanderRadius and self.wanderBufferTimer <= 0) then
                -- If distance from enemy itself and the wander positioning > wanderRadius
                -- Set back to idle then reset wanderTimer
                self.state = 1
                self.wanderTimer = 1 + math.random(0.1, 1)
            end
        end
    end

    function spawned:setScaleX()
        local px, py = Player.collider:getPosition()
        local ex, ey = self.physics:getPosition()

        if self.state >= 99 then
            -- If attacking or player spotted
            if px < ex then
                self.scaleX  = -1
            elseif px > ex then
                self.scaleX = 1
            end
        end


        if self.state >= 1 and self.state < 2 then
            -- If idle or wandering rotate follow the moveDir
            if self.wanderDir.x < 0 then
                self.scaleX = -1
            else
                self.scaleX = 1
            end
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
        if self.state < 99 then
            -- If not in warning state
            if self:lookForPlayer() then
                -- If found player in range
                self.state = 99 -- alerted state
            end
        end

        if self.state >= 100 then
            -- If in attack state
            -- self.dir = vector(px - ex, py - ey):normalized() * self.magnitude
            self.currentAnim = self.animations.attack

            if(self.chase) then
                if self.grounded  then
                    local vx = self.wanderDir.x * self.wanderSpeed
                    local vy = self.wanderDir.y * self.wanderSpeed
        
                    self.physics:setLinearVelocity(vx, vy)        
                end
            end
        end

        if self.health <= 0 then
            self.dead = true
        end   
    end

    function spawned:genericUpdate(dt)
        if(self.flashTimer > 0) then
            self.flashTimer = self.flashTimer - dt
        end 

        self:wanderUpdate(dt)
        self:moveLogic(dt)
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
            table.remove(Enemies, i)
        end
    end
  
end

function Enemies:draw()
    for i = 1, #self  do
        if self[i].flashTimer > 0 then love.graphics.setShader(shaders.whiteout) end
        Enemies[i]:draw()
        local ex, ey =self[i].physics:getPosition()
        local playerX, playerY = Player.collider:getPosition()
        love.graphics.line(ex, ey, playerX, playerY)
        love.graphics.setShader()
    end
end