-- Criado por Thalles Vitor --
-- Caixa de Dialogos --
local dialogs = g_ui.displayUI("dialogs")
local outfit = dialogs:getChildById("npc_outfit")
local name = dialogs:getChildById("npc_name")
local text = dialogs:getChildById("npc_dialogText")
local panel_btns = dialogs:getChildById("buttons_list")
local buttonsList = {}

distance = 0
function init()
  connect(g_game, { 
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  connect(LocalPlayer, {
    onPositionChange = onCreaturePositionChange
  })

  dialogs:hide()
 --dialogs:getChildById("npc_outfit"):setOutfit{type = 522}
end

function terminate()
  disconnect(g_game, { 
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  disconnect(LocalPlayer, {
    onPositionChange = onCreaturePositionChange
  })

  dialogs:hide()
end

function exibir()
  dialogs:show()
end

function naoexibir()
  dialogs:hide()
end

ProtocolGame.registerExtendedOpcode(122, function(protocol, opcode, buffer) -- receive npc dialog
	local param = buffer:split("@")
	local npc_name = tostring(param[1])
	local npc_outfit = tonumber(param[2])
	local npc_text = tostring(param[3])
	
	panel_btns:destroyChildren()
	dialogs:show()
	g_effects.fadeIn(dialogs, 1000)
	
	outfit:setOutfit({type = npc_outfit})
	name:setText(npc_name)
	text:setText(npc_text)
end)

ProtocolGame.registerExtendedOpcode(123, function(protocol, opcode, buffer) -- receive npc dialog
	local param = buffer:split("@")
	
	if param[1] == "fechar" then
		outfit:setOutfit({type = 1})
		name:setText("")
		text:setText("")

		dialogs:hide()
		g_effects.fadeOut(dialogs, 1000)
	end
end)

ProtocolGame.registerExtendedOpcode(124, function(protocol, opcode, buffer) -- receive npc dialog buttons
	local param = buffer:split("@")
	local buttons = tostring(param[1])
	
	local button = g_ui.createWidget("UIButton", panel_btns)
	button:setMarginTop(0)
	button:setMarginLeft(0)
	button:setSize("72 22")
	button:setImageSource("images/button2")
	button:setText(buttons)
	button:setColor("#d1ad55")
	button:setFont("damas")
	button.onClick = function() 
		if string.lower(buttons) == "fechar" then
			dialogs:hide()
		else
			--g_game.talk(buttons)
			g_game.talkChannel(11, 0, buttons)
		end
	end

	button.onHoverChange = function(self, value)
		if value then
			button:setColor("white")
			button:setImageSource("images/button2")
		else
			button:setColor("#d1ad55")
			button:setImageSource("images/button2")
		end
	end
end)

function onCreaturePositionChange(creature, newPos, oldPos)
	distance = distance + 1
	if distance >= 3 then
		dialogs:hide()
		distance = 0
		return true
	end
end