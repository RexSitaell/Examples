local localization = {}
--если не аншлийский , то ставить шрифт юникода

function localization:getItem(item)  
  local result = localization.data[item]
  
  if not result then 
    result = "???"
  end
  
  return result
end

function localization:Init()
  local ru_loc = love.filesystem.read("localization/ru") --чтение дефолтных файлов 
  local eng_loc = love.filesystem.read("localization/eng")
  
  love.filesystem.createDirectory( "lang" )  --создание папки и её наполнение дефолтным переводом
  love.filesystem.write( "lang/ru",ru_loc, size )
  love.filesystem.write( "lang/eng",eng_loc, size )
  
  
  ----
  localization:optionsInit()  --загрузка содержимого папки
  local options = localization.options
  local selected = localization.selected
  localization:InitLanguage(options[selected]) --первоначальная загрузка языка

end




function localization:optionsInit()

localization.options = love.filesystem.getDirectoryItems( "lang" )
localization.selected = find_index_by_val(localization.options,options.array.lang)  -- ищет числовой индекс по значению в текстовом формате

if not localization.selected then
  localization.selected = find_index_by_val(localization.options,options.array.default_lang)  -- на случай если файл перевода оказался удален
  end

  
end

function localization:InitLanguage(lang) --базовая установка языка
  
  localization.data = {}
  
  local loc = love.filesystem.load("lang/"..lang)
  localization.data = loc() or {}
  
  options:set("lang",lang)
end

function localization:setLanguage(lang) --переустановка языка
  
  local options  = localization.options
  local selected = localization.selected
  local lang = options[selected]
  
  
  localization:InitLanguage(options[selected])
  
  Scene:SceneLoad(scene or 1) --обновление сцены для обновления текста под выбранный язык
  
end




return localization