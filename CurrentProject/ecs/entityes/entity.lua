local function entity(e,params)
  local params = params or {}
  e
  :give("position", params.x or 100, params.y or 100)
  :give("velocity", params.velocity_x  or 0, params.velocity_y  or 0)
  :give("drawable")
end;

return entity;