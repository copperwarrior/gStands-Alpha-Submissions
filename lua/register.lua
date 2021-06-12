-- local tr = Entity(1):GetEyeTrace() 
-- local fx = EffectData() 
-- fx:SetNormal(tr.HitNormal) 
-- fx:SetOrigin(tr.HitPos) 
-- fx:SetScale(1) 
-- util.Effect("groundcrack", fx,  true, true)
hook.Add("OnPlayerHitGround", "Crater", function(ply, inWater, onFloater, speed)
	if not inWater and not onFloater then
		ply:SetVelocity(ply.Crater_OldVelocity * 2)
	end
end)

hook.Add("SetupMove", "Crater", function(ply, mv, cmd) 
	ply.LastCrater = ply.LastCrater or CurTime()
	if SERVER and CurTime() > ply.LastCrater and ply.Crater_OldVelocity and (ply.Crater_OldVelocity - mv:GetVelocity()):LengthSqr() > 300000 then
		local mins, maxs = ply:GetCollisionBounds()
		local trh = util.TraceHull({
			start = ply:WorldSpaceCenter(),
			endpos = ply:WorldSpaceCenter(),
			mins = maxs * -1.1, 
			maxs = maxs * 1.1,
			filter = {ply},
			mask = MASK_SOLID
		})
		if trh.Hit then
			local tr = util.TraceLine({
				start=ply:GetPos(),
				endpos=ply:GetPos() + ply.Crater_OldVelocity:GetNormalized() * 100,
				filter={ply},
				mask = MASK_SOLID
			})
			local speed = 300000 - ply.Crater_OldVelocity:LengthSqr()
			local fx = EffectData()
			fx:SetNormal(tr.HitNormal)
			fx:SetStart((mv:GetVelocity() + tr.HitNormal):GetNormalized() * ply.Crater_OldVelocity:Length())
			fx:SetOrigin(tr.HitPos)
			fx:SetScale(ply.Crater_OldVelocity:Length())
			fx:SetSurfaceProp(tr.SurfaceProps)
			util.ScreenShake(ply:GetPos(), speed * 3, speed * 3, 1, speed)
			local tr2 = util.TraceLine({
				start=tr.HitPos - tr.HitNormal * (100 * (1 - tr.FractionLeftSolid)),
				endpos=tr.HitPos,
				filter={ply},
				mask = MASK_SOLID
			})
			if not tr2.StartSolid then
				local trh2 = util.TraceHull({
					start = tr2.HitPos + ply.Crater_OldVelocity/10,
					endpos = tr2.HitPos + ply.Crater_OldVelocity/10,
					mins = mins, 
					maxs = maxs,
					filter = {ply},
					mask = MASK_SOLID
				})
				if not trh2.HitWorld then
					mv:SetOrigin(tr2.HitPos + ply.Crater_OldVelocity/10)
					mv:SetVelocity(ply.Crater_OldVelocity/2)
				end
			end
			util.Effect("groundcrack", fx,  true, true)
			ply.LastCrater = CurTime() + 1
		end
	end
	ply.Crater_OldVelocity = mv:GetVelocity()
end)