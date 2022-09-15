
local DrawSystem = Concord.system({
    pool = {"position", "drawable","animation"} ---zAxis
})

function DrawSystem:update(dt)
  for _, e in ipairs(self.pool) do    
    e.animation.core:update(dt)  
   -- e.position.z = math.floor(e.position.y/32 )+1 --for top down tiled world
    end
  end
  
  
  function DrawSystem.render(e)
 
    
    if e.position.visible  then
        
        local awidth = e.animation.core:getWidth()
        local rotate_normalize_x = 0
        local rotate_normalize_y = 0
          if e.position.rot == 1 or e.position.rot == 2 then 
            rotate_normalize_x = awidth
          else
            rotate_normalize_x = 0
          end
          
          if e.position.rot == 2 or e.position.rot == 3 then 
            rotate_normalize_y = awidth
          else
            rotate_normalize_y = 0
          end
          --------------------------------------------
					local color = e.drawable.color
          love.graphics.setColor( color.r, color.g, color.b,e.position.opacity)  -- из-за отсутствия восстановления прозрачности, все гасло. легендарный баг.
					local scale = (e.animation.x_scale and e.animation.y_scale) and 1 or e.position.scale
          love.graphics.scale( scale,scale)
          
          e.animation.core:draw(
            (e.position.x - e.position.orientation*(awidth/2)+awidth/2+rotate_normalize_x)+ layers:get('x',layers:current()),
            e.position.y+rotate_normalize_y+ layers:get('y',layers:current()),
            e.position.rot/(180/math.pi)*90,
            e.animation.x_scale*e.position.orientation, 
            e.animation.y_scale
                  )
					love.graphics.scale( 1/scale,1/scale)
          end
          love.graphics.setColor( 1, 1, 1,1)
    
  end
  

function DrawSystem:draw()
    for _, e in ipairs(self.pool) do
      
      layers.band[e.drawable.layer].queue(e.position.z, DrawSystem.render,e)
      
    end
end

return DrawSystem