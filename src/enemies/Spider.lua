local Spider = {}

Spider.__index = Spider
Spider.spriteSheet = love.graphics.newImage('sprites/enemies/Spider.png')
Spider.grid = Anim8.newGrid(16, 16, Spider.spriteSheet:getWidth(), Spider.spriteSheet:getHeight())
Spider.animations = {}
Spider.animations.idle = Anim8.newAnimation(Spider.grid('1-2', 1), 0.5)
Spider.animations.walk = Anim8.newAnimation(Spider.grid('1-4', 2), 1)
Spider.animations.onHit = Anim8.newAnimation(Spider.grid('1-2', 3), 0.5)
Spider.animations.attack = Anim8.newAnimation(Spider.grid('1-5', 4), 1)
Spider.animations.die = Anim8.newAnimation(Spider.grid('1-1', 5), 20)

Spider.currentAnim = Spider.animations.idle

function Spider:create(x, y) 
    local spiderSpawn = {x = x, y = y}
    setmetatable(spiderSpawn, Spider)
    table.insert(Enemies, spiderSpawn)
    return spiderSpawn
end

function Spider:update(dt) 
    Spider.currentAnim:update(dt)
end

function Spider:draw()
    self.currentAnim:draw(self.spriteSheet, self.x, self.y, 0, 1, 1, 8, 8)
end

return Spider