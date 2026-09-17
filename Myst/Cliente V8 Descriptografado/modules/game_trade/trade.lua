-- Criado por Thalles Vitor --
-- Chat List --
local trade = g_ui.displayUI("trade", modules.game_interface.getBottomPanel())
local message = trade:getChildById("message")
local textLength = trade:getChildById("textLength")
local startButton = trade:getChildById("startButton")
local stopButton = trade:getChildById("stopButton")
started = false
event = nil

function init()
   connect(g_game, {
      onGameStart = naoexibir,
      onGameEnd = naoexibir,
   })

   trade:hide()
end

function terminate()
   disconnect(g_game, {
      onGameStart = naoexibir,
      onGameEnd = naoexibir,
   })

   trade:hide()
end

function exibir()
   if trade:isVisible() then
      trade:hide()
   else
      trade:show()

      message.onTextChange = function(self, value)
         local valueMax = 255 - message:getText():len()
         textLength:setText(valueMax)

         if message:getText():len() > 0 then
            startButton:setOpacity(100)

            startButton.onClick = function()
               if started then
                  return
               end

               stopButton:setOpacity(100)
               started = true

               -- Start Event
               event = cycleEvent(function()
                  if not started then
                     return
                  end

                  if not g_game.isOnline() then
                     return
                  end

                  if not modules.game_console.getTabTrade() then
                     return
                  end

                  if not modules.game_console.getChannelLists()["Trade"] then
                     return
                  end

                  if message:getText() == "" then
                     return
                  end

                  g_game.talkChannel(7, 6, message:getText())
               end, 120000)

               stopButton.onClick = function()
                  startButton:setOpacity(100)

                  stopButton:setOpacity(0.60)
                  stopButton.onClick = function() end

                  started = false
                  removeEvent(event)
               end

               if not modules.game_console.getChannelLists()["Trade"] then
                  return
               end

               g_game.talkChannel(7, 6, message:getText())
               startButton:setOpacity(0.60)
            end

         else
            if started then
               return
            end

            startButton:setOpacity(0.60)
            startButton.onClick = function() end
         end
      end
   end
end

function naoexibir()
   trade:hide()
end
