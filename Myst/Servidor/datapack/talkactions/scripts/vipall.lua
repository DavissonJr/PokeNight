function onSay(cid, words, param)
    -- local t = param:explode(",")
	local config={
tempo ="1"
}
    for _, pid in pairs(getPlayersOnline()) do
       doPlayerAddPremiumDays(cid, config.tempo)
	 doBroadcastMessage("o "..getCreatureName(cid).." deu 2 Dias Dias Vip para todos online")
    end
	 return true 
   
	end
