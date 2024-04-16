Particles = {}

local redParticle = require 'src.particles.redParticle'

function Particles:CreateRed(x, y, dx, dy)
    redParticle:create(x, y, dx, dy)

    -- Same update for all kind of particles
    function redParticle:genericUpdate(dt) 
        self.timer = self.timer - dt
        if self.timer < 0 then
            self.dead = true
        end    
    end
end

function Particles:update(dt)
    for _, b in ipairs(Particles) do
        b:update(dt)
        b:genericUpdate(dt)
    end

    local i = #self
    while(i > 0) do
        if self[i].dead then         
            table.remove(self, i)
        end
        i = i - 1
    end
end

function Particles:draw()
    for i = 1, #self  do
        self[i]:draw()
     end
 end