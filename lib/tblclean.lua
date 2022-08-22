---@return table
local function clean(input)
    if (type(input) ~= "table") then error("input needs to be a table",2) end
    local output = {}
    for k, v in pairs(input) do
        if (type(v) ~= "function") then
            if (type(v)=="table") then
                output[k] = clean(v)
            else
                output[k] = v
            end
        else
            output[k] = "function"
        end
    end
    return output
end

return clean