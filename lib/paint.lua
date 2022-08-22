---@param v2Start vector
---@param v2End vector
---@param LL number
---@param grid grid
local function drawLine(v2Start, v2End, LL, grid)

    if v2Start[1] == v2End[1] and v2Start[2] == v2End[2] then
        grid.SetLightLevel(v2Start[1], v2Start[2], LL)
        return
    end
    
    -- looks if min x is start or end
    local minX = math.min(v2Start[1], v2End[1])
    local maxX, minY, maxY
    if minX == v2Start[1] then
        -- if start is small, start becomes min and end becomes max
        minY = v2Start[2]
        maxX = v2End[1]
        maxY = v2End[2]
    else
        -- otherwise, end becomes min and start becomes max 
        -- y ignored, cool ideas
        minY = v2End[2]
        maxX = v2Start[1]
        maxY = v2Start[2]
    end

    -- TODO: clip to screen rectangle?
    -- no

    local xDiff = maxX - minX
    local yDiff = maxY - minY

    if xDiff > math.abs(yDiff) then
        local y = minY
        local dy = yDiff / xDiff
        for x = minX, maxX do
            grid.SetLightLevel(x, math.floor(y + 0.5), LL)
            y = y + dy
        end
    else
        local x = minX
        local dx = xDiff / yDiff
        if maxY >= minY then
            for y = minY, maxY do
                grid.SetLightLevel(math.floor(x + 0.5), y, LL)
                x = x + dx
            end
        else
            for y = minY, maxY, -1 do
                grid.SetLightLevel(math.floor(x + 0.5), y, LL)
                x = x - dx
            end
        end
    end
end

return drawLine