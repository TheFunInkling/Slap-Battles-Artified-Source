local module = {}



local attachmentCFrames = {

	["Neck"] = {CFrame.new(0, 1, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1), CFrame.new(0, -0.5, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)},
	["Left Shoulder"] = {CFrame.new(-1.3, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1), CFrame.new(0.2, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1)},
	["Right Shoulder"] = {CFrame.new(1.3, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.2, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	["Left Hip"] = {CFrame.new(-0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1)},
	["Right Hip"] = {CFrame.new(0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1)},
	["RootJoint"] = {CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1), CFrame.new(0, -0, 0, 0, -0, 0, 0, 0, 0, 0, 0, 0)}

}

local ragdollInstanceNames = {

	["RagdollAttachment"] = true,
	["RagdollConstraint"] = true,
	["ColliderPart"] = true,

}

local function createColliderPart(part: BasePart)
	
	if not part then return end

	local rp = Instance.new("Part")
	rp.Name = "ColliderPart"
	rp.Size = part.Size/1.7
	rp.Massless = true			
	rp.CFrame = part.CFrame
	rp.Transparency = 1
	rp.Parent = part.Parent

	local cw = Instance.new("Weld")
	cw.Name = "ColliderWeld"
	cw.Part0 = rp
	cw.Part1 = part
	cw.Parent = rp
	
end

function module.UnRagdoll(char: Model)

	local Hum: Humanoid = char:FindFirstChild("Humanoid")
	local HRP: BasePart = char:FindFirstChild("HumanoidRootPart")
	local Torso: BasePart = char:FindFirstChild("Torso")


	if char.Ragdolled.Value == false then return end
	char.Ragdolled.Value = false


	for _, instance in pairs(char:GetDescendants()) do

		if ragdollInstanceNames[instance.Name] then

			instance:Destroy()

		end

		if instance:IsA("Motor6D") then

			instance.Enabled = true

		end
	end

	Hum.PlatformStand = false

	Hum.AutoRotate = true

	if HRP:FindFirstChild("AntiLagWeld") then

		HRP:FindFirstChild("AntiLagWeld"):Destroy()

	end


	for index, joint in pairs(char:GetDescendants()) do
		if joint:IsA("Motor6D") then

			joint.Enabled = true
			joint.Part0.Massless = false
			joint.Part1.Massless = false

		end
	end
	
	local NewOrigo = Instance.new("Part")
	NewOrigo.Position = HRP.Position + Vector3.new(0, 2, 0)    
	char:PivotTo(NewOrigo.CFrame)
	game.Debris:AddItem(NewOrigo, 0)

	for index,body in pairs(char:GetDescendants()) do
		if body:IsA("Part") or body:IsA("BasePart") then


			local sleeppart = body:FindFirstChild("RagdollPart")

			if sleeppart then

				sleeppart:Destroy()
			end


		end


	end

end

local function addDuration(parent, Duration)
	
	if not parent:FindFirstChild("RagdollDuration") then
		local newDura = Instance.new("NumberValue"); newDura.Value = Duration; newDura.Parent = parent; newDura.Name = "RagdollDuration"
		local theScript = game:GetService("ServerStorage").scripts.RagdollDurationHandler:Clone()
		theScript.Parent = newDura; theScript.Enabled = true
	end

end

function module.Ragdoll(char: Model, Duration: number)
	
	local Hum: Humanoid = char:FindFirstChild("Humanoid")
	local HRP: BasePart = char:FindFirstChild("HumanoidRootPart")
	--local Glove: Tool = char:FindFirstChildOfClass("Tool") or game.Players:GetPlayerFromCharacter(char).Backpack:FindFirstChildOfClass("Tool")
	local Torso: BasePart = char:FindFirstChild("Torso")
	local JP = Hum.JumpPower
	
	if char:FindFirstChild("RagdollDuration") then
		if char:FindFirstChild("RagdollDuration").Value > Duration then
		char:FindFirstChild("RagdollDuration").Value += Duration / 2.3
		else
			char:FindFirstChild("RagdollDuration").Value += Duration 
		end
	else
		-- nothing happens lmao
	end	
	
	if char:FindFirstChild("Ragdolled").Value == true then return end
	
	Hum.AutoRotate = false
	Hum.PlatformStand = true
	
	Hum.JumpPower = 0
	
	delay(1, function()
		
		Hum.JumpPower = JP
		
	end)
	
	char.Ragdolled.Value = true
	
	local AntiLagWeld = Instance.new("Weld")
	AntiLagWeld.Name = "AntiLagWeld"
	AntiLagWeld.Part0 = HRP
	AntiLagWeld.Part1 = Torso
	AntiLagWeld.Parent = HRP

	task.spawn(function()

		for _, motor in pairs(char:GetDescendants()) do

			if motor:IsA("Motor6D") then

				motor.Part0.Massless = true
				motor.Part1.Massless = true

			end

		end

		task.wait(0)
		
		

		

			for _, motor in pairs(char:GetDescendants()) do

				if motor:IsA("Motor6D") then

					motor.Part0.Massless = false
					motor.Part1.Massless = false

				end

			end

		

	end)

	for index,motor in pairs(char:GetDescendants()) do
		if motor:IsA("Motor6D") then
			
			local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			a0.CFrame = attachmentCFrames[motor.Name][1]
			a1.CFrame = attachmentCFrames[motor.Name][2]

			a0.Name = "RagdollAttachment"
			a1.Name = "RagdollAttachment"

			createColliderPart(motor.Part1)

			local b = Instance.new("BallSocketConstraint")
			b.Attachment0 = a0
			b.Attachment1 = a1
			b.LimitsEnabled = true
			b.TwistLimitsEnabled = true
			b.Name = "RagdollConstraint"

			a0.Parent = motor.Part0
			a1.Parent = motor.Part1
			b.Parent = motor.Parent

			motor.Enabled = false

		end
	end
	
	addDuration(char, Duration)

	--for index,body in pairs(char:GetDescendants()) do
		
		--if body:IsA("BasePart") then
			
			
			--if not body then return end
			
			--if body.Parent == Glove then return end 
			
			--if body.Parent.Name == "OrbitPart" then return end


			--local part = Instance.new("Part") --game:GetService("ServerStorage"):WaitForChild("Oval"):Clone()
			--part.Size = body.Size/1.7
			--part.Name = "RagdollPart"
			--part.CFrame = body.CFrame
			--part.Parent = body
			--part.Massless = true
			--part.Transparency = 1

			--local Weld = Instance.new("WeldConstraint")
			--Weld.Parent = part
			--Weld.Part0 = part
			--Weld.Part1 = body
			

		--end
        

	--end



end



return module
