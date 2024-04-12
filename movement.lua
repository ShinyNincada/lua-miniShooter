function Normalize(velX, velY)
    local length = math.sqrt(velX^2 + velY^2)

    if length == 0 then
        return 0, 0
    else
        return velX / length, velY / length
    end
end

