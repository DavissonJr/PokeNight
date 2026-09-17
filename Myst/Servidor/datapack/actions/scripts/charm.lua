-- Criado por Thalles Vitor --
-- Sistema de Charm puxando direto da LIB --
-- Esse é o de shiny!! --

function onUse(cid, item, fromPosition, itemEx, toPosition)
   if item.itemid == 28176 then
      mainFunction(cid, "shiny", math.random(1, 100), 15, item)
   else
      mainFunction(cid, "shiny", math.random(1, 100), 30, item)
   end
   return true
end