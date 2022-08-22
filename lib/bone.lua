---@class bone
---@field A point
---@field B point
---@field length number length of the bone

---@param A point 
---@param B point
---@return bone
local function bone(A, B)
    do -- input validation
    end
    return setmetatable({
        A = A,
        B = B,
        length = (B.pos - A.pos):length()
    },{})
end

return bone