---@diagnostic disable: undefined-field
-- imports

package.path = "/?.lua;/lib/?.lua"

require("mathb")
require("linalg")
require("List")
require("tblclean")
require("grid")
require("draw")
require("point")

-- globals


local Grid = Grid()
local draw = Draw()
local gui

local res = {}
local tres = {}

local debugMode = true
local gameLoop = true
local paused = false
local UPS = 165
local framesElapsed = 0

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

    
end

local function PreUpdate() 
end


local function Update()
    for i=1,res.x do
        if (Grid.GetLightLevel(i,res.y/2) < 0.3) then
            Grid.SetLightLevel(i,res.y/2,0.3)
        end
        if (i <= res.y and Grid.GetLightLevel(res.x/2,i) < 0.3) then
            Grid.SetLightLevel(res.x/2,i,0.3)
        end
    end
end

local function Render()
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
if err ~= 1 then printError(err) end