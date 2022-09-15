local ControlSystem = Concord.system({
    pool = {"velocity", "controlled","position"}
})

function ControlSystem:update(dt)
  for _, e in ipairs(self.pool) do
    
    local mod = 0
    
   if input:down('right') then 
     if e.velocity.x < -10 then mod = e.velocity.deceleration*dt else mod = 0 end
     
     
     e.velocity.x = e.velocity:accelerate(e.velocity.x+mod,dt)
   elseif
   input:down('left') then 
     if e.velocity.x > 10 then mod = -e.velocity.deceleration*dt else mod = 0 end
    
     
     e.velocity.x = -e.velocity:accelerate(-e.velocity.x-mod,dt) 
 else
   if e.velocity.x > 10 then e.velocity.x = e.velocity.x - e.velocity.deceleration*dt
   elseif
    e.velocity.x < -10 then e.velocity.x = e.velocity.x + e.velocity.deceleration*dt
   else
     e.velocity.x = 0
   end
     
   end
   
   
    if input:down('down') then 
     if e.velocity.y < -10 then mod = e.velocity.deceleration*dt else mod = 0 end
     
     
     e.velocity.y = e.velocity:accelerate(e.velocity.y+mod,dt)
   elseif
   input:down('up') then 
     if e.velocity.y > 10 then mod = -e.velocity.deceleration*dt else mod = 0 end
    
     
     e.velocity.y = -e.velocity:accelerate(-e.velocity.y-mod,dt) 
 else
   if e.velocity.y > 10 then e.velocity.y = e.velocity.y - e.velocity.deceleration*dt
   elseif
    e.velocity.y < -10 then e.velocity.y = e.velocity.y + e.velocity.deceleration*dt
   else
     e.velocity.y = 0
   end
     
   end
   
  --[[ if input:down('up') then e.velocity.y = -50 
   elseif
   input:down('down') then e.velocity.y = 50 
   else
     e.velocity.y = 0
   end]]
   
   
   
   
   end
  end
  
  return ControlSystem