local game=game
local i=Instance.new
local cf=CFrame.new
local unpack=table.unpack

local Accessories={}
local Attachments={
	[Enum.HumanoidRigType.R6]={
		RightShoulderAttachment={"Right Arm",cf(0,1,0,1,0,0,0,1,0,0,0,1)},
		RightGripAttachment={"Right Arm",cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		LeftFootAttachment={"Left Leg",cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		LeftShoulderAttachment={"Left Arm",cf(0,1,0,1,0,0,0,1,0,0,0,1)},
		LeftGripAttachment={"Left Arm",cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		RootAttachment={"HumanoidRootPart",cf(0,0,0,1,0,0,0,1,0,0,0,1)},
		RightFootAttachment={"Right Leg",cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		NeckAttachment={"Torso",cf(0,1,0,1,0,0,0,1,0,0,0,1)},
		BodyFrontAttachment={"Torso",cf(0,0,-0.5,1,0,0,0,1,0,0,0,1)},
		BodyBackAttachment={"Torso",cf(0,0,0.5,1,0,0,0,1,0,0,0,1)},
		LeftCollarAttachment={"Torso",cf(-1,1,0,1,0,0,0,1,0,0,0,1)},
		RightCollarAttachment={"Torso",cf(1,1,0,1,0,0,0,1,0,0,0,1)},
		WaistFrontAttachment={"Torso",cf(0,-1,-0.5,1,0,0,0,1,0,0,0,1)},
		WaistCenterAttachment={"Torso",cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		WaistBackAttachment={"Torso",cf(0,-1,0.5,1,0,0,0,1,0,0,0,1)},
		HairAttachment={"Head",cf(0,0.6,0,1,0,0,0,1,0,0,0,1)},
		HatAttachment={"Head",cf(0,0.6,0,1,0,0,0,1,0,0,0,1)},
		FaceFrontAttachment={"Head",cf(0,0,-0.6,1,0,0,0,1,0,0,0,1)},
		FaceCenterAttachment={"Head",cf(0,0,0,1,0,0,0,1,0,0,0,1)}
	},
	[Enum.HumanoidRigType.R15]={
		LeftAnkleRigAttachment={"LeftLowerLeg",cf(-0.000000179,0.101940,-0.000002,1,0,0,0,1,0,0,0,1)},
		LeftFootAttachment={"LeftFoot",cf(0.018277,-0.153460,-0.050264,1,0,0,0,1,0,0,0,1)},
		LeftElbowRigAttachment={"LeftLowerArm",cf(0.000479,0.258688,0,1,0,0,0,1,0,0,0,1)},
		LeftWristRigAttachment={"LeftLowerArm",cf(0.000479,-0.500929,0,1,0,0,0,1,0,0,0,1)},
		RightShoulderRigAttachment={"RightUpperArm",cf(-0.500001,0.394327,0.000000,1,0,0,0,1,0,0,0,1)},
		RightElbowRigAttachment={"RightUpperArm",cf(-0.000001,-0.334165,0.000000,1,0,0,0,1,0,0,0,1)},
		RightShoulderAttachment={"RightUpperArm",cf(-0.000001,0.584327,-0.000000,1,0,0,0,1,0,0,0,1)},
		NeckRigAttachment={"Head",cf(0,-0.500000,-0.000272,1,0,0,0,1,0,0,0,1)},
		FaceFrontAttachment={"Head",cf(0,0,-0.600272,1,0,0,0,1,0,0,0,1)},
		HatAttachment={"Head",cf(0,0.600000,-0.000272,1,0,0,0,1,0,0,0,1)},
		HairAttachment={"Head",cf(0,0.600000,-0.000272,1,0,0,0,1,0,0,0,1)},
		FaceCenterAttachment={"Head",cf(0,0,-0.000272,1,0,0,0,1,0,0,0,1)},
		RootRigAttachment={"LowerTorso",cf(-0.000000,-0.199972,0,1,0,0,0,1,0,0,0,1)},
		WaistRigAttachment={"LowerTorso",cf(-0.000000,0.200025,0,1,0,0,0,1,0,0,0,1)},
		LeftHipRigAttachment={"LowerTorso",cf(-0.500000,-0.199972,0,1,0,0,0,1,0,0,0,1)},
		RightHipRigAttachment={"LowerTorso",cf(0.499999,-0.199972,-0.000019,1,0,0,0,1,0,0,0,1)},
		WaistBackAttachment={"LowerTorso",cf(-0.000000,-0.199972,0.500000,1,0,0,0,1,0,0,0,1)},
		WaistCenterAttachment={"LowerTorso",cf(-0.000000,-0.199972,0,1,0,0,0,1,0,0,0,1)},
		WaistFrontAttachment={"LowerTorso",cf(-0.000000,-0.199972,-0.500000,1,0,0,0,1,0,0,0,1)},
		RightWristRigAttachment={"RightHand",cf(0.000000,0.125045,0.000000,1,0,0,0,1,0,0,0,1)},
		RightGripAttachment={"RightHand",cf(0,-0.149955,-0.000000,1,0,0,0,0,1,0,-1,0)},
		RootAttachment={"HumanoidRootPart",cf(0,0,0,1,0,0,0,1,0,0,0,1)},
		WaistRigAttachment={"UpperTorso",cf(-0.000000,-0.799986,0.000000,1,0,0,0,1,0,0,0,1)},
		NeckRigAttachment={"UpperTorso",cf(-0.000000,0.800017,0.000000,1,0,0,0,1,0,0,0,1)},
		LeftShoulderRigAttachment={"UpperTorso",cf(-1,0.563017,0.000000,1,0,0,0,1,0,0,0,1)},
		RightShoulderRigAttachment={"UpperTorso",cf(0.999999,0.563017,0.000000,1,0,0,0,1,0,0,0,1)},
		BodyFrontAttachment={"UpperTorso",cf(-0.000000,-0.199986,-0.499999,1,0,0,0,1,0,0,0,1)},
		BodyBackAttachment={"UpperTorso",cf(-0.000000,-0.199986,0.5,1,0,0,0,1,0,0,0,1)},
		LeftCollarAttachment={"UpperTorso",cf(-0.999999,0.800017,-0.000000,1,0,0,0,1,0,0,0,1)},
		NeckAttachment={"UpperTorso",cf(-0.000000,0.800017,0.000000,1,0,0,0,1,0,0,0,1)},
		RightCollarAttachment={"UpperTorso",cf(0.999999,0.800017,0.000000,1,0,0,0,1,0,0,0,1)},
		LeftShoulderRigAttachment={"LeftUpperArm",cf(0.500000,0.394327,0.000000,1,0,0,0,1,0,0,0,1)},
		LeftElbowRigAttachment={"LeftUpperArm",cf(0.000479,-0.334056,0.000000,1,0,0,0,1,0,0,0,1)},
		LeftShoulderAttachment={"LeftUpperArm",cf(0.000000,0.584327,-0.000000,1,0,0,0,1,0,0,0,1)},
		RightElbowRigAttachment={"RightLowerArm",cf(0.000000,0.258579,0,1,0,0,0,1,0,0,0,1)},
		RightWristRigAttachment={"RightLowerArm",cf(0.000000,-0.500929,0,1,0,0,0,1,0,0,0,1)},
		LeftWristRigAttachment={"LeftHand",cf(0.000479,0.125045,0.000000,1,0,0,0,1,0,0,0,1)},
		LeftGripAttachment={"LeftHand",cf(0,-0.149955,-0.000000,1,0,0,0,0,1,0,-1,0)},
		LeftHipRigAttachment={"LeftUpperLeg",cf(0.000000,0.420782,-0.000000,1,0,0,0,1,0,0,0,1)},
		LeftKneeRigAttachment={"LeftUpperLeg",cf(0.000000,-0.401102,-0.000000,1,0,0,0,1,0,0,0,1)},
		RightAnkleRigAttachment={"RightFoot",cf(0,0.101940,0.000076,1,0,0,0,1,0,0,0,1)},
		RightFootAttachment={"RightFoot",cf(-0.018277,-0.153460,-0.050264,1,0,0,0,1,0,0,0,1)},
		RightKneeRigAttachment={"RightLowerLeg",cf(0,0.379174,0.000026,1,0,0,0,1,0,0,0,1)},
		RightAnkleRigAttachment={"RightLowerLeg",cf(0,-0.547157,0.000076,1,0,0,0,1,0,0,0,1)},
		RightHipRigAttachment={"RightUpperLeg",cf(0,0.420782,-0.000067,1,0,0,0,1,0,0,0,1)},
		RightKneeRigAttachment={"RightUpperLeg",cf(0,-0.400946,-0.000022,1,0,0,0,1,0,0,0,1)},
		LeftKneeRigAttachment={"LeftLowerLeg",cf(0.000000,0.379018,-0.000000,1,0,0,0,1,0,0,0,1)},
		LeftAnkleRigAttachment={"LeftLowerLeg",cf(-0.000000,-0.547157,-0.000002,1,0,0,0,1,0,0,0,1)}
	}
}

local MainFunction = function(c,t)
	local Humanoid=c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid")
	if not Humanoid then return end
	for _,v in next,t do
		local a=v[1]
		local s=v[2] or 1

		local accessory=Accessories[a]
		if accessory then
			accessory=accessory:Clone()
		else
			accessory=game:GetObjects("rbxassetid://"..a)
			if typeof(accessory)=="table" then
				accessory=accessory[1]
			end
		end
		if typeof(accessory)=="Instance" then
			local weld=i("Weld")
			local handle=accessory:FindFirstChildWhichIsA("BasePart")
			local mesh=handle:FindFirstChildOfClass("SpecialMesh")
			local attachment=handle:FindFirstChildOfClass("Attachment")
			local attachmentt=Attachments[Humanoid.RigType][attachment.Name]

			accessory.Name="!"..accessory.Name
			handle.CanCollide=false
			handle.Massless=true
			mesh.Scale=mesh.Scale*s
			weld.C0=attachment.CFrame
			weld.C1=attachmentt[2]
			weld.Part0=handle
			weld.Part1=Character:FindFirstChild(attachmentt[1],true)
			weld.Parent=handle

			accessory.Parent=Character
		else
			warn("oh no! Cannot fetch model!")
		end
	end
end

return MainFunction
