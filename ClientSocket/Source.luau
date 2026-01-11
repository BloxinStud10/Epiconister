--There is already Socket by 4DBug but whatever

local game = game
local setmetatable = setmetatable
local tableinsert = table.insert
local tableremove = table.remove
local tablefind = table.find
local tableclear = table.clear
local tableunpack = table.unpack
local cframenew = CFrame.new
local typeof = typeof
local type = type
local next = next
local pcall = pcall
local sharedportid = cframenew(0,10383,0)
local emptyfunction = function() end

local GetService = game.GetService
local WaitForChild = game.WaitForChild
local GetPropertyChangedSignal = game.GetPropertyChangedSignal

local ClientSocket = {}
local SocketPorts = {}
local BaseConnections = {}

local Players = GetService(game,"Players")
local RunService = GetService(game,"RunService")
local RobloxReplicatedStorage = GetService(game,"RobloxReplicatedStorage")

local Request = WaitForChild(RobloxReplicatedStorage,"RequestDeviceCameraCFrame")
local Replicate = WaitForChild(RobloxReplicatedStorage,"ReplicateDeviceCameraCFrame")

local LocalPlayer = Players.LocalPlayer
local Heartbeat = RunService.Heartbeat
local GetPlayers = Players.GetPlayers
local FireServer = Request.FireServer
local Connect = Heartbeat.Connect
local Disconnect = Connect(GetPropertyChangedSignal(game,"CreatorId"),emptyfunction).Disconnect

pcall(function()
	local CoreGui = GetService(game,"CoreGui")
	local RobloxGui = WaitForChild(CoreGui,"RobloxGui")
	local PlayerViewCore = WaitForChild(RobloxGui,"CoreScripts/PlayerView")
	
	PlayerViewCore.Enabled = false
	
	local Frequency = 20
	local Interval = 1 / Frequency
	local Accumulator = 0
	
	local PlayerTable = GetPlayers(Players)
	tableinsert(BaseConnections,Connect(Players.PlayerAdded,function(Player)
		tableinsert(PlayerTable,Player)
	end))
	tableinsert(BaseConnections,Connect(Players.PlayerRemoving,function(Player)
		tableremove(PlayerTable,tablefind(PlayerTable,Player))
	end))
	
	tableinsert(BaseConnections,Connect(Heartbeat,function(Delta)
		Accumulator = Accumulator + Delta
		while Accumulator >= Interval do
			Accumulator = Accumulator - Interval
			for _,Player in next,PlayerTable do
				FireServer(Request,Player.UserId)
			end
		end
	end))
	
	tableinsert(BaseConnections,Connect(Request.OnClientEvent,emptyfunction))
end)

ClientSocket.new = function(PortId, ExcludeLocalClient)
	PortId = (typeof(PortId)=="number" and cframenew(0,PortId,0)) or (typeof(PortId)=="CFrame" and PortId) or sharedportid
	
	local SocketPort = SocketPorts[PortId]
	if not SocketPort or not port.Disconnected then
		SocketPort = setmetatable({
			Disconnected = false,
			Connection = nil,
			Functions = {}
		},{})
		SocketPort.__index = SocketPort
		
		SocketPort.Request = function(self, RequestId, ...)
			if not self.Disconnected then
				FireServer(Replicate,PortId,{RequestId,{...}})
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
				Disconnect(Connection)
				tableclear(self.Functions)
				self.Disconnected = true
			end
		end
		
		if ExcludeLocalClient then
			SocketPort.Connection = Connect(Replicate.OnClientEvent,function(plr,connectorportid,args)
				if plr~=LocalPlayer and PortId==connectorportid then
					for i,v in next,SocketPort.Functions do
						if not i==args[1] then
							continue
						end
						v(tableunpack(args[2]))
					end
				end
			end)
		else
			SocketPort.Connection = Connect(Replicate.OnClientEvent,function(plr,connectorportid,args)
				if PortId==connectorportid then
					for i,v in next,SocketPort.Functions do
						if not i==args[1] then
							continue
						end
						v(tableunpack(args[2]))
					end
				end
			end)
		end
		
		SocketPorts[PortId] = SocketPort
	end
	
	return SocketPort
end

ClientSocket.DestroyAll = function(self)
	for _,v in next,BaseConnections do
		Disconnect(v)
	end
	for i,v in next,SocketPorts do
		if not v.Disconnected then
			v:Destroy()
		end
	end
end

return ClientSocket
