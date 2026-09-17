function onSay(cid, words, param, channel)

local config = {
stamina = getPlayerStamina(cid), -- Nao precisa mexer
staminasafe = 40 * 60, -- Nao esta em uso no script, mas posso explicar depois
costPremiumDays = 1, -- Quanto custa pra comprar stamina com o comando !buystamina
quant = 1, -- Quantas potions você ganha de brinde com o comando !buystamina
premdays = 20, -- O minimo de premdays para comprar a stamina
}

local stamina_full = 42 * 60 -- config. 42 = horas
local player = Player(cid)
local staminapotion = 10502 -- ID do item stamina potion (igual ao da action do outro script)

if config.stamina >= stamina_full then
doPlayerSendCancelMessage("Your stamina is already full.")
doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
return TRUE
end

if(getPlayerPremiumDays(cid) < config.costPremiumDays) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Sorry, not enough premium time. Calling for stamina costs " .. config.costPremiumDays .. " days.")
doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
return TRUE
end

if(getPlayerPremiumDays(cid) < config.premdays) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You must have more than " .. config.premdays .. "premmium days in order to purchase more stamina.")
doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
return TRUE
end

if(getPlayerPremiumDays(cid) < 39000) then
doPlayerAddPremiumDays(cid, -config.costPremiumDays)
end

	player:setStamina(stamina_full)
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have fullfilled stamina and lost " .. config.costPremiumDays .. " days of premium time.")
	doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_RED)
	doPlayerAddItem(cid, staminapotion, config.quant)

if isPlayer(cid) then
doPlayerPopupFYI(cid, "Your stamina is "..config.stamina..".")
end
return true
end