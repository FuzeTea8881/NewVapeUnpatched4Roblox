--Aqua Private loader | 09.12.23r.
local commit = 'main'
for i,v in pairs(game:HttpGet('https://github.com/FuzeTea8881/NewVapeUnpatched4Roblox'):split('\n')) do 
	if v:find('commit') and v:find('fragment') then 
		local str = v:split('/')[5]
		commit = str:sub(0, str:find('"') - 1)
		break
	end
end
print(commit)
loadstring(game:HttpGet('https://raw.githubusercontent.com/FuzeTea8881/NewVapeUnpatched4Roblox/'..commit..'/Backend.lua', true))()
