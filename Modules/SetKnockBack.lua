local module = {}

function module.SetKnockBack(Dir: Vector3, KnockbackPower: number, UpPower: number, SpinPower: number, PartGettingKB)
	
	if SpinPower >= 10 or SpinPower <= -1 then
		
		SpinPower = 7
		
	end
	
	local UsedPower = KnockbackPower / 1.25
	UpPower = KnockbackPower/  1.5
	
	if UpPower <= -1 then

		UpPower = 30

	end
	
	UpPower = UpPower / 1.25
	
	local KBcheck = Instance.new("IntValue")
	KBcheck.Value = KnockbackPower; KBcheck.Parent = PartGettingKB; KBcheck.Name = "KnockedbackPOWER"
	game.Debris:AddItem(KBcheck, 0.3)
	
	local KnockbackForce = Instance.new("BodyVelocity")
	KnockbackForce.Velocity = Dir * UsedPower + Vector3.new(0, UpPower, 0)
	KnockbackForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	KnockbackForce.P = 2500
	KnockbackForce.Name = "KnockbackForce"
	KnockbackForce.Parent = PartGettingKB
	game.Debris:AddItem(KnockbackForce, 0.3)

	local SpinForce = Instance.new("BodyAngularVelocity")
	SpinForce.AngularVelocity = Vector3.new(-SpinPower, SpinPower, 0)
	SpinForce.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	SpinForce.P = 2500
	SpinForce.Name = "SpinForce"
	SpinForce.Parent = PartGettingKB
	game.Debris:AddItem(SpinForce, 0.3)
	
end

return module
