local Particle = {}
Particle.__index = Particle
Particle.spriteSheet = love.graphics.newImage('sprites/particles/red_trigger.png')
Particle.grid = Anim8.newGrid(32, 32, Particle.spriteSheet:getWidth(), Particle.spriteSheet:getHeight())
Particle.animations = {}
Particle.animations.explode = Anim8.newAnimation(Particle.grid(1-4, 1), 1)

function Particle:create(x, y, dx, dy, parType)
    local par = {}
    setmetatable(par, Particle)

    par.x = x
    par.y = y
    par.dx = dx
    par.dy = dy
    par.type = parType
    par.radius = 5
    par.width = 10
    par.height = 10
    par.timer = 1.5
    par.dead = false

    table.insert(Particles, par)
    return par
end


function Particle:update(dt)
    self.timer = self.timer - dt
    if self.timer < 0 then
        self.dead = true
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    Particle.animations.explode:update(dt)
end

function Particle:draw()
    Player.currentAnim:draw(Particle.spriteSheet, self.x, self.y, 0, 1, 1, 8, 8)
    love.graphics.setColor(1,1,1)
end

return Particle