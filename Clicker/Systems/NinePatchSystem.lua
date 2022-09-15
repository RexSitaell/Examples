local NinePatchSystem = Concord.system({
    pool = {"nine_patch","drawable","position"}
  })


function NinePatchSystem.calculateForm(e) --CANVAS!!!!!
 -- print(e.position.w)
   e.nine_patch.canvas = love.graphics.newCanvas(e.position.w, e.position.h)
   love.graphics.setCanvas(e.nine_patch.canvas)
  -- love.graphics.scale( 1, 1 )
   love.graphics.scale( 1/G_scale, 1/G_scale )
  -- love.graphics.setColor(1,1,1,1)
  -- love.graphics.rectangle('line',0,0,100,100)
   
   
   -----
    local image = e.nine_patch.image
  local sectors = e.nine_patch.sectors
  
  local w_side_len = (e.position.w-(sectors.corner.w*2))/sectors.side_pattern_len
  local h_side_len = (e.position.h-(sectors.corner.h*2))/sectors.side_pattern_len
  
  
  love.graphics.clear()
       -- love.graphics.setBlendMode("alpha")
       -- love.graphics.setColor(1, 0, 0, 0.5)
  
 
  
   love.graphics.draw(image.root, image.left_up,
        0,--e.position.x,
        0)--e.position.y)
      
   love.graphics.draw(image.root, image.right_up,
        e.position.w-sectors.corner.w,
        0)
      
   love.graphics.draw(image.root, image.right_down,
        e.position.w-sectors.corner.w,
        e.position.h-sectors.corner.h)
      
   love.graphics.draw(image.root, image.left_down,
        0,
        e.position.h-sectors.corner.h)
    
    
    if w_side_len > 0 then
      for i = 1,w_side_len do
        local x = sectors.corner.w+(i-1)*sectors.side_pattern_len
        love.graphics.draw(image.root, image.up_side,
                           x,
                           0)
        love.graphics.draw(image.root, image.down_side,
                           x,
                           e.position.h-sectors.corner.h)
          
      end
    end
    
    if h_side_len > 0 then
      for i = 1,h_side_len do
        local y = sectors.corner.h+(i-1)*sectors.side_pattern_len
        
        love.graphics.draw(image.root, image.left_side,
                           0,
                           y)
        love.graphics.draw(image.root, image.right_side,
                           e.position.w-sectors.corner.w,
                           y)
      end
    end
    
    
    if w_side_len > 0 and h_side_len > 0 then
      for i = 1, w_side_len do
        local x = sectors.corner.w+(i-1)*sectors.side_pattern_len
        
        for i = 1, h_side_len do
        local y = sectors.corner.h+(i-1)*sectors.side_pattern_len
          love.graphics.draw(image.root, image.center,
                           x,
                           y)
        end
        
        
      end
      
      
    end
   
   ----
   
   
   love.graphics.scale( G_scale, G_scale )
   love.graphics.setCanvas()
   
   e.nine_patch.form =  love.graphics.newImage(e.nine_patch.canvas:newImageData( )  )
   
   --e.nine_patch.canvas = canvas
  -- return e
end

function NinePatchSystem:update(dt)
  for _, e in ipairs(self.pool) do
  end
end


function  NinePatchSystem.render(e,layer)
  
  
  
  if e.nine_patch.deformated == true then
    NinePatchSystem.calculateForm(e)
    e.nine_patch.deformated = false
  end
  love.graphics.draw(e.nine_patch.form,
                     e.drawable.x,  --+ layers:get('x',layers:current()),
                     e.drawable.y)--+ layers:get('y',layers:current()))

end


function NinePatchSystem:draw()
  for _, e in ipairs(self.pool) do
    if e.position.visible then
         layers.band[e.drawable.layer].queue(e.position.z,NinePatchSystem.render,e)
        
      end                            
    end
  end

return NinePatchSystem