---@class EnemyTypeTable: A table containing mappings of enemy types to their corresponding constructors
EnemyType = {
    SPIDER = require('src.enemies.Spider')
}

-- @class EnemiesTable: A table containing enemy objects
Enemies = {}

-- function TestClone() 
--     print("test 1")
--     Ltest = "minh 1"
-- end

--- Creates a new enemy object and adds it to the Enemies table
---@param startX number: The starting X-coordinate of the enemy
---@param startY number: The starting Y-coordinate of the enemy
---@param type string: The type of enemy to create
---@param args table: Additional arguments for creating the enemy
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
    spawned.chaseSpeed = 30
    spawned.grounded = true

        --[[ 
            Checks if the enemy can see the player.
            @return boolean: True if the player is in sight, false otherwise.
        ]]
        function spawned:lookForPlayer() 
            if self.physics == nil then 
                return false
            end
    
            local ex, ey = self.physics:getPosition()
    
            local toPlayerVector = getPlayerToSelfVector(ex, ey)
            local hitPlayer = World:queryLine(ex, ey, Player.x, Player.y, {'Player'})
            if #hitPlayer > 0 then
                -- Logtest = "Found"
                return true
            end
    
            return false
        end

        --[[
            Updates the wandering behavior of the enemy.
            @param dt number: The delta time.
        ]]
        function spawned:wanderUpdate(dt)
            LogTest = tostring(self.state)
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
                self.currentAnim = self.animations.walk
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
                    self.currentAnim = self.animations.idle
                    self.physics: setLinearVelocity(0, 0)
                    self.wanderTimer = 1 + math.random(0.1, 1)
                end
            end
        end

        --[[
            Finds a path from the enemy's current position to the player's position.
            @return table: The path to the player.
        ]]
        function spawned:findPlayer()
            -- Library setup
            local mapData = require('sprites.mapTiles.cityTest')
            local converted2D = convertTo2D(mapData.layers[1].data, 50 , 50)
            local grid = JumperGrid(converted2D)
            local walkable = 1
            local finder = Pathfinder(grid, 'JPS', walkable)
            local startX, startY = math.floor(self.physics:getX() / 16) + 1, math.floor(self.physics:getY() / 16) + 1
            local endX, endY = math.floor(Player.collider:getX() / 16) + 1, math.floor(Player.collider:getY() / 16) + 1
    
            local path = finder:getPath(startX, startY, endX, endY)
            return path
        end

        --[[
            Orders the enemy to move along the specified path.
            @param path table: The path for the enemy to follow.
        ]]
        function spawned:orderMove(path)
            if path then
                self.path = path -- the path to follow
                self.isMoving = true -- whether or not the player should start moving
                self.cur = 1 -- indexes the current reached step on the path to follow
                self.there = true -- whether or not the player has reached a step
            end
    
            if(self.path) then
                self:FollowPath()
            end
        end
    
        --[[
            Moves the enemy towards the specified goal position.
            @param goalX number: The X-coordinate of the goal position.
            @param goalY number: The Y-coordinate of the goal position.
            @param dt number: The delta time.
        ]]
        function spawned:moveTowards(goalX, goalY, dt)
            local ex, ey = self.physics:getPosition()
            local dir = Vector.new(goalX - ex, goalY - ey)
            dir = dir:normalized()
            
            local newVel = dir * self.chaseSpeed
            self.physics:setLinearVelocity(newVel.x, newVel.y)
        end
        
        --  Moves the enemy towards the next point in its path.
        function spawned:FollowPath()
            if not self.path then return end
            self:moveTowards((self.path[1].x) * 16 + 8, (self.path[1].y) * 16 + 8) -- Move bot towards the current point in the path
        end
        
        --  Draws the path followed by the enemy.
        function spawned:drawPath()
            if not self.path then return end -- If path is nil, do nothing
        
            love.graphics.setColor(0, 1, 0) -- Set color to green
        
            -- Iterate through each coordinate in the path
            for i = 1, #self.path - 1 do
                -- Draw a line segment between current and next coordinate
                love.graphics.line((self.path[i].x - 1) * 16 + 8, (self.path[i].y - 1) * 16 + 8, (self.path[i + 1].x - 1) * 16 + 8, (self.path[i + 1].y - 1) * 16 + 8)
            end
    
            love.graphics.setColor(1, 1, 1) -- Set color to green
        end
    
        --  Sets the scale of the enemy based on its state.
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
    
        --  Handles logic for when the enemy is hit.
        function spawned:hit() 
            self.health = self.health - 1
            if(self.health <= 0) then
                self.health = 0
            end
            self.flashTimer = 0.175
        end

        --[[
            Handles the logic for the enemy's movement.
            @param dt number: The delta time.
        ]]
        function spawned:moveLogic(dt)
            self:findPlayer()
    
            if self.state < 99 then
                -- If not in warning state
                if self:lookForPlayer() then
                    -- If found player in range
                    self.state = 99 -- alerted state
                    self.currentAnim = self.animations.warn
                end
            end
    
            if self.state == 99 then
                self:orderMove(self:findPlayer())
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

        --[[
           Updates the enemy's behavior.
           @param dt number: The delta time.
        ]]
        function spawned:genericUpdate(dt)
            if(self.flashTimer > 0) then
                self.flashTimer = self.flashTimer - dt
            end 
    
            self:wanderUpdate(dt)
            self:moveLogic(dt)
            self:setScaleX()
        end

    table.insert(Enemies, spawned)
end

--- Destroys dead enemies from the Enemies table
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

--- Updates all enemies in the Enemies table
---@param dt number: The delta time
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

--- Draws all enemies in the Enemies table
function Enemies:draw()
    for i = 1, #self  do
        if self[i].flashTimer > 0 then love.graphics.setShader(shaders.whiteout) end
        Enemies[i]:draw()
        local ex, ey =self[i].physics:getPosition()
        local playerX, playerY = Player.collider:getPosition()
        love.graphics.line(ex, ey, playerX, playerY)
        love.graphics.setShader()

        self[i]:drawPath()
    end
end