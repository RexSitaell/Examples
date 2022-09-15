local DebugSystem = Concord.system({
    pool = {"debug","position"}
  })

--function DebugSystem:update(dt)
 -- end
 
 function DebugSystem:draw()
   for _, e in ipairs(self.pool) do
     local o = e.position

     love.graphics.rectangle("line",o.x,o.y,o.w,o.h)
     end
   end


return DebugSystem