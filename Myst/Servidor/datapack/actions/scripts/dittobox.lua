local a = {
[13247] = {balltype = "normal", ballid = 11826,
        pokemons = {"Ditto"}},

}     

local happy = 220 
         
function onUse(cid, item, frompos, item2, topos)
         local b = a[item.itemid]                                    
               if not b then return true end
         local pokemon = b.pokemons[math.random(#b.pokemons)]
         local btype = b.balltype
               if not pokeballs[btype] then return true end    
         
         doPlayerSendTextMessage(cid, 27, "Voce Abiu uma Ditto box !")
		 doBroadcastMessage("[Item Shop] o "..getCreatureName(cid).." acaba de abrir uma ditto box",19)
	     doPlayerSendTextMessage(cid, 27, "The prize pokemon was a "..pokemon..", congratulations!")
	     doSendMagicEffect(getThingPos(cid), 29)
               
         addPokeToPlayer(cid, pokemon, 0, nil, btype)     --alterado v1.9                                                 
         doRemoveItem(item.uid, 1)
	     
return true
end