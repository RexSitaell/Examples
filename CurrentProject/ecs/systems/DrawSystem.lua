local DrawSystem = ecs.system({
    pool = {"position", "drawable"}
})

function DrawSystem:update()
  for _, e in ipairs(self.pool) do
    e.drawable:SetSprite()
  end
end


function DrawSystem:draw()
  for _, e in ipairs(self.pool) do
    love.graphics.draw(e.drawable.sprite, e.position.x, e.position.y)
      --love.graphics.circle("fill", e.position.x, e.position.y, 5)
  end
end

return DrawSystem