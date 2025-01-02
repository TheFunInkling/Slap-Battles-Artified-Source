local module = {}

local Blacklist = {
	"HumanoidRootPart"
}

function module.Invisible(Character: Model?, Transparency: number)
	
	for _, v in pairs(Character:GetDescendants()) do
		
		if v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart") then
			
			if v.Name ~= "HumanoidRootPart" then
				
			if Transparency == 1 then
				
					if not Character:FindFirstChild("IsInvisible") then
				
				local tag = Instance.new("StringValue"); tag.Parent = Character; tag.Name = "IsInvisible"
				
				Character.Outline.Enabled = false
				
				Character.Head.Overhead.Enabled = false
				
				end
				
			elseif Transparency == 0 then
				
					if Character:FindFirstChild("IsInvisible") then Character:FindFirstChild("IsInvisible"):Destroy() end
				
				Character.Outline.Enabled = true
				
					Character.Head.Overhead.Enabled = true
				
			end
			
			v.Transparency = Transparency
			
			end
			
		elseif v:IsA("Decal") or v:IsA("Texture") then
			
			v.Transparency = Transparency
			
		elseif v:IsA("ParticleEmitter") or v:IsA("Sparkles") or v:IsA("Fire") then
			
			if Transparency == 1 then
				
				v.Enabled = false
				
			elseif Transparency == 0 then
				
				v.Enabled = true
				
			end
			
		end
		
	end
	
end

return module
