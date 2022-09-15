local velocity = ecs.component("velocity", function(c, x, y)
    c.x = x or 0
    c.y = y or 0
    c.vectorX = 1
    c.vectorY = 1
end)

return velocity