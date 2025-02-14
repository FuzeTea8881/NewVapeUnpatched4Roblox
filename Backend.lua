local playersService = game:GetService("Players")
local lplr = playersService.LocalPlayer
local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end

if not isfolder("vape") then
	makefolder("vape")
end

local function displayErrorPopup(text, func)
	local oldidentity = getidentity()
	setidentity(8)
	local ErrorPrompt = getrenv().require(coreGui.RobloxGui.Modules.ErrorPrompt)
	local prompt = ErrorPrompt.new("Default")
	prompt._hideErrorCode = true
	local gui = Instance.new("ScreenGui", coreGui)
	prompt:setErrorTitle("Vape")
	prompt:updateButtons({{
		Text = "OK",
		Callback = function() 
			prompt:_close() 
			if func then func() end
		end,
		Primary = true
	}}, 'Default')
	prompt:setParent(gui)
	prompt:_open(text)
	setidentity(oldidentity)
end

local vapeWatermark = [===[--[=[
	Current Hash: placeholderGithubCommitHashStringForVape
	newvape uED (user edition)
	Discord: https://discord.gg/Qx4cNHBvJq
]=]
]===]

local function readHash(data)
	local hash = data:sub(22, 61)
	if hash == 'placeholderGithubCommitHashStringForVape' then
		return false
	end
	if hash:gsub('%W+', '') == hash then
		return hash
	end
	return false
end

local function writeHash(data, hash)
	return vapeWatermark:gsub('placeholderGithubCommitHashStringForVape', hash) .. data
end

local cachedCommits = {}

local base_commit = "main"
for i,v in pairs(game:HttpGet("https://github.com/skiddinglua/NewVapeUnpatched4Roblox"):split("\n")) do 
	if v:find("commit") and v:find("fragment") then 
		local str = v:split("/")[5]
		base_commit = str:sub(0, str:find('"') - 1)
		break
	end
end

local function getFileCommit(scripturl)
	if cachedCommits[scripturl] then
		return cachedCommits[scripturl]
	end
	local commit = base_commit
	for i,v in pairs(game:HttpGet("https://github.com/skiddinglua/NewVapeUnpatched4Roblox/commits/"..commit.."/"..scripturl):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			cachedCommits[scripturl] = commit
			break
		end
	end
	return commit
end

if not base_commit then
	displayErrorPopup("Failed to connect to github, please try using a VPN.")
	error("Failed to connect to github, please try using a VPN.")
end

local function randomString()
	local randomlength = math.random(10,100)
	local array = {}

	for i = 1, randomlength do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local loader_gui = Instance.new("ScreenGui")
loader_gui.Name = randomString()
loader_gui.DisplayOrder = 999
loader_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
loader_gui.OnTopOfCoreBlur = true
loader_gui.ResetOnSpawn = false
loader_gui.Parent = lplr.PlayerGui

local function vapeGithubRequest(scripturl)
	local oldCommit = isfile("vape/"..scripturl) and readHash(readfile("vape/"..scripturl))
	local newCommit = base_commit -- getFileCommit(scripturl)
	local replace = oldCommit ~= newCommit or not isfile("vape/"..scripturl)
	if replace then
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 66)
			textlabel.Text = `{oldCommit and 'Updating' or 'Downloading'} vape/{scripturl}{oldCommit and `\nfrom {oldCommit:sub(0, 7)} to {newCommit:sub(0, 7)}` or ''}`
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -66)
			textlabel.Parent = loader_gui
			repeat task.wait() until isfile("vape/"..scripturl)
			textlabel:Destroy()
		end)
		local suc, res
		task.delay(15, function()
			if not res and not errorPopupShown then 
				errorPopupShown = true
				displayErrorPopup("The connection to github is taking a while, Please be patient.")
			end
		end)
		suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/skiddinglua/NewVapeUnpatched4Roblox/"..newCommit.."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then
			displayErrorPopup("Failed to connect to github : vape/"..scripturl.." : "..res)
			error(res)
		end
		if scripturl:match(".lua") then res = writeHash(res, newCommit) end
		writefile("vape/"..scripturl, res)
	end
	return readfile("vape/"..scripturl)
end

local vapeAssetTable = {["vape/assets/AddItem.png"]="rbxassetid://13350763121",["vape/assets/AddRemoveIcon1.png"]="rbxassetid://13350764147",["vape/assets/ArrowIndicator.png"]="rbxassetid://13350766521",["vape/assets/BackIcon.png"]="rbxassetid://13350767223",["vape/assets/BindBackground.png"]="rbxassetid://13350767577",["vape/assets/BlatantIcon.png"]="rbxassetid://13350767943",["vape/assets/CircleListBlacklist.png"]="rbxassetid://13350768647",["vape/assets/CircleListWhitelist.png"]="rbxassetid://13350769066",["vape/assets/ColorSlider1.png"]="rbxassetid://13350769439",["vape/assets/ColorSlider2.png"]="rbxassetid://13350769842",["vape/assets/CombatIcon.png"]="rbxassetid://13350770192",["vape/assets/DownArrow.png"]="rbxassetid://13350770749",["vape/assets/ExitIcon1.png"]="rbxassetid://13350771140",["vape/assets/FriendsIcon.png"]="rbxassetid://13350771464",["vape/assets/HoverArrow.png"]="rbxassetid://13350772201",["vape/assets/HoverArrow2.png"]="rbxassetid://13350772588",["vape/assets/HoverArrow3.png"]="rbxassetid://13350773014",["vape/assets/HoverArrow4.png"]="rbxassetid://13350773643",["vape/assets/InfoNotification.png"]="rbxassetid://13350774006",["vape/assets/KeybindIcon.png"]="rbxassetid://13350774323",["vape/assets/LegitModeIcon.png"]="rbxassetid://13436400428",["vape/assets/MoreButton1.png"]="rbxassetid://13350775005",["vape/assets/MoreButton2.png"]="rbxassetid://13350775731",["vape/assets/MoreButton3.png"]="rbxassetid://13350776241",["vape/assets/NotificationBackground.png"]="rbxassetid://13350776706",["vape/assets/NotificationBar.png"]="rbxassetid://13350777235",["vape/assets/OnlineProfilesButton.png"]="rbxassetid://13350777717",["vape/assets/PencilIcon.png"]="rbxassetid://13350778187",["vape/assets/PinButton.png"]="rbxassetid://13350778654",["vape/assets/ProfilesIcon.png"]="rbxassetid://13350779149",["vape/assets/RadarIcon1.png"]="rbxassetid://13350779545",["vape/assets/RadarIcon2.png"]="rbxassetid://13350779992",["vape/assets/RainbowIcon1.png"]="rbxassetid://13350780571",["vape/assets/RainbowIcon2.png"]="rbxassetid://13350780993",["vape/assets/RightArrow.png"]="rbxassetid://13350781908",["vape/assets/SearchBarIcon.png"]="rbxassetid://13350782420",["vape/assets/SettingsWheel1.png"]="rbxassetid://13350782848",["vape/assets/SettingsWheel2.png"]="rbxassetid://13350783258",["vape/assets/SliderArrow1.png"]="rbxassetid://13350783794",["vape/assets/SliderArrowSeperator.png"]="rbxassetid://13350784477",["vape/assets/SliderButton1.png"]="rbxassetid://13350785680",["vape/assets/TargetIcon.png"]="rbxassetid://13350786128",["vape/assets/TargetIcon1.png"]="rbxassetid://13350786776",["vape/assets/TargetIcon2.png"]="rbxassetid://13350787228",["vape/assets/TargetIcon3.png"]="rbxassetid://13350787729",["vape/assets/TargetIcon4.png"]="rbxassetid://13350788379",["vape/assets/TargetInfoIcon1.png"]="rbxassetid://13350788860",["vape/assets/TargetInfoIcon2.png"]="rbxassetid://13350789239",["vape/assets/TextBoxBKG.png"]="rbxassetid://13350789732",["vape/assets/TextBoxBKG2.png"]="rbxassetid://13350790229",["vape/assets/TextGUIIcon1.png"]="rbxassetid://13350790634",["vape/assets/TextGUIIcon2.png"]="rbxassetid://13350791175",["vape/assets/TextGUIIcon3.png"]="rbxassetid://13350791758",["vape/assets/TextGUIIcon4.png"]="rbxassetid://13350792279",["vape/assets/ToggleArrow.png"]="rbxassetid://13350792786",["vape/assets/UpArrow.png"]="rbxassetid://13350793386",["vape/assets/UtilityIcon.png"]="rbxassetid://13350793918",["vape/assets/WarningNotification.png"]="rbxassetid://13350794868",["vape/assets/WindowBlur.png"]="rbxassetid://13350795660",["vape/assets/WorldIcon.png"]="rbxassetid://13350796199",["vape/assets/VapeIcon.png"]="rbxassetid://13350808582",["vape/assets/RenderIcon.png"]="rbxassetid://13350832775",["vape/assets/VapeLogo1.png"]="rbxassetid://13350860863",["vape/assets/VapeLogo3.png"]="rbxassetid://13350872035",["vape/assets/VapeLogo2.png"]="rbxassetid://13350876307",["vape/assets/VapeLogo4.png"]="rbxassetid://13350877564"}
local vapeCachedAssets = {}

if userInputService.TouchEnabled then 
	--mobile exploit fix
	getgenv().getsynasset = nil
	getgenv().getcustomasset = nil
	-- why is this needed
	getsynasset = nil
	getcustomasset = nil
end
local getcustomasset = getsynasset or getcustomasset or function(location) return vapeAssetTable[location] or "" end

local function downloadVapeAsset(path)
	if vapeCachedAssets[path] then
		return vapeCachedAssets[path]
	end
	if not isfile(path) then
		local suc, req = pcall(vapeGithubRequest, path:gsub("vape/assets", "assets"))
        if suc and req then
		    writefile(path, req)
        else
            return vapeAssetTable[path] or ""
        end
	end
	if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
	return vapeCachedAssets[path]
end

getgenv().vapeGithubRequest = vapeGithubRequest -- simplicity
getgenv().downloadVapeAsset = downloadVapeAsset
getgenv().debugLoad = function(src, tag)
	tag = tag or 'unknown'
	local success, err = pcall(function(src)
		local chunk, fail = loadstring(src)
		if chunk then
			print(`Compiled {tag}`)
			local success2, err2 = pcall(chunk)
			if success2 then
				return err2
			else
				return error(`Failure loading {tag}({err2})`)
			end
		else
			return error(`Failure loading {tag}({fail})`)
		end
	end, src)
	if success then
		print(`Loaded {tag}`)
		return err
	else
		GuiLibrary.SaveSettings = function() end
		pcall(function()
			local notification = shared.GuiLibrary.CreateNotification(`Failure loading {fail}`, err, 25, "assets/WarningNotification.png")
			notification.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
			notification.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
		end)
		return error(`Failure loading {fail} ({err}){debug.traceback('\nTraceback: ')}`)
	end
end

return debugLoad(vapeGithubRequest("MainScript.lua"), 'MainScript.lua (Backend.lua)')