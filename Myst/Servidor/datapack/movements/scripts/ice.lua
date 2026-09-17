local playerteleportpos = {x = 1139, y = 1730, z = 6}

function onStepIn(cid, item, position, fromPosition)
     if not isPlayer(cid) then
          return true
     end

     if #getCreatureSummons(cid) <= 0 then
	   doTeleportThing(cid, fromPosition, false)
        return true
     end

     if (not isInArray(specialabilities["surf"], getPokemonName(getCreatureSummons(cid)[1]))) then 
   	     doPlayerSendCancel(cid, "This pokemon cannot surf.")
   	     doTeleportThing(cid, fromPosition, false)
   	     return true
     end
	
     doTeleportThing(cid, playerteleportpos)
     return true
end