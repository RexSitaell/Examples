local LayerSystem = Concord.system({
    pool = {"drawable"}
  })


function LayerSystem:update(dt)
  for _, e in ipairs(self.pool) do
    e.drawable.x = e.position.x+ layers:get('x',layers:current())
    e.drawable.y = e.position.y+ layers:get('y',layers:current())
  end
end



return LayerSystem