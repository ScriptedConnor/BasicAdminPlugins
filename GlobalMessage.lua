local Plugin = function(...)
	local Data = {...}
	
	-- Included Functions and Info --
	local remoteEvent = Data[1][1]
	local remoteFunction = Data[1][2]
	local returnPermissions = Data[1][3]
	local Commands = Data[1][4]
	local Prefix = Data[1][5]
	local actionPrefix = Data[1][6]
	local returnPlayers = Data[1][7]
	local cleanData = Data[1][8] -- cleanData(Sender,Receiver,Data)
	-- Practical example, for a gui specifically for a player, from another player
	-- cleanData(Sender,Receiver,"hi") -- You need receiver because it's being sent to everyone
	-- Or for a broadcast (something everyone sees, from one person, to nobody specific)
	-- cleanData(Sender,nil,"hi") -- Receiver is nil because it is a broadcast
	local MessagingService = game:GetService("MessagingService")
	local RunService = game:GetService("RunService")
	
	-- Plugin Configuration --
	local pluginName = 'globalmessage'
	local pluginPrefix = Prefix
	local pluginLevel = 3
	local pluginUsage = "<Text>" -- leave blank if the command has no arguments
	local pluginDescription = "Sends a message to all running servers."
	
	-- Example Plugin Function --
	local function pluginFunction(Args) -- keep the name of the function as "pluginFunction"
		local Player = Args[1]
		local combinedArgs = ""
		if RunService:IsStudio() then
			remoteEvent:FireClient(Player,"Hint","Error","This command cannot be used in Roblox Studio.")
		end
		if not Args[3] then return end
		for a,b in pairs(Args) do
			if a > 2 then
				combinedArgs = combinedArgs..b..' '
			end
		end
		if combinedArgs ~= "" then
			MessagingService:PublishAsync("GlobalMessage",tostring(combinedArgs))
		end
	end
	
	MessagingService:SubscribeAsync("GlobalMessage",function(Message)
		remoteEvent:FireAllClients("Message","Global Message",Message["Data"])
	end)
	
	-- Return Everything to the MainModule --
	local descToReturn
	if pluginUsage ~= "" then
		descToReturn = pluginPrefix..pluginName..' '..pluginUsage..'\n'..pluginDescription
	else
		descToReturn = pluginPrefix..pluginName..'\n'..pluginDescription
	end
	
	return pluginName,pluginFunction,pluginLevel,pluginPrefix,{pluginName,pluginUsage,pluginDescription}
end

return Plugin
