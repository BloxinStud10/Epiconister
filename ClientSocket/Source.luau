--There is already Socket by 4DBug but whatever

local ShareSocket = {}
local SocketPorts = {}
local BaseConnections = {}

local tableinsert = table.insert
local tableunpack = table.unpack
local cframenew = CFrame.new
local typeof = typeof
local type = type
local sharedportid = cframenew(36,1940,67)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Request = RobloxReplicatedStorage:WaitForChild("RequestDeviceCameraCFrame")
local Replicate = RobloxReplicatedStorage:WaitForChild("ReplicateDeviceCameraCFrame")

pcall(function()
	local CoreGui = game:GetService("CoreGui")
	local RobloxGui = CoreGui:WaitForChild("RobloxGui")
	local PlayerViewCore = RobloxGui:WaitForChild("CoreScripts/PlayerView")
	
	PlayerViewCore.Enabled = false
	
	local Frequency = 20
	local Interval = 1 / Frequency
	local Accumulator = 0
	
	tableinsert(BaseConnections,RunService.Heartbeat:Connect(function(Delta)
		Accumulator = Accumulator + Delta
		while Accumulator >= Interval do
			Accumulator = Accumulator - Interval
			for _,Player in next,Players:GetPlayers() do
				Request:FireServer(Player.UserId)
			end
		end
	end))
	
	Request.OnClientEvent:Connect(function()
		
	end)
end)

ShareSocket.new = function(portid, excludelocalplayer)
	portid = (typeof(portid)=="number" and cframenew(10,75,portid)) or (typeof(portid)=="CFrame" and portid) or sharedportid
	
	local SocketPort = SocketPorts[portid]
	if not SocketPort or not port.Disconnected then
		SocketPort = {}
		SocketPort.Disconnected = false
		SocketPort.Connection = nil
		SocketPort.Functions = {}
		
		SocketPort.Request = function(self, RequestId, ...)
			if not self.Disconnected then
				Replicate:FireServer(portid,{RequestId=RequestId,Arguments={...}})
			end
		end
		
		SocketPort.OnReceive = function(self, RequestId, Function)
			if not self.Disconnected and type(Function)=="function" then
				self.Functions[RequestId] = Function
			end
		end
		
		SocketPort.Destroy = function(self)
			if self.Disconnected then
				warn("Cannot destroy an destroyed port!")
			else
				local Connection = self.Connection
				Connection:Disconnect()
				self.Disconnected = true
			end
		end
		
		if excludelocalplayer then
			SocketPort.Connection = Replicate.OnClientEvent:Connect(function(plr,connectorportid,args)
				if plr~=LocalPlayer and portid==connectorportid then
					for _,v in next,SocketPort.Functions do
						if _==args.RequestId then
							v(tableunpack(args.Arguments))
						end
					end
				end
			end)
		else
			SocketPort.Connection = Replicate.OnClientEvent:Connect(function(plr,connectorportid,args)
				if portid==connectorportid then
					for _,v in next,SocketPort.Functions do
						if _==args.RequestId then
							v(tableunpack(args.Arguments))
						end
					end
				end
			end)
		end
		
		SocketPorts[portid] = SocketPort
	end
	
	return SocketPort
end

ShareSocket.DestroyAll = function(self)
	portid = (typeof(portid)=="number" and cframenew(1,1,portid)) or (typeof(portid)=="CFrame" and portid) or sharedportid
	
	local port = SocketPorts[portid]
	for _,v in next,BaseConnections do
		v:Disconnect()
	end
	if port then
		local Connection = port.Connection
		if Connection then
			Connection:Disconnect()
		end
		port.Disconnected = true
	end
end

return ShareSocket
