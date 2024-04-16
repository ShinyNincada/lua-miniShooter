local Particle = {}
Particle.__index = Particle
Particle.spriteSheet = love.graphics.newImage('sprites/particles/red_trigger.png')
Particle.grid = Anim8.newGrid(16, 16, Particle.spriteSheet:getWidth(), Particle.spriteSheet:getHeight())
Particle.animations = {}
Particle.animations.explode = Anim8.newAnimation(Particle.grid('1-4', 1), 0.3)

function Particle:create(x, y, dx, dy)
    local par = {}
    setmetatable(par, Particle)

    par.x = x
    par.y = y
    par.dx = dx
    par.dy = dy
    par.radius = 5
    par.width = 10
    par.height = 10
    par.timer = 0.3
    par.dead = false

    table.insert(Particles, par)
    return par
end


function Particle:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    Particle.animations.explode:update(dt)
end

function Particle:draw()
    Particle.animations.explode:draw(self.spriteSheet, self.x, self.y, 0, 1, 1, 8, 8)
    love.graphics.setColor(1,1,1)
end

return Particle