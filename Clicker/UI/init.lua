local PATH = (...):gsub('%.init$', '')
--local world = world


local UI = {}

UI.default = require(PATH..".ui_setup")

--UI.button = require(PATH..".button")

UI.canvas = require(PATH..".canvas")


addSys(PATH..".UiSystem")



--world:addSystem(PATH..".UiSystem")
return UI