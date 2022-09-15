local CheckboxSystem = Concord.system({
    pool = {"position","drawable","checkbox", "mouse_callback"}
  })

function CheckboxSystem:update(dt)
  for _, e in ipairs(self.pool) do
    
    
    if e.checkbox.var then
      e.checkbox.state = tostring(_G[e.checkbox.var])
    end
    
    
    if e.mouse_callback.clicked() then--clicked(e.position,e.checkbox) then
     -- e.checkbox:switch_state()
     -- e.button.state = false
      if e.checkbox.event then
        --doEvent(e.checkbox.event.name,e.checkbox.state)
        doEvent(e.checkbox.event)
      end
      
    end
    
    
  end
end

function CheckboxSystem.render(e)
  love.graphics.setColor( 1, 1, 1,e.position.opacity)
  
  love.graphics.draw(
        e.checkbox.image.root,e.checkbox.image[tostring(e.checkbox.state)],
        e.drawable.x,
        e.drawable.y)
  
end



function CheckboxSystem:draw()
  for _, e in ipairs(self.pool) do
    if e.position.visible then
      
      
      layers.band[e.drawable.layer].queue(e.position.z,CheckboxSystem.render,e)
     -- deep.queue(e.position.z,CheckboxSystem.render,e)
      
    end
  end
end

return CheckboxSystem
