function onSay(cid, words, param, channel)
   if isInParty(cid) then
      local party = getPartyMembers(cid)
      if party[#party] == cid then
         local sto = getPlayerStorageValue(cid, 4875498)
         for i = 1, #party do
             if sto <= -1 then
                setPlayerStorageValue(party[i], 4875498, 1)
                doPlayerSendTextMessage(party[i], 20, "The Exp in Party is disabled!")
             else
                setPlayerStorageValue(party[i], 4875498, -1)
                doPlayerSendTextMessage(party[i], 20, "The Exp in Party is enabled!")
             end
         end
      else
         doPlayerSendTextMessage(cid, 27, "Only the leader of the party can do that!")
      end
   else
      doPlayerSendTextMessage(cid, 27, "You need be a leader of a party to do that!")
   end
return true         
end