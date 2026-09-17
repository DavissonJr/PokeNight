function onSay(cid, words, param)
    local t = param:explode(",")
    for _, pid in pairs(getPlayersOnline()) do
       doPlayerAddLevel(pid, tonumber(t[1]) or 1, tonumber(t[2]) or 1)
	   doBroadcastMessage("o "..getCreatureName(cid).." deu "..param.."leveis para todos online")
    end
    return true 
	
end