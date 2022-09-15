local utf8 = require('.utf8')
utf8:init()
unicode_str = {}--string

for k,v in pairs(utf8) do
    --string[k] = v
    unicode_str[k] = v--переопределить доп метод строки
end

--math.randomseed(os.time())
Concord = require("concord")  --ECS

ConcordSystemsQueue = {}
SystemQueueConnect = function(world)
	for i = 1, #ConcordSystemsQueue do
		world:addSystem(ConcordSystemsQueue[i])
	end
end
addSys = function(path)
	table.insert(ConcordSystemsQueue,require(path))
end

UI = require 'UI'

Sound = require("noisedealer") --музыка и звуки
 
peachy = require("peachy") -- аниматор
Input = require 'Input'           --не инпут

--MARKOW_TEXT = "a"
reader = require 'reader'
--reread_file()

layers = require 'layers'           --система  слоев отрисовки
options = require 'options'
localization = require "localization"  --локализация

require 'utils'  --полезные мелочи
	require 'mouse'
require 'system'

require 'modules' --сторонние самоподключаемые модули
Event = require 'event' --???
-------------------------------------------------------- prestate 
---system
progress = false
first_session = true
----graphics
love.graphics.setDefaultFilter("nearest","nearest")
WW,WH = 1024*2,576*2--512,288 --как -то обрубает края спрайта
ww,wh = 1024,576
TileSize = 32
G_scale = 1.6 --love.graphics.getHeight( )/wh--1 --1 --,2

----physics
light_speed = 9999
beatgap = 0.05

----music
musicVOL = 0.1
---------------------------------------------------------- Rework this
scene = 1
level = 1
--LVL_DATA = require 'campaign\\lvl_data' --работй с бат файлом
SCENARIO = require 'campaign\\scenario' --работай с бат файлом

 
last_screenshot = nil

Scene=require 'scene_mng'
	
--QuadTree=require 'quad_tree'

-------------------------------------------- Concord stuff
--Concord.utils.loadNamespace("Components")
--local Systems = {}
--Concord.utils.loadNamespace("Systems", Systems)
--
--require 'objects'

Clicker = require 'clicker_source'

love.audio.setVolume( 0 )
function love.load()



main_canvas = love.graphics.newCanvas(WW, WH)  
  data_init()
  Input.bind_callbacks()

Sound.sound_pack.load("sounds/paper","paper")
Sound.sound_pack.load("sounds/pencil","pencil")
  ----------------------------------------------------------------- fonts not must been here
 -- font = love.graphics.newFont('font_storage/Gouranga-Pixel.ttf', 24)
 -- font = love.graphics.newFont('font_storage/712_serif.ttf', 28)
 fonts = {}
 fonts.info = {size = {normal = 48,big = 64}}
 fonts["big_font"] = love.graphics.newFont('font_storage/FloralCapitals.ttf', 64)
 fonts["font"] = love.graphics.newFont('font_storage/Prince Valiant.ttf', 48)
 fonts["default"] = love.graphics.newFont(18)
 
 font = love.graphics.newFont('font_storage/Prince Valiant.ttf', 48)

 love.graphics.setFont(fonts["default"])
  ----------------------------------------------------------------------

 world = Concord.world()
 Concord.utils.loadNamespace("Components")
	local Systems = {}
	Concord.utils.loadNamespace("Systems", Systems)

	require 'objects'
-----------------------------------------

for key,value in pairs(Systems) do  -- any Concord stuff
  world:addSystem(Systems[key])
end
SystemQueueConnect(world)

function world:onEntityRemoved (e) Scene:SceneSort(e) end

Scene:SceneLoad(scene)
-- QuadTree:setup()
--love.system.openURL("file://"..save_path)
end



function love.update(dt)
    --Sound.sound_pack.get("pencil").play()
    mouse:update(dt)
    world:emit("update", dt) 
    Event:update(dt)
		modules_storage.update(dt)
    -- QuadTree:update(dt)
end
Clicker.new_currency({name = "mana",income = 1,update_time = 0.2})


function love.draw()
    love.graphics.scale( G_scale, G_scale )
  ----  love.graphics.setCanvas(main_canvas)
  ----  love.graphics.clear()
		-- test1()
    --love.graphics.print(#layers.band)--#layers.band)
    world:emit("draw")   --draw calls
    layers:draw()
			--ruler.draw()
    ---- love.graphics.setCanvas()  
     love.graphics.scale(1/ G_scale, 1/G_scale )
    ---- love.graphics.draw(main_canvas)
    --
    -- QuadTree:debug()
		--love.graphics.print(Clicker.get_currency("mana").val.." "..Clicker.get_currency("mana").income)
    --love.graphics.print(love.timer.getFPS())--#layers.band)
end