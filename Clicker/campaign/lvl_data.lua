local lvl_data = {}

lvl_data[1] = {
  --BEAT_SYS = {

  --area_y = WH-190,
 -- area_h = 160,
 -- area_bpm = 120, --140
 -- delay_in_beats = 5
--},
  OBJECTS = {
    {object = "LVLMAP", params = {layer = 1,z=1}},
   -- {object = "player", params = {layer = 1,z=2,x=240,y = 32}},
    --{object = "dj", params = {layer = 1,z=2,x=234,y = 44}},
   -- {object = "dialogue_window", params = {layer = 2}},  ---levels/[level]/map
    --{object = "ui_button_1", params = {x=400,y = 20,z=2,layer = 1, event = {name = "Scene:SceneLoad",args = {3} }  }},
   -- {object = "ui_button_1", params = {x=200,y = 150,z=2,layer = 3, event = {name = "Scene:SceneLoad",args = {3} }  }},
		{object = "sprite", params = { z = 1, layer = 2 , animation = {name = "test"}} },
    }
}


return lvl_data