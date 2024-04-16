local Spider = {}
Spider.__index = Spider
Spider.spriteSheet = love.graphics.newImage('sprites/enemies/Spider.png')
Spider.grid = Anim8.newGrid(16, 16, Spider.spriteSheet:getWidth(), Spider.spriteSheet:getHeight())

function SpiderInit(x, y) 
    local spiderSpawn = {x = x, y = y}
    setmetatable(spiderSpawn, Spider)

    -- Stats
    spiderSpawn.health = 5
    spiderSpawn.dead = false
    
    -- Animations setup
    spiderSpawn.animations = {}
    spiderSpawn.animations.idle = Anim8.newAnimation(spiderSpawn.grid('1-2', 1), 0.5)
    spiderSpawn.animations.walk = Anim8.newAnimation(spiderSpawn.grid('1-4', 2), 1)
    spiderSpawn.animations.onHit = Anim8.newAnimation(spiderSpawn.grid('1-2', 3), 0.5)
    spiderSpawn.animations.attack = Anim8.newAnimation(spiderSpawn.grid('1-5', 4), 1)
    spiderSpawn.animations.die = Anim8.newAnimation(spiderSpawn.grid('1-1', 5), 20)
    spiderSpawn.currentAnim = spiderSpawn.animations.idle

    -- Physics setup
    spiderSpawn.physics = World:newBSGRectangleCollider(x, y, 16,16,3)
    spiderSpawn.physics:setCollisionClass('Enemy')
    spiderSpawn.physics:setFixedRotation(true)
    spiderSpawn.physics:setType("kinematic")
    spiderSpawn.physics.parent = spiderSpawn

    -- Ultils stats
    spiderSpawn.flashTimer = 0

    return spiderSpawn
end

function Spider:update(dt) 
    self.currentAnim:update(dt)
end

function Spider:draw()
    local ex, ey = self.physics:getPosition()
    love.graphics.setColor(1, 0, 0)
    self.currentAnim:draw(self.spriteSheet, ex, ey, 0, 1, 1, 8, 8)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", ex - 12, ey - 24, 5 * self.health, 10)
end

return SpiderInit