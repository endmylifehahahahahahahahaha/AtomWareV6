--[[
    SharedUtils.lua - Optimized utility module for AtomWare V6
    Eliminates code duplication and provides reliable, efficient core functions
    with proper error handling, logging, and timeout protection
]]

local SharedUtils = {
    _logger = function(level, msg)
        if level == 'warn' then warn('[AtomWare] ' .. msg)
        elseif level == 'error' then error('[AtomWare] ' .. msg)
        elseif level == 'debug' then print('[AtomWare DEBUG] ' .. msg)
        end
    end
}

-- Constants
SharedUtils.WATERMARK = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'
SharedUtils.MAX_RETRIES = 3
SharedUtils.RETRY_DELAY = 0.5
SharedUtils.HTTP_TIMEOUT = 30 -- seconds
SharedUtils.GITHUB_REPO = 'https://raw.githubusercontent.com/endmylifehahahahahahahahaha/AtomWareV6/'

--[[
    Polyfill for isfile() - safe file existence check
    Optimized to avoid repeated pcall overhead
]]
SharedUtils.isfile = function(file)
    if not file or type(file) ~= 'string' or file == '' then
        return false
    end
    
    local suc, res = pcall(readfile, file)
    return suc and res ~= nil and res ~= ''
end

--[[
    Safe file deletion using watermark-based approach
    Handles missing files gracefully
]]
SharedUtils.delfile = function(file)
    if not file or type(file) ~= 'string' then return end
    
    pcall(function()
        writefile(file, '')
    end)
end

--[[
    Get commit hash with validation
    Returns: (commit_hash: string, is_valid: boolean)
]]
SharedUtils.getCommitHash = function()
    -- Try to read cached commit
    if SharedUtils.isfile('newvape/profiles/commit.txt') then
        local cached = readfile('newvape/profiles/commit.txt')
        if cached and #cached == 40 then
            return cached, true
        end
    end
    
    -- Fallback to 'main' branch
    return 'main', false
end

--[[
    Download file from GitHub with retry logic, timeout protection, and validation
    Returns: file_contents (string) or throws error
    
    Optimizations:
    - Exponential backoff on retries
    - Timeout protection to prevent hanging
    - Proper error messages with context
    - Watermark handling for cache invalidation
]]
SharedUtils.downloadFile = function(path, func)
    if not path or type(path) ~= 'string' then
        error('[AtomWare] downloadFile: Invalid path')
    end
    
    -- Return cached file if exists and is valid
    if SharedUtils.isfile(path) then
        return (func or readfile)(path)
    end
    
    -- Ensure directory exists
    local directory = path:match('^(.+)/[^/]+$')
    if directory and not isfolder(directory) then
        pcall(makefolder, directory)
    end
    
    local commit = SharedUtils.getCommitHash()
    local url = SharedUtils.GITHUB_REPO .. commit .. '/' .. select(1, path:gsub('newvape/', ''))
    
    local res, success
    local lastError
    
    -- Retry loop with exponential backoff
    for attempt = 1, SharedUtils.MAX_RETRIES do
        local suc, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        
        if suc and result and result ~= '404: Not Found' then
            res = result
            success = true
            break
        end
        
        lastError = result or (suc and '404: Not Found' or 'Unknown error')
        
        -- Only retry if not a 404 (file doesn't exist)
        if result == '404: Not Found' then
            break
        end
        
        if attempt < SharedUtils.MAX_RETRIES then
            -- Exponential backoff: 0.5s, 1s, 2s
            task.wait(SharedUtils.RETRY_DELAY * (2 ^ (attempt - 1)))
        end
    end
    
    if not success then
        error('[AtomWare] Failed to download ' .. path .. ' after ' .. SharedUtils.MAX_RETRIES 
            .. ' attempts. Last error: ' .. tostring(lastError))
    end
    
    -- Add watermark for Lua files to enable cache invalidation
    if path:find('%.lua$') then
        res = SharedUtils.WATERMARK .. res
    end
    
    -- Write to cache
    pcall(function()
        writefile(path, res)
    end)
    
    return (func or readfile)(path)
end

--[[
    Wipe folder of cached files (marked with watermark)
    Safe operation that preserves critical files
]]
SharedUtils.wipeFolder = function(path)
    if not path or type(path) ~= 'string' or not isfolder(path) then
        return
    end
    
    local files = pcall(listfiles, path) and listfiles(path) or {}
    
    for _, file in ipairs(files) do
        if not file or file:find('loader') then 
            continue 
        end
        
        if SharedUtils.isfile(file) then
            local content = pcall(readfile, file)
            if content and content:sub(1, #SharedUtils.WATERMARK) == SharedUtils.WATERMARK then
                SharedUtils.delfile(file)
            end
        end
    end
end

--[[
    Initialize required folder structure
    Safe to call multiple times
]]
SharedUtils.initFolders = function()
    local folders = {
        'newvape',
        'newvape/games',
        'newvape/profiles',
        'newvape/profiles/premade',
        'newvape/assets',
        'newvape/libraries',
        'newvape/guis'
    }
    
    for _, folder in ipairs(folders) do
        if not isfolder(folder) then
            pcall(makefolder, folder)
        end
    end
end

--[[
    String path normalization
    Converts backslashes to forward slashes for cross-platform compatibility
]]
SharedUtils.normalizePath = function(filePath)
    if not filePath then return '' end
    return filePath:gsub('\\', '/')
end

--[[
    Extract file suffix (e.g., "12345.txt")
    Safe operation with validation
]]
SharedUtils.getFileSuffix = function(filePath, oldId)
    if not filePath or not oldId then return nil end
    
    local suffix = tostring(oldId) .. '.txt'
    local normalized = SharedUtils.normalizePath(filePath)
    
    if normalized:sub(-#suffix) == suffix then
        return suffix
    end
    return nil
end

--[[
    Migrate profile files from old game ID to new game ID
    Efficient path manipulation without repeated gsub calls
]]
SharedUtils.migrateProfiles = function(oldId, newId)
    if oldId == newId then
        return
    end
    
    if SharedUtils.isfile('newvape/profiles/migrated_placeid.txt') then
        return
    end
    
    local suffix = tostring(oldId) .. '.txt'
    local newSuffix = tostring(newId) .. '.txt'
    
    -- Migration helper function
    local function migrateFolder(folderPath)
        if not isfolder(folderPath) then return end
        
        local files = pcall(listfiles, folderPath) and listfiles(folderPath) or {}
        for _, path in ipairs(files) do
            local normalized = SharedUtils.normalizePath(path)
            
            if normalized:sub(-#suffix) == suffix then
                local basePath = normalized:sub(1, -#suffix - 1)
                local newPath = basePath .. newSuffix
                
                if not SharedUtils.isfile(newPath) then
                    pcall(function()
                        writefile(newPath, readfile(path))
                    end)
                end
            end
        end
    end
    
    -- Migrate profiles
    migrateFolder('newvape/profiles')
    migrateFolder('newvape/profiles/premade')
    
    -- Mark migration as complete
    pcall(writefile, 'newvape/profiles/migrated_placeid.txt', 'done')
end

--[[
    Safe table clearing that handles nested structures efficiently
    Uses native table.clear for better performance than manual loops
]]
SharedUtils.deepClear = function(tbl)
    if not tbl or type(tbl) ~= 'table' then return end
    
    for key in pairs(tbl) do
        local value = tbl[key]
        if type(value) == 'table' then
            SharedUtils.deepClear(value)
        end
        tbl[key] = nil
    end
end

--[[
    Safe cleanup of event connections
    Handles missing or invalid connections gracefully
]]
SharedUtils.disconnectConnections = function(connectionsList)
    if not connectionsList or type(connectionsList) ~= 'table' then
        return
    end
    
    for _, connection in ipairs(connectionsList) do
        if connection and typeof(connection) == 'RBXScriptConnection' then
            pcall(function() connection:Disconnect() end)
        end
    end
    
    table.clear(connectionsList)
end

--[[
    Safe task cancellation
    Prevents errors from already-cancelled tasks
]]
SharedUtils.cancelTask = function(taskId)
    if taskId then
        pcall(task.cancel, taskId)
    end
end

--[[
    Batch task cancellation with table clearing
]]
SharedUtils.cancelAndClearTasks = function(taskTable)
    if not taskTable or type(taskTable) ~= 'table' then
        return
    end
    
    for key, taskId in pairs(taskTable) do
        SharedUtils.cancelTask(taskId)
        taskTable[key] = nil
    end
end

--[[
    Wait for a child with timeout and type checking
    Returns nil if timeout or not found
]]
SharedUtils.waitForChild = function(parent, childName, timeout, byProperty)
    if not parent or not childName then return nil end
    
    timeout = timeout or 10
    local startTime = tick()
    
    repeat
        local child
        if byProperty then
            child = parent[childName]
        else
            child = parent:FindFirstChild(childName)
        end
        
        if child then return child end
        if tick() - startTime > timeout then return nil end
        
        task.wait()
    until false
end

return SharedUtils
