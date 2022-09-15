

local MoveSystem = Concord.system({
    pool = {"position", "velocity"}
})

function MoveSystem:update(dt)
    for _, e in ipairs(self.pool) do
        e.position.x = e.position.x + e.velocity.x * dt
        e.position.y = e.position.y + e.velocity.y * dt
        
       if e.velocity.x ~= 0 then
        if e.velocity.x > 0 and e.position.orientated then
         e.position.orientation = 1 else e.position.orientation = -1
       end
       end
    end
end

return MoveSystem