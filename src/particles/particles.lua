Particles = {}

local redParticle = require 'src.particles.redParticle'

function Particles:CreateRed(x, y, dx, dy)
    redParticle:create(x, y, dx, dy)
end

function Particles:update(dt)
    for _, b in ipairs(Particles) do
        b:update(dt)
    end

    local i = #self
    while(i > 0) do
        if self[i].dead then
            Logtest = "100" .. self[i].x
         
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