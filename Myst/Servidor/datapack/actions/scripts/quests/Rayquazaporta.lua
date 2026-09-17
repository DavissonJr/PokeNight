function onUse(cid, item, fromPosition, itemEx, toPosition)

local doors = {[5098]={id=5100}, [5099]={id=5100}, [5101]={id=5102}, [5107]={id=5109}, [5108]={id=5109}, [5110]={id=5111}, [6259]={id=6260}}


local config = {

pos = {x = 2305, y = 1593, z = 5}


}

			for i, x in pairs(doors) do

			 if ((itemEx.itemid == i)) then

			   doTeleportThing(cid, config.pos)
			   
			   doPlayerRemoveItem(cid,2090,1)
			   
			   setPlayerStorageValue(cid, 54893, 1)
			   
			 end
				end
			 
return true

end