local BeatAreaSystem = Concord.system({
    pool = {"beat_area","position"}
    })


function BeatAreaSystem:update(dt)
    for _, e in ipairs(self.pool) do
      ---------------------------------setup
      if not e.beat_area.builded then  
        
        love.audio.setVolume(musicVOL) -- make only current track vol
        
        
        e.beat_area.setup()
        e.beat_area.song_map = Sequence
        
        for i = 1, 4 do
          local index = Scene:Spawn("arrow",{
              x = e.position.x+i*16,
              y = e.position.y,
              z=10,
              kind = i,
              rot = i-1,
              status = "main",
              area_index = e.index
            })
          e.beat_area.root_arrows_indexes[i] = index
        end
        
         
        e.beat_area.beatstarter:setBPM(e.beat_area.bpm)
        e.beat_area.beatstarter:play()
        e.beat_area.builded=true
        
      end
      
      
      if e.beat_area.song_beat >= e.beat_area.delay  then 
        if not e.beat_area.playing then
          e.beat_area.lvl_music:play() e.beat_area.playing = true 
        end
      else
        e.beat_area.playing = false
        love.audio.stop()
        
        
      end
      
 ------------------------------------------------------------------------------EVERY TICK    
      e.beat_area.beatstarter:update(dt)
      e.beat_area.timer = e.beat_area.timer+1*dt
      
      
      if e.beat_area.check_beat then  --post beat delay for input
        e.beat_area.check_beat = false
        e.beat_area.beat_lock = true
      end
      
      if e.beat_area.timer > 0.2 and not e.beat_area.beat_lock then 
        e.beat_area.check_beat = true
      end
      
      
      
      for key, val in pairs(e.beat_area.input)  do --key state update
        val.is_pressed, val.data, val.released_duration  = Input.pressed(key)
        val.is_down, val.val, val.duration = Input.down(key)
      end
      
      
      local obj = nil         -- clear input check
      for _, val in pairs(e.beat_area.input)  do
       -- obj = curscene[e.beat_area.root_arrows_indexes[val.index]]
       local index = e.beat_area.root_arrows_indexes[val.index]
       obj = Scene:get_object("arrow",index)
    --   obj = entity_list["arrow"].pool[e.beat_area.root_arrows_indexes[val.index]]
        
        if val.is_down  then
          
          if obj.arrow.collision then
            if obj.arrow.collision.len == 1 then
              
              if val.is_pressed then
                if not obj.arrow.lock.var then
                  e.beat_area.succes(1)
                  
                  obj.arrow.succes = true
                  
                  obj.arrow.lock("set",60/e.beat_area.bpm-0.1)
                  
                end
              end    
            end
          end
         ------------------------------------------
         
         if val.is_pressed then -- check wait for input 
            if e.beat_area.song_beat > (e.beat_area.delay-1) and e.beat_area.song_beat <= #e.beat_area.song_map+(e.beat_area.delay-1)  then
              if e.beat_area.song_map[e.beat_area.song_beat - (e.beat_area.delay-1)][val.index] or e.beat_area.song_map[e.beat_area.song_beat - (e.beat_area.delay-1)][val.index] then
                input_check = true
              else
                input_check = false
              end
            
            else
              input_check = false
            end
            
            if  not input_check  then -- check missclick 
              if not obj.arrow.lock.var and not obj.collision  then
                e.beat_area.mistake(1)
                obj.arrow.mistake = true
                obj.arrow.lock("set",0.2)
              end
            end
          end
          
        end
        
        
        if e.beat_area.check_beat then --check no-click in beat
          if e.beat_area.song_beat > (e.beat_area.delay-1) and e.beat_area.song_beat <= #e.beat_area.song_map+4 then
            input_check = e.beat_area.song_map[e.beat_area.song_beat-(e.beat_area.delay-1)][val.index]
          else
            input_check = false
          end
          
          if input_check  then
            if not obj.arrow.lock.var then
              e.beat_area.mistake(1)
              obj.arrow.mistake = true
              obj.arrow.lock("set",0.2)
            
            end
            
          end
          
        end
        -------------------------------------------------------
        
      end
      
-------------------------------------------------------------------------------EVERY BEAT
      if e.beat_area.beat  then 
      --  if  e.beat_area.song_beat-(e.beat_area.delay+2) <= #e.beat_area.song_map then --вынести в скрипт
        e.beat_area.beat = false       
        e.beat_area.beat_lock = false
        e.beat_area.timer = 0
        
        e.beat_area.song_beat = e.beat_area.song_beat+1   --sequence update
        
        e.beat_area.pattern = e.beat_area.song_map[e.beat_area.song_beat] or {false,false,false,false,}
        e.beat_area.next_pattern =  e.beat_area.song_map[e.beat_area.song_beat+1] or {false,false,false,false,}
        
        -------------------------------------
        for i = 1, 4 do   
          if e.beat_area.pattern[i] then
            Scene:Spawn("arrow",{
                x = e.position.x+i*16,
                y = e.position.y+e.position.h,
                z = 2,
                kind = i,
                rot = i-1,
                status = "minor",
                area_index = e.index,
                target_index = e.beat_area.root_arrows_indexes[i],
                key = e.beat_area.input[i],
                
                
                acceleration = e.beat_area.acc,
                max = e.beat_area.max 
              })
            end
          end 
          -------------------------------------
       -- else
         -- love.event.quit()
         -- end
          
        end
        --print(Scene:get_object("beat_area").beat_area.song_beat or "wait")
      --  print(#e.beat_area.song_map)
      end
  end
  



return BeatAreaSystem