local ListSystem = Concord.system({
    pool = {"position","drawable","list"}
  })

function ListSystem:update(dt)
  for _, e in ipairs(self.pool) do
    -- print (e.list.state)
    
    
    if not e.list.opened then
      if clicked(e.position,e.list) then
        e.list.opened = true
        
      end
      
    else
      --c.len*16+obj.position.h
      local pos = {x = e.position.x,y = e.position.y,w = 48,h = e.position.h+e.list.len*16} --лист придется переделывать
      
      
      if clicked(pos) then
        local index = math.floor((mouse.y - e.drawable.y - 16)/16)+1

        if  index > 0 and index <= calc_len(e.list.array.options) then
          
        e.list.state = e.list.array.options[index]--indexes[index]
        --print(e.list.state)
       
        _G[e.list.arr_name].selected = index-- e.list.state
        
        e.list.opened = false
        
        if e.list.event then
          
          local list = _G[e.list.arr_name]
          local event = list[e.list.event.name]
          event(unpack(e.list.event.args))
        end
        
        end
        
      else
        if mouse.clicked then
          e.list.opened = false
        end
        
      end
      
      
    end
    
    
    
    
  end
  
end

function ListSystem.render(e)
  --love.graphics.setColor( 1, 1, 1,e.position.opacity )
  local image = e.list.image
  
  
  
  ---------background
  if e.list.opened then
    
    for i = 1, e.list.len do
      love.graphics.draw(image.root, image.background,
        e.drawable.x,
        e.drawable.y+i*16)
      
      

      
      
    end
    
    local i = 0
    for key,val in pairs(e.list.array.options) do
      local scale = 0.4
      i = i+1
      love.graphics.scale( scale,scale) 
      love.graphics.setColor(textColor.r,textColor.g,textColor.b,textColor.a )
      local x = e.drawable.x*(1/scale) +32
      local y = e.drawable.y*(1/scale) +12 + (i*16)*(1/scale)
      
      love.graphics.print(val,x ,y ) 
      --e.list.indexes[i] = key
      
      love.graphics.scale(1/scale, 1/scale) 
      love.graphics.setColor( 1, 1, 1,e.drawable.opacity )
     
      end
    
     
  end
  

  ---------field
  love.graphics.draw(image.root, image.field,
    e.drawable.x,
    e.drawable.y)
  
  love.graphics.draw(image.root, image.btn,
    e.drawable.x+48,
    e.drawable.y)
  
  
  ----------text
  local scale = 0.4
  love.graphics.scale( scale,scale) 
  love.graphics.setColor(textColor.r,textColor.g,textColor.b,textColor.a )
  
  local x = e.drawable.x*(1/scale) +32
  local y = e.drawable.y*(1/scale) +12
   love.graphics.print(e.list.state,x ,y ) 
   
  love.graphics.scale(1/scale, 1/scale) 
  love.graphics.setColor( 1, 1, 1,e.drawable.opacity )
  
end



function ListSystem:draw()
 -- love.graphics.print(tostring(mouse.clicked))
  for _, e in ipairs(self.pool) do
    
    if e.position.visible then
      
       layers.band[e.drawable.layer].queue(e.position.z,ListSystem.render,e)
     -- deep.queue(e.position.x,ListSystem.render,e)
      
    end
    
    
  end
end

return ListSystem