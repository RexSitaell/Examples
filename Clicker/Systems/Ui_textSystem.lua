local Ui_textSystem = Concord.system({
    pool = {"position","drawable","text"}
  })
	
	
	----------------------
	--textColorBlack = {
  --r=colorConvert(10),
  --g=colorConvert(10),
  --b=colorConvert(10),
  --a=1}
	--
	--
	--textColorRed = {
  --r=colorConvert(195),
  --g=colorConvert(20),
  --b=colorConvert(30),
  --a=1}
	
	textColor={
		Red = {
			r=colorConvert(195),
			g=colorConvert(20),
			b=colorConvert(30),
			a=1},
		Black = {
			r=colorConvert(10),
			g=colorConvert(10),
			b=colorConvert(10),
			a=1},
	
	}
	
	----------------------


function Ui_textSystem.render(e)
 -- print(e.position.z)
  local scale = 0.5
  
  love.graphics.scale( scale,scale) 
	
	local color =  textColor[e.text.color or "Black"];
	local d_color = textColor.Black
  love.graphics.setColor(color.r,color.g,color.b,color.a*e.position.opacity )
  love.graphics.setFont(e.text.font)
  
  
  
  
  local x = (e.drawable.x+e.text.w_tab  )*(1/scale)--+32
  local y = (e.drawable.y+e.text.h_tab  )*(1/scale) ---+16
  love.graphics.print(e.text.content:call(),x ,y ) 
  
  

  love.graphics.scale(1/scale, 1/scale) 
  love.graphics.setColor(d_color.r,d_color.g,d_color.b,d_color.a)
	local default_font = font
	love.graphics.setFont(default_font)
end

function Ui_textSystem:draw()
  for _, e in ipairs(self.pool) do
    if e.position.visible then
      
         layers.band[e.drawable.layer].queue(e.text.z,Ui_textSystem.render,e)
        
      end                            
    end
  end
  
  
return Ui_textSystem 