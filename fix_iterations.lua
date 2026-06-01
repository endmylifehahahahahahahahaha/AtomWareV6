-- Lua script to fix unsafe table iterations
local function fixFile(filepath)
    local file = assert(io.open(filepath, 'r'))
    local content = file:read('*a')
    file:close()
    
    local count = 0
    local original_count = 0
    
    -- Count original unsafe iterations
    for match in content:gmatch("for _, v in entitylib%.List do") do
        original_count = original_count + 1
    end
    
    -- Replace with safe iterations
    content = content:gsub("for _, v in entitylib%.List do", "for _, v in ipairs(entitylib.List) do")
    
    -- Count how many were replaced
    for match in content:gmatch("for _, v in ipairs(entitylib%.List) do") do
        count = count + 1
    end
    
    -- Write back if changes made
    if original_count > 0 then
        local file = assert(io.open(filepath, 'w'))
        file:write(content)
        file:close()
        print(string.format("%s: Fixed %d/%d iterations", filepath, count, original_count))
        return true
    end
    return false
end

-- Fix both files
fixFile("games/universal.lua")
fixFile("games/6872274481.lua")

print("Done!")
