---@diagnostic disable: undefined-field
-- imports

package.path = "/?.lua;/lib/?.lua"

local Mathb = require("mathb")
local la = require("linalg")
local List = require("List")
local clean = require("tblclean")
local Grid = require("grid")
local Draw = require("draw")
local point = require("point")
local bone = require("bone")
local drawLine = require("paint")

-- globals


local Grid = Grid()
local draw = Draw()
local gui

---@type res
local res = {}
---@type res
local tres = {}

local debugMode = true
local gameLoop = true
local paused = false
local framesElapsed = 0
_ENV.debug = {}

local nodes = List('nodes')
local bones = List('bones')

local fpsTime, updateTime

local ui = {
    height = 50
}

-- side functions

local function userInput()
    local key, event, is_held
    while true do
---@diagnostic disable-next-line: undefined-field
        event, key, is_held = os.pullEvent("key")
        if key == keys.space then
            gameLoop = false
        elseif key == keys.d then
            error("\n\nProgram terminated",0)
        end
        
        key = nil
    end
end

-- main functions

local function Init()
    tres.x, tres.y = term.getSize(1)
    res.x = math.floor(tres.x / draw.PixelSize)
    res.y = math.floor(tres.y / draw.PixelSize)
    Grid.init(res.x,res.y)
    term.clear()
    term.setCursorPos(1,1)
    term.setGraphicsMode(2)
    draw.setPalette()
    term.drawPixels(0,0,0,tres.x,tres.y)
end

local function Start()
    fpsTime = ccemux.milliTime()
    updateTime = fpsTime



    nodes:add(point(0,0,0,0,true))
    nodes:add(point(0.0001,2,0,0))
    nodes:add(point(1,1,0,0))
    nodes:add(point(-1,1,0,0,true))

    bones:add(bone(nodes:get(1),nodes:get(2)))
    bones:add(bone(nodes:get(2),nodes:get(3)))
    bones:add(bone(nodes:get(3),nodes:get(4)))
    bones:add(bone(nodes:get(1),nodes:get(3)))
    bones:add(bone(nodes:get(2),nodes:get(4)))
    bones:add(bone(nodes:get(4),nodes:get(1)))
end

local function PreUpdate()

end


local function Update()
    local dt = ccemux.milliTime()-fpsTime
    fpsTime = ccemux.milliTime()

    debug.nodes = nodes
    local speed = 1/1000
    local g = 9.81
    local force = {}

    for i, n in ipairs(nodes) do
        force[i] = (
            la.vec({0,-g}) --gravity
        )
    end

    for i, n in ipairs(nodes) do
        if (not n.fixed) then
            n.vel = n.vel + (speed * dt * force[i] * (1 / n.mass))
            n.pos = n.pos + (speed * dt * n.vel)
        end
    end
end

local function Render()
    local size = 20
    local scale = 100

    for iN, n in ipairs(nodes) do
        local X = scale*n.pos[1]
        local Y = scale*n.pos[2]
        for y = Y-size/2, Y+size/2 do
            for x = X-size/2, X+size/2 do
                if ((y-Y)^2+(x-X)^2 <= (size/2)^2) then
                    Grid.SetLightLevel(res.x/2+x,res.y/2+y,1)
                end
            end 
        end
    end

    for iB, b in ipairs(bones) do
---@diagnostic disable-next-line: param-type-mismatch
        drawLine(scale * b.A.pos + la.vec({res.x/2, res.y/2}), scale * b.B.pos + la.vec({res.x/2, res.y/2}),1,Grid)
    end

    for i=1,res.x do
        if (Grid.GetLightLevel(i,res.y/2) < 0.3) then
            Grid.SetLightLevel(i,res.y/2,0.3)
        end
        if (i <= res.y and Grid.GetLightLevel(res.x/2,i) < 0.3) then
            Grid.SetLightLevel(res.x/2,i,0.3)
        end
    end
    
    draw.drawFromArray2D(0,0,Grid)
    framesElapsed = framesElapsed + 1;
end

local function Closing()
    term.clear()
    term.setGraphicsMode(0)
    draw.resetPalette()
    if not debugMode then
        term.clear()
        term.setCursorPos(1,1)
    end
end

-- main structure

local function main()
    Init()
    Start()
    while gameLoop do
        Grid.init(res.x,res.y)
        PreUpdate()
        Update()
        Render()
        os.queueEvent("")
        os.pullEvent("")
    end
    Closing()
end

-- execution

local ok, err = pcall(parallel.waitForAny,main,userInput)
if not ok then Closing() end
if err ~= 1 then printError(textutils.serialise(clean(_ENV.debug))..err) end