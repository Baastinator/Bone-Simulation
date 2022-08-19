---@class point
---@field pos vector
---@field vel vector
---@field mass number
---@field fixed boolean

---@param x number x positon
---@param y number y positon
---@param vX number x velocity
---@param vY number y velocity
---@param fixed? boolean fixed position
---@return point 
_ENV.point = function (x, y, vX, vY, fixed)
    do -- input validation
        if (type(x) ~= "number") then error("input #1 needs to be a number",2) end
        if (type(y) ~= "number") then error("input #2 needs to be a number",2) end
        if (type(vX) ~= "number") then error("input #3 needs to be a number",2) end
        if (type(vY) ~= "number") then error("input #4 needs to be a number",2) end
    end
    return {
        pos = vec({x,y}),
        vel = vec({vX,vY}),
        mass = 1,
        fixed = fixed or false
    }
end