local DialogueSystem = Concord.system({
    pool = {"position", "drawable","dialogue"} ---zAxis
})

function startup()
  layers:set(2,"visible",true)
end

function shutdown(e)
  layers:set(2,"visible",false)
  e.dialogue.active  = false
  
end

function call_scenario(e,index)
  if index > #SCENARIO[level] then shutdown(e) index = #SCENARIO[level]
       end
       
       e.text:set(localization:getItem(SCENARIO[level][index][1]))
end

function step(e)
  e.dialogue.encounter = e.dialogue.encounter +1
  local index = e.dialogue.encounter
        call_scenario(e,index)
  
end



function DialogueSystem:update(dt)
  for _,e in ipairs(self.pool) do
    
    if e.dialogue.active then
      local inp = Input.pressed("c")
      if inp or e.dialogue.encounter == 0  then step(e) end
    end
    
    
    
    
  end
end


function DialogueSystem.render(e)
  love.graphics.draw(e.dialogue.image,e.position.x,e.position.y)
  
end


function DialogueSystem:draw()
    for _, e in ipairs(self.pool) do
      if e.dialogue.active then
        layers.band[e.drawable.layer].queue(e.position.z, DialogueSystem.render,e)
      end
      
      
    end
end

return DialogueSystem