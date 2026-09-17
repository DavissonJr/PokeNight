function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2145, 30) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns!! Agora você é um Jogador VIP.")
doPlayerAddPremiumDays(cid, 30)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Vocé Precisa De 30 Diamonds Pra SE TORNAR Vip.")
end
return TRUE
end

