Concord.component("canvas",function(c,params,obj)
    --c.event = params.event or nil
    --if c.event and not c.event.args then  c.event.args = {} end

end)




function canvas(e,params)  --BASE CLASS V
  local params = params or {}
  e
--:give("ui",params,e) -- for ui_system
  :give("canvas",params,e)
	

  e.name = "canvas"
  
end

return canvas