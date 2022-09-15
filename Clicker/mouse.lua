--MOUSE--------------------------------------------------------------------------------------------------------------------------------------
  
  mouse = {
  x = 0,
  y = 0,
  down = false,
  downtime = 0,
  clicked = false,
  interrupted = false,
	locked = false
  }
  
  function mouse:update(dt)
    
   --print(tostring(mouse.clicked))
    
    mouse.x,mouse.y = love.mouse.getPosition( )
    mouse.x = mouse.x/G_scale
    mouse.y = mouse.y/G_scale
    
    --if not mouse.interrupted then
    mouse.down = love.mouse.isDown(1)
   -- end
    
    if mouse.down and not mouse.locked then
      mouse.downtime = mouse.downtime+1
    else
       mouse.downtime = 0
       mouse.interrupted = false
    end
      
      
      
    if mouse.downtime == 1 then 
      mouse.clicked = true
    else
      mouse.clicked = false
        
    end
      
  end
	
	function mouse:lock(val)	
		mouse.locked = val
		print("Lock set: "..tostring(mouse.locked))
	end;
	
	function mouse:is_pressed()
		return mouse.down and (not mouse.locked) and (not mouse.interrupted)
	end;
	
	function mouse:is_click()
		--local result = mouse:is_pressed()
		--interrupt_mouse()
		return mouse.clicked
	end;
	


function touched(position)
  
  if (position.x+layers:get("x",layers:current()) <= mouse.x and position.y+layers:get("y",layers:current()) <= mouse.y) and 
     (position.x+position.w + layers:get("x",layers:current())>= mouse.x and position.y+position.h+layers:get("y",layers:current()) >= mouse.y) then 
    return true 
  else return false 
    end
end

function interrupt_mouse()
  mouse.downtime = 999
  mouse.interrupted = true
end


function dragged(position)
  if touched(position) then
    if mouse.down and (not mouse.interrupted) or mouse.locked then
      return true
    else
      return false
    end
  else
    return false
    
  end
  
  
end


function clicked(position)   
  if touched(position,size) then 
    if mouse.down and mouse.downtime == 1 then
      return true
    else 
      return false
      end
  else 
    return false
    end
  
end


----------------------------------------------------------------