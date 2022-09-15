local ArrowSystem = Concord.system({
    pool = {"arrow","animation","position","velocity"}
  })

function ArrowSystem:update(dt)
    for _, e in ipairs(self.pool) do
      
      if e.arrow.status == "main" then
        
        
        
        if e.arrow.collision then
          e.arrow.collision.timer = e.arrow.collision.timer+1
          if e.arrow.collision.timer > 1 then
            e.arrow.collision = nil
          end
        end
        
        --Animations--------------------------------------------------
        if e.arrow.succes then
          e.arrow.succes = false
          e.arrow.effect = true
          e.animation:switch("main")

        end
        
        if e.arrow.mistake then
          e.arrow.mistake = false
          e.arrow.effect = true
          e.animation:switch("mistake")
          
        end
        
        if  e.arrow.effect then
          e.animation:event("play")
          
          
          if e.animation:is_frame(3) then
            e.arrow.effect = false 
          end
          
        else
          e.animation:set(3, "main")
          e.animation:event("pause")

        end
        --------------------------------------------------------------
         
        e.arrow.lock("calc",dt)  -- lock timer
      end
      -----------------------------------------------------------------------------------
      
      if e.arrow.status == "minor" then
        
        if e.position.y > 0 then
          
          if e.position.y < 100  then
            if e.position.y > 80 then
              
              local obj = Scene:get_object("arrow",e.arrow.target_index)
              obj.arrow:collision_call(e.index,e.arrow.len)

            end
            if e.position.y < 90  then
              e.position.opacity = 0
            end 
          end
          
        else
          e:destroy() 
        end
        
        local modulevelocity =  e.velocity:accelerate(-e.velocity.y,dt)
        e.velocity.y = -modulevelocity
      end
      -----------------------------------------------------------------------------------
      
      if e.arrow.status == "shadow" then
      end
    -----------------------------------------------------------------------------------
      
    end
    
end

return ArrowSystem