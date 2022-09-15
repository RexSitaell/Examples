
local t, storage, most_usable,less_usable,output_t = {},{},{},{},{}
local markup = {5, 35, 25}
local chars,words,unique_words,chars_min,list_size,MAXGEN = 0,0,0,6,20,100
local label = "storyes\\solomon"--"lovecraft"--"The Divine Comedy"--"bible"--"logic"--"War and Peace" --"bible"
local EMPTY = " "
local path = "assets\\"..label..".txt"
local output = "assets\\log.txt"

--print("reading " .. label .. "...")
-----------------------------------------------------------------ИТЕРАТОР
function allwords (line)
      local line = line  -- current line
      local pos = 1           -- current position in the line
      return function ()      -- iterator function
        while line do         -- repeat while there are lines
          local s, e = string.find(line, "%w+", pos)
          if s then           -- found a word?
            pos = e + 1       -- next position is after this word
            return string.sub(line, s, e)     -- return the word
          else
            line = nil  -- word not found; try next line
            pos = 1           -- restart from first position
          end
        end
        return nil            -- no more lines: end of traversal
      end
    end
------------------------------------------------------------------Переводит первую букву в верхний регистр
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function add_word()
	words = words+1
end

function create_list()
  local t = {}
  for i = 1, list_size do
    t[i] = {word = nil ,repeats = 1};
  end
  t.update_list = function(self,content,val,for_greater)
	for i = 1, list_size do
	  if for_greater then
	    if val >= self[i].repeats  and #content >= chars_min then
	      table.insert(self,i,{word = content, repeats = val})	
	      break;
	    end
	  else
	  
	    if val <= self[i].repeats  and #content >= #(self[i].word or "") then
	      table.insert(self,i,{word = content, repeats = val})	
	      break;
	    end
	  end
    end 
  end
  return t;
end;
--------------------------------------------------
function update_storage(word)
   _word = storage[word] ~= nil and storage[word]+1 or nil 
   upper_word = storage[firstToUpper(word)] ~= nil and storage[firstToUpper(word)]+1 or nil
   if _word and not upper_word then
	storage[word] = _word
   elseif  _word and upper_word  then
	storage[firstToUpper(word)] = upper_word
   else
	storage[word] = 1
   end
end

function organise_storage(content,val) 
  --print(content)
  local c , C = content, firstToUpper(content)
  if c and C then
	if c > C then
	  storage[c] = storage[c] + (storage[C] or 0)
	  storage[C] = nil
	else
	  storage[C] = storage[C] + (storage[c] or 0)
	  storage[c] = nil
	end
  end
end

function ordering_data()
  most_usable = create_list()
  less_usable = create_list()
  
  for content,val in pairs(storage) do
    organise_storage(content,val);
    unique_words = unique_words + 1;
    most_usable:update_list(content,val,true)
    less_usable:update_list(content,val,false)
    
  end
end
--------------------------------------------------
function normalise_render(markup,str)
  local addition = EMPTY:rep(markup-str:len())
  str = str..addition
  return str
end

function render_log()
  table.insert(output_t,"'"..label.."' contains "..#t.." lines, and "..chars.." chars in "..words.." words. \nincluding "..unique_words.." unique_words.\n\nThe "..list_size.." most popular/unique words ( longer then ".. chars_min-1 .." chars) is:\n")
  for i = 1,list_size do
  local separator = normalise_render(markup[1],i..". ")
  local left = normalise_render(markup[2],"'"..most_usable[i].word.."' with "..most_usable[i].repeats.." repeats. ") 
  local right = normalise_render(markup[3],"'"..less_usable[i].word.."' with "..less_usable[i].repeats.." repeats. ") 
  local res = separator..left..right
  
  table.insert(output_t, res)
  end;
  
  io.open(output,"w"):close()
  file = io.open(output, "a")
  file:write((table.concat(output_t, "\n")))
  file:close()
  os.execute("cls")
end

function open_log()
  
 -- print("Log Created.")
  os.execute(output)
end
--------------------------------------------------MARKOW
function prefix(w1,w2)
  return w1 .. " " .. w2
end

local statetab = {}

function insert(index,value)
  local list = statetab[index]
  if list == nil then 
    statetab[index] = {value}
  else
    list[#list+1] = value
  end
end

 N = 2; NOWORD = "\n"; TEXT = ""
 local w1 = NOWORD; w2 = NOWORD
 
 for line in io.lines(path) do
  -- print(line)
   for w in allwords(line) do
    insert(prefix(w1,w2), w or NOWORD)
	w1 = w2; w2 = w         
   end
 end
 insert(prefix(w1,w2), NOWORD)
 
 function generate_text()
   math.randomseed(os.time())
	 love.math.setRandomSeed(math.random(1,1000))
	 TEXT = ""
   w1 = NOWORD ; w2 = NOWORD
   for i = 1, MAXGEN do
   local list = statetab[prefix(w1,w2)]
	 local r = math.random(#list)
	 local nextword = list[r]
	 if nextword == NOWORD then return end
	 TEXT = TEXT..nextword.." "
	 w1 = w2; w2 = nextword
   end
 end
 
 function write_text()
  local b1,b2 = "--------------------------------------","--------------------------------------"
  file = io.open(output, "a")
  file:write("\n\n"..b1.."GENERATED TEXT:"..b2.."\n\n"..TEXT)
  file:close()
 end
 
 function save_text()
   --MARKOW_TEXT = TEXT;
	 return TEXT
 end;
--------------------------------------------------
function read_file()
  
  for line in io.lines(path) do
   t[#t+1] = line;
   chars = chars + #line
   for word in allwords(line) do
  	add_word()
    update_storage(word)
	--insert(prefix(w1,w2), word)--markow
	--w1 = w2, w2 = word         --markow
   end
  end
  t[#t+1] = "";
  --insert(prefix(w1,w2), NOWORD)--markow
end
--------------------------------------------------



function MARKOW()
   
  generate_text()
  --write_text()
	return save_text()
end

function reread_file(arg)
--love.math.setRandomSeed(math.random(1,1000))

--if not arg then
	--read_file()
	--ordering_data()
--end;
--render_log()
--local num = math.random(1,6000)
local text = MARKOW()
--print(num)
return text--tostring(num)--text;
--open_log()
end;

--reread_file()
---------------------------------------------------------------------