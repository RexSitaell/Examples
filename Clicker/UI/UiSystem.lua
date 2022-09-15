local UISystem = Concord.system({
    pool = {"ui"}
  })

 
function UISystem:draw()
	for _, e in ipairs(self.pool) do
		--e.ui.render() 
	end
end


return UISystem