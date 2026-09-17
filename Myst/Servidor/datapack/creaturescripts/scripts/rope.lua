-- Criado por Thalles Vitor --
-- Rope --
function isHope(pos, itemId)
   for i = 0, 255 do
      local newPos = {x=pos.x, y=pos.y, z=pos.z, stackpos=i}
      if getTileThingByPos(newPos) ~= false and getTileThingByPos(newPos).uid > 0 and getTileThingByPos(newPos).itemid == itemId then
         return true
      end
   end
end

local spotId = {384, 418, 8278, 8592}

local holeId = {

	294, 369, 370, 383, 392,

	408, 409, 427, 428, 430,

	462, 469, 470, 482, 484,

	485, 489, 924, 3135, 3136,

	7933, 7938, 8170, 8286, 8285,

	8284, 8281, 8280, 8279, 8277,

	8276, 8323, 8380, 8567, 8585,

	8596, 8595, 8249, 8250, 8251,

	8252, 8253, 8254, 8255, 8256,

	8972, 9606, 9625

}

function onExtendedOpcode(cid, opcode, buffer)
   if not isPlayer(cid) then return true end
   if opcode == 8 then
      local param = buffer:explode("@")
      local toPosition = {x=tonumber(param[1]), y=tonumber(param[2]), z=tonumber(param[3])}
      if(toPosition.x == CONTAINER_POSITION) then

         doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
         return true
      end
   
      local itemGround = getThingFromPos(toPosition)
      if(isInArray(spotId, itemGround.itemid)) then
         doTeleportThing(cid, {x = toPosition.x, y = toPosition.y + 1, z = toPosition.z - 1}, false)
         if #getCreatureSummons(cid) >= 1 then
            doTeleportThing(getCreatureSummons(cid)[1], getThingPos(cid))
            doSendMagicEffect(getThingPos(cid), 21)
       end
      elseif isHope(toPosition, holeId) then
         local hole = getThingFromPos({x = toPosition.x, y = toPosition.y, z = toPosition.z + 1, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE})
         if(hole.itemid > 0) then
            doTeleportThing(hole.uid, {x = toPosition.x, y = toPosition.y + 1, z = toPosition.z}, false)
         else
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
         end
      else
         return false
      end
   end
   return true
end