include('shared.lua')
--There's nothing interesting here. Go home.
function ENT:Draw()
    self.BaseClass.Draw(self) -- Overrides Draw 
    self:DrawModel() -- Draws Model Client Side
end