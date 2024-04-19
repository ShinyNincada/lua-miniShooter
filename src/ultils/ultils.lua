function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function getPlayerToSelfVector(x, y)
    return Vector(x - Player.collider:getX(), y - Player.collider:getY()):normalized()
end

function convertTo2D(mapData, width, height)
    local map2D = {}
    for y = 1, height do
        map2D[y] = {}
        for x = 1, width do
            -- Calculate the index in the 1D table
            local index = (y - 1) * width + x
            -- Assign the value to the 2D table
            map2D[y][x] = mapData[index]
        end
    end
    return map2D
end