-- qPerfectionWeld.lua
-- Author: Quenty
-- Created: 10/6/2014
-- Version: 1.0.3

return function(neverbreakjoints,model,mainpart)
	local function CallOnChildren(Instance,FunctionToCall)
		FunctionToCall(Instance)
		for _,Child in next,Instance:GetChildren() do
			CallOnChildren(Child,FunctionToCall)
		end
	end
	local function GetBricks(StartInstance)
		local List={}
		CallOnChildren(StartInstance,function(Item)
			if Item:IsA("BasePart") then
				List[#List+1]=Item;
			end
		end)
		return List
	end
	local function Modify(Instance,Values)
		assert(type(Values) == "table","Values is not a table");
		for Index,Value in next,Values do
			if type(Index) == "number" then
				Value.Parent=Instance
			else
				Instance[Index]=Value
			end
		end
		return Instance
	end
	local function Make(ClassType,Properties)
		return Modify(Instance.new(ClassType),Properties)
	end
	local Surfaces={"TopSurface","BottomSurface","LeftSurface","RightSurface","FrontSurface","BackSurface"}
	local HingSurfaces={"Hinge","Motor","SteppingMotor"}
	local function HasWheelJoint(Part)
		for _,SurfaceName in pairs(Surfaces) do
			for _,HingSurfaceName in pairs(HingSurfaces) do
				if Part[SurfaceName].Name == HingSurfaceName then
					return true
				end
			end
		end
		return false
	end
	local function ShouldBreakJoints(Part)
		if neverbreakjoints then
			return false
		end
		if HasWheelJoint(Part) then
			return false
		end
		local Connected=Part:GetConnectedParts()
		if #Connected == 1 then
			return false
		end
		for _,Item in pairs(Connected) do
			if HasWheelJoint(Item) then
				return false
			elseif not Item:IsDescendantOf(model.Parent) then
				return false
			end
		end
		return true
	end
	local function WeldTogether(Part0,Part1,JointType,WeldParent)
		JointType=JointType or "Weld"
		local RelativeValue=Part1:FindFirstChild("qRelativeCFrameWeldValue")
		local NewWeld=Part1:FindFirstChild("qCFrameWeldThingy") or Instance.new(JointType)
		Modify(NewWeld,{
			Name="qCFrameWeldThingy";
			Part0=Part0;
			Part1=Part1;
			C0=CFrame.new();--Part0.CFrame:inverse();
			C1=RelativeValue and RelativeValue.Value or Part1.CFrame:toObjectSpace(Part0.CFrame); --Part1.CFrame:inverse() * Part0.CFrame;-- Part1.CFrame:inverse();
			Parent=Part1;
		})
		if not RelativeValue then
			RelativeValue=Make("CFrameValue",{
				Parent=Part1;
				Name ="qRelativeCFrameWeldValue";
				Archivable=true;
				Value =NewWeld.C1;
			})
		end
		return NewWeld
	end
	local function WeldParts(Parts,MainPart,JointType,DoNotUnanchor)
		for _,Part in pairs(Parts) do
			if ShouldBreakJoints(Part) then
				Part:BreakJoints()
			end
		end
		for _,Part in pairs(Parts) do
			if Part ~= MainPart then
				WeldTogether(MainPart,Part,JointType,MainPart)
			end
		end
		if not DoNotUnanchor then
			for _,Part in pairs(Parts) do
				Part.Anchored=false
			end
			MainPart.Anchored=false
		end
	end
	WeldParts(GetBricks(model),handle,"Weld",false)
end
