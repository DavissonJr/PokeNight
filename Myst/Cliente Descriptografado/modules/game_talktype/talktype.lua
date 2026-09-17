--local talktypeButton = nil

function init()
  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline,
  })

  --[[ talktypeButton = modules.client_topmenu.addLeftButton('talktypeButton', tr('Mensagens Laranjas'), '/images/topbuttons/talktype/orange', exibir)
  talktypeButton:setOn(false) ]]
end

function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline,
  })

 -- talktypeButton:setVisible(false)
 -- talktypeButton:setOn(false)
end

function exibir()
 -- if not talktypeButton:isOn() then
    --- acao de desativar as mensagens laranjas [taltype -- textmessage.lua]

  --  talktypeButton:setIcon('/images/topbuttons/talktype/orange_marked')
  --  talktypeButton:setOn(true)
 -- else
    -- acao de ativar as mensagens laranjas [taltype -- textmessage.lua]

 --   talktypeButton:setIcon('/images/topbuttons/talktype/orange')
  --  talktypeButton:setOn(false)
--  end
end

function getButtonState()
  --return talktypeButton:isOn()
end

function online()
end

function offline()
end