--[[
    Reinstall Script - Cleans and reinstalls AtomWare V6
    Preserves user profiles and settings during reinstallation
]]

local folderToClean = "newvape"
local folderToKeep = "profiles"
local reinstallUrl = "https://raw.githubusercontent.com/endmylifehahahahahahahahaha/AtomWareV6/main/loader.lua"

-- Recursive folder deletion with preservation
local function deleteRecursive(path, keepPath)
    if path == keepPath then return end
    
    local isDir = false
    pcall(function() isDir = isfolder(path) end)
    
    if isDir then
        local files = {}
        pcall(function() files = listfiles(path) end)
        
        for _, item in ipairs(files) do
            deleteRecursive(item, keepPath)
        end
        
        if path ~= keepPath then
            pcall(function() delfolder(path) end)
        end
    else
        pcall(function() delfile(path) end)
    end
end

-- Verify folder exists
if not isfolder(folderToClean) then
    warn('[AtomWare] Folder "' .. folderToClean .. '" not found. No cleanup needed.')
    return
end

-- Check if profiles folder exists
local keepFullPath = folderToClean .. "/" .. folderToKeep
if not isfolder(keepFullPath) then
    print('[AtomWare] WARNING: Profiles folder missing - all cache will be cleared during reinstallation.')
end

-- Clean cache while preserving profiles
for _, item in ipairs(listfiles(folderToClean)) do
    if item ~= keepFullPath then
        deleteRecursive(item, keepFullPath)
    end
end

print('[AtomWare] Cleanup complete. Loading AtomWare...')
task.wait(1)

-- Reload the script
local success, result = pcall(function()
    return game:HttpGet(reinstallUrl, true)
end)

if success then
    loadstring(result)()
else
    error('[AtomWare] Failed to download reinstall script: ' .. tostring(result))
end
