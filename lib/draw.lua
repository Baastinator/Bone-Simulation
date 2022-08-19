---@class drawer
---@field private PixelSize number pixels per pixel
---@field public type string type identificator
---@field private lightLevelToCol function
---@field private drawFromArray1D function
---@field public drawFromArray2D function
---@field public resetPalette function
---@field public setPalette function

---@return drawer
_ENV.Draw = function()
    local PixelSize = 1 --KEEP AT 2

    local function lightLevelToCol(D)
        -- [0-1] => black-white spectrum
        -- 2 => wall (255)
        -- 3 => creature (254)
        if (type(D) ~= "number") then error("first input needs to be number",2) end
        if (D < 0) then error("first input needs to be positive",2) end
        if (D <= 1) then
            return math.floor(D*253)
        elseif (D == 2) then
            return 255
        elseif (D == 3) then
            return 254
        end
    end

    local function drawFromArray1D(x, y, T, Grid)
        if (type(x) ~= "number") then error("input #1 needs to be a number",2) end
        if (type(y) ~= "number") then error("input #2 needs to be a number",2) end
        if not (type(Grid) == "table" and Grid.Type:match("grid") == "grid") then error("input #3 needs to be a table of type grid",2) end
        local P = {}
        local Pit = 0
        P.currLightLevel = nil
        for i,v in ipairs(T) do
            if lightLevelToCol(v) == P.currLightLevel then
                if P[Pit][2] == nil then
                    P[Pit][2] = 1
                end
            P[Pit][2] = P[Pit][2] + 1
            else
                Pit = Pit + 1 
                P.currLightLevel = lightLevelToCol(v)
                P[Pit] = {}
                P[Pit][1] = i
                P[Pit][2] = 1
                P[Pit][3] = P.currLightLevel
            end
        end
        local yPosCorrection = y*PixelSize
        P.currLightLevel = nil
        -- if not (P[1][1] == 1 and P[1][2] == 954 and P[1][3] == 0) then
            for i,v in ipairs(P) do
                term.drawPixels(
                    (x+v[1])*PixelSize,
                    yPosCorrection,
                    v[3],
                    PixelSize*(v[2]),
                    PixelSize
                )
            -- end
        end
        return P
    end

    local function drawFromArray2D(x, y, Grid) -- Draws Grid onto screen at specified location
        if (type(x) ~= "number") then error("input #1 needs to be a number",2) end
        if (type(y) ~= "number") then error("input #2 needs to be a number",2) end
        if not (type(Grid) == "table" and Grid.Type:match("grid") == "grid") then error("input #3 needs to be a table of type grid",2) end
        local oT = {} 
        for i, v in ipairs(Grid.grid) do
            oT[i] = drawFromArray1D(x-1,y+i-1,v, Grid)
        end
    end

    local function setPalette()
        -- 0 - 253 plain gray
        for i=0,254 do
            term.setPaletteColor(i, colors.packRGB(i/255,i/255,i/255))
        end
        -- 254 creature
        term.setPaletteColor(254, colors.packRGB(0.75,0,0.75))
        -- 255 food
        term.setPaletteColor(255, colors.packRGB(0.5,0.5,0.5))
    end

    local function resetPalette()
        for i=0,15 do
            local r, g, b = term.nativePaletteColor(2^i)
            term.setPaletteColor(2^i, colors.packRGB(r,g,b))
        end
    end

    return {
        type="draw",
        lightLevelToCol = lightLevelToCol,
        PixelSize = PixelSize,
        drawFromArray1D = drawFromArray1D,
        drawFromArray2D = drawFromArray2D,
        resetPalette = resetPalette,
        setPalette = setPalette
    }
end