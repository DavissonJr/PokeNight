--[[
	Sistema de Flying(fly) para o Dragon Ball Z Extreme
	Feito por: Lukas Rafaeell *MyStIcaL*
	Email: Lukas.silvah@hotmail.com
	Quer algum script? Me mande um email com as informações dele!
	
	Obrigado pela atenção, favor não retirar os créditos ^-^
]]

function onSay(cid, words, param)

		local outfittrocar = { lookType = 610 , lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0} -- Outifit que vai vir ao usar !fly on
		local outfitvoltar = { lookType = 611 , lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0} -- Outifit escolhida para quando desativar o fly (para não ficar com a outifit do fly permanente

local lukasnmecha = {

		messagelukas = doPlayerSendTextMessage, -- Não mecher
		storagelukas = setPlayerStorageValue, -- Não mecher
		outfitlukas = doCreatureChangeOutfit, -- Não mecher
		messagetype = MESSAGE_STATUS_CONSOLE_BLUE, -- Não mecher
		messagetype2 = 25 -- Não mecher
}
	
local lukasr = {

		-- TODAS CONFIGURAÇÕES ABAIXO
		-- TODAS CONFIGURAÇÕES ABAIXO
		storageusadascript = 89342, -- Storage não aconselho mudar apenas se ja estiver em uso
		fala = "Script feito por Lukas Rafaeell *MyStiCaL*, para o Dragon Ball Z Extreme.", -- Message ao tentar usar apenas !fly
		fala2 = "!fly on - Para ativar o fly.", -- Message2 ao tentar usar apenas !fly
		fala3 = "!fly off - Para desativar o fly.", -- Message3 ao tentar usar apenas !fly
		fala4 = "Você ativou o fly!", -- Mensagem de quando usar !fly on
		fala5 = "Você desativou o fly!" -- Mensagem de quando usar !fly off
}		
		
	if(param == '') then
		lukasnmecha.messagelukas(cid, lukasnmecha.messagetype, lukasr.fala)
		lukasnmecha.messagelukas(cid, lukasnmecha.messagetype, lukasr.fala2)
		lukasnmecha.messagelukas(cid, lukasnmecha.messagetype, lukasr.fala3)
	return true
	end

	if(param == 'on') then
		lukasnmecha.outfitlukas(cid, outfittrocar)
		lukasnmecha.storagelukas(cid, lukasr.storageusadascript, 1)
		lukasnmecha.messagelukas(cid, lukasnmecha.messagetype2, lukasr.fala4)
	return true
	end
	
	if(param == 'off') then
		lukasnmecha.outfitlukas(cid, outfitvoltar)
		lukasnmecha.storagelukas(cid, lukasr.storageusadascript, -1)
		lukasnmecha.messagelukas(cid, lukasr.messagetype2, lukasr.fala5)
	return true
		end
end