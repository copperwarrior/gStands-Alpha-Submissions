function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
    local owner = data:GetEntity()

	local emitter = ParticleEmitter( self.Position )
    local particle1 = emitter:Add( "effects/gstands_temperance/watersplash_001a", self.Position)
    local particle3 = emitter:Add( "effects/gstands_temperance/watersplash_002a", self.Position)
    local particle4 = emitter:Add( "effects/gstands_temperance/watersplash_002b", self.Position)
    if owner:IsValid() and !owner:GetNoDraw() then
    particle1:SetPos(self.Position + Vector(math.random(-20,20),math.random(-20,20),math.random(-50,40)))
    particle1:SetBounce(0.3)
    particle1:SetCollide(true)
    particle1:SetColor(255,255,0)
    particle1:SetDieTime(1)
    particle1:SetStartAlpha(255)
    particle1:SetEndAlpha(100)
    particle1:SetEndSize(5)
    particle1:SetStartSize(25)
    particle1:SetGravity(Vector(0,0,-500))
    particle1:SetRollDelta(math.random(-3,3))
    particle1:SetVelocity(Vector(math.random(-20,20),math.random(-20,20),math.random(30,50)) * 3)
    
    particle3:SetPos(self.Position + Vector(math.random(-20,20),math.random(-20,20),math.random(-50,40)))
    particle3:SetBounce(0.3)
    particle3:SetCollide(true)
    particle3:SetColor(255,255,0)
    particle3:SetDieTime(1)
    particle3:SetStartAlpha(255)
    particle3:SetEndAlpha(100)
    particle3:SetEndSize(5)
    particle3:SetStartSize(25)
    particle3:SetGravity(Vector(0,0,-500))
    particle3:SetRollDelta(math.random(-3,3))
    particle3:SetVelocity(Vector(math.random(-20,20),math.random(-20,20),math.random(30,50)) * 3)
    
    particle4:SetPos(self.Position + Vector(math.random(-20,20),math.random(-20,20),math.random(-50,40)))
    particle4:SetBounce(0.3)
    particle4:SetCollide(true)
    particle4:SetColor(255,255,0)
    particle4:SetDieTime(1)
    particle4:SetStartAlpha(255)
    particle4:SetEndAlpha(100)
    particle4:SetEndSize(5)
    particle4:SetStartSize(25)
    particle4:SetGravity(Vector(0,0,-500))
    particle4:SetRollDelta(math.random(-3,3))
    particle4:SetVelocity(Vector(math.random(-20,20),math.random(-20,20),math.random(30,50)) * 3)
     end
    
	emitter:Finish()
end


function EFFECT:Think( )
	return false	
end

function EFFECT:Render()

end



