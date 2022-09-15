local SliderSystem = Concord.system({
    pool = {"position","drawable","slider"}
  })

function SliderSystem:update(dt)
  for _, e in ipairs(self.pool) do
    
    local x = e.drawable.x--+ layers:get('x',layers:current())
    local y = e.drawable.y--+ layers:get('y',layers:current())
    
    e.slider.val = _G[e.slider.var]
    
    if not mouse.down then
      e.slider.dragged = false
    end
    
    
    if  e.mouse_callback.dragged(e.position,e.slider) then
      e.slider.dragged = true
      
    end
    
    if e.slider.dragged then
      if e.slider.var then
        local result = (mouse.x-x)/((e.slider.len)*e.slider.cell_w)
        
        if result < 0  then result = 0 end
          
        if result > 1  then result = 1 end
    
        
        
        
        _G[e.slider.var] = result
      end
    end
    
    
  end
  
  
end

function SliderSystem.render(e)

   local x = e.drawable.x
   local y = e.drawable.y
  
   love.graphics.draw(e.slider.image.root,e.slider.image.left_corner,
     e.position.x+ layers:get('x',layers:current()),
      e.position.y+ layers:get('y',layers:current())
     
     )
  
  for i = 1, e.slider.len-2 do
    love.graphics.draw(
       e.slider.image.root,e.slider.image.body,
       x+(i)*e.slider.cell_w,
       y
       
       )
  end
  
  
  love.graphics.draw(e.slider.image.root,e.slider.image.right_corner,
     x +(e.slider.len-1)*e.slider.cell_w,
     y
     
   )
   
   
    love.graphics.draw(e.slider.image.root,e.slider.image.slider,
     x+(e.slider.len-1)*e.slider.cell_w*e.slider.val,
     y
     
   )
   
   
   --love.graphics.print(_G[e.slider.var])
   
  
end



function SliderSystem:draw()
  for _, e in ipairs(self.pool) do
    if e.position.visible then
      
      
      layers.band[e.drawable.layer].queue(e.position.z,SliderSystem.render,e)
     -- deep.queue(e.position.z,SliderSystem.render,e)
      
    end
    
    
  end
  
end


return SliderSystem