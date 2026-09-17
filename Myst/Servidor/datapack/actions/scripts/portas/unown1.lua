function onUse(cid, item, fromPosition, itemEx, toPosition)

local doors = {[5098]={id=5100}, [5099]={id=5100}, [5101]={id=5102}, [5107]={id=5109}, [5108]={id=5109}, [5110]={id=5111}, [6259]={id=6260}}


local config = {

pos = {x = 771, y = 2827, z = 8}


}

			for i, x in pairs(doors) do

			 if ((itemEx.itemid == i)) then

			   doTeleportThing(cid, config.pos)
			   
			   doPlayerRemoveItem(cid,2086,1)
			   
			   setPlayerStorageValue(cid, 54894, 1)
			   
			 end
				end
			 
return true

end