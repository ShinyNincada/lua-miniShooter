function Normalize(velX, velY)
    local length = math.sqrt(velX^2 + velY^2)
    local decay = 0.9

    if length == 0 then
        return 0, 0
    else
        return velX / length, velY / length
    end
end

