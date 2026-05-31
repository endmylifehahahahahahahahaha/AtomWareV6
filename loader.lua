-- Load shared utilities for optimized file operations and cleanup
local SharedUtils = loadstring(readfile('newvape/libraries/SharedUtils.lua'))()

-- Initialize folder structure
SharedUtils.initFolders()

if not shared.VapeDeveloper then
	-- Check for updates asynchronously
	local updateCheckSuccess = false
	local newCommit = SharedUtils.getCommitHash()
	
	-- Only fetch if needed
	if newCommit == 'main' then
		local suc, subbed = pcall(function() 
			return game:HttpGet('https://github.com/endmylifehahahahahahahahaha/AtomWareV6')
		end)
		
		if suc and subbed then
			local commitStart = subbed:find('currentOid')
			if commitStart then
				local extractedCommit = subbed:sub(commitStart + 13, commitStart + 52)
				if extractedCommit and #extractedCommit == 40 then
					newCommit = extractedCommit
					updateCheckSuccess = true
				end
			end
		end
	end
	
	-- Compare versions and wipe if needed
	local cachedCommit = SharedUtils.isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or ''
	if newCommit ~= cachedCommit then
		SharedUtils.wipeFolder('newvape')
		SharedUtils.wipeFolder('newvape/games')
		SharedUtils.wipeFolder('newvape/guis')
		SharedUtils.wipeFolder('newvape/libraries')
	end
	
	-- Update cache
	pcall(function()
		writefile('newvape/profiles/commit.txt', newCommit)
	end)
end

return loadstring(SharedUtils.downloadFile('newvape/main.lua'), 'main')({
    Username = shared.ValidatedUsername
})
