local IconSystem = Concord.system({
    pool = {"icon"} ---zAxis
})


function IconSystem.render(e)
  local x = e.drawable.x +e.position.w/2 - e.icon.w/2
  --print(e.icon.w)
  local y = e.drawable.y +e.position.h/2 - e.icon.h/2
  love.graphics.draw(e.icon.image,x,y)
end


function IconSystem:draw()
    for _, e in ipairs(self.pool) do
      
      layers.band[e.drawable.layer].queue(e.position.z+1, IconSystem.render,e)
      
    end
end


return IconSystem