-- Criado por Thalles Vitor --
-- Emojis --
local emojis = g_ui.displayUI("emojis", modules.game_interface.getBottomPanel())
local emojisPanel = emojis:getChildById("emojisPanel")
local emojisList =
{
   [1] = {name = ":)", img = "/images/game/emojis/happy"},
   [2] = {name = ":D", img = "/images/game/emojis/happy2"},
   [3] = {name = ":p", img = "/images/game/emojis/tongue"},
}

function init()
   connect(g_game, {
      onGameStart = naoexibir,
      onGameEnd = naoexibir,
   })

   emojis:setup()
   emojis:disableResize()

   emojis:hide()
end

function terminate()
   disconnect(g_game, {
      onGameStart = naoexibir,
      onGameEnd = naoexibir,
   })

   emojisPanel:destroyChildren()
   emojis:hide()
end

function exibir()
   emojisPanel:destroyChildren()
   if emojis:isVisible() then
      emojis:hide()
   else
      emojis:show()

      for i = 1, #emojisList do
         local emoji = g_ui.createWidget("UIButton", emojisPanel)
         emoji:setSize("30 31")
         emoji:setImageSource(emojisList[i].img)
         emoji:setTooltip(emojisList[i].name)
         emoji.onClick = function()
            modules.game_console.setEmojiText(emojisList[i].name)
         end
      end
   end
end

function naoexibir()
   emojis:hide()
end

function getEmojis()
   return emojis
end

function getEmojiList()
   return emojisList
end