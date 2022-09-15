local ButtonSystem = Concord.system({
    pool = {"position","drawable","button", "mouse_callback"} 
})

function ButtonSystem:update(dt)
  for _, e in ipairs(self.pool) do
    
    if not layers:get("blocked",e.drawable.layer) then

    if e.mouse_callback.clicked() then
      
      --local event = _G[e.button.event.name]
         -- event(unpack(e.button.event.args))
      --doEvent(e.button.event.name,unpack(e.button.event.args))
      doEvent(e.button.event)
    end
    
    
    end
    
    
  end
end



return ButtonSystem