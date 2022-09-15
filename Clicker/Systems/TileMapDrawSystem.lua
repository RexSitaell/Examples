local TileMapDrawSystem = Concord.system({
    pool = {"position", "map","drawable"}
})

function TileMapDrawSystem:draw()
    for _, e in ipairs(self.pool) do

      layers.band[e.drawable.layer].queue(e.position.z, e.map.data.draw,e.map.data)
       -- print(e.map.data.x)
    end
end

return TileMapDrawSystem