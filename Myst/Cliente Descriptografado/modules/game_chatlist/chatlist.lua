-- Criado por Thalles Vitor --
-- Chat List --
local chatlist = g_ui.displayUI("chatlist", modules.game_interface.getBottomPanel())
local panel = chatlist:getChildById("chatListPanel")

function init()
   connect(g_game, {
      onGameStart = naoexibir,
      onGameEnd = naoexibir2,
   })

   chatlist:hide()
end

function terminate()
   disconnect(g_game, {
      onGameStart = naoexibir,
      onGameEnd = naoexibir2,
   })

   chatlist:hide()
end

function exibir()
   if chatlist:isVisible() then
      chatlist:hide()
   else
      chatlist:show()
   end
end

function naoexibir()
   chatlist:hide()
end

function naoexibir2()
   panel:destroyChildren()
   chatlist:hide()
end

function getChatList()
   return chatlist
end

function getChatListPanel()
   return panel
end