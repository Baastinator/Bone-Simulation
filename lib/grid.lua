---@class res 
---@field x number x resolution
---@field y number y resolution

---@class grid
---@field fullFill function
---@field fill function
---@field res res
---@field type string identification string
---@field GetLightLevel function
---@field SetLightLevel function
---@field grid table
---@field init function

---@return grid
_ENV.Grid = function()
    local grid = {}
    ---@type res
    local res = {}
    local Type = "grid"

    local function init(X, Y)
        res.x = X
        res.y = Y
        for y=1,Y do
            grid[y] = {}
            for x=1,X do
                grid[y][x] = 0
            end
        end
    end

    ---@param X number
    ---@param Y number
    local function GetLightLevel(X,Y)
        if (X > 0 and Y > 0 and Y < res.y and X < res.x) then
            X = math.floor(X)
            Y = math.floor(Y)
            return grid[Y][X]
        else return 0
        end
    end

    ---@param X number
    ---@param Y number
    ---@param Value number
    local function SetLightLevel(X,Y,Value)
        if (X >= 1 and Y >= 1 and Y < res.y and X < res.x) then
            X = math.floor(X)
            Y = math.floor(Y)
            _ENV.debug.x = X 
            _ENV.debug.y = Y
            grid[Y][X] = Value
        end
    end

    local function fill(X,Y,W,H,L)
        do --input validation
            if (type(X) ~= "number") then error("input #1 needs to be a number",2) end
            if (type(Y) ~= "number") then error("input #2 needs to be a number",2) end
            if (type(W) ~= "number") then error("input #3 needs to be a number",2) end
            if (type(H) ~= "number") then error("input #4 needs to be a number",2) end
            if (type(L) ~= "number") then error("input #5 needs to be a number",2) end
        end
        for y=1,H do
            for x=1,W do
                SetLightLevel(X+x-1,Y+y-1,L)
            end
        end
    end

    local function fullFill( L )
        for y=1,res.y do
            for x=1,res.x do
                SetLightLevel(x,y,L)
            end
        end
    end

    return {
        fullFill = fullFill,
        fill = fill,
        res = res,
        Type = Type,
        GetLightLevel = GetLightLevel,
        SetLightLevel = SetLightLevel,
        grid = grid,
        init = init
    }
end