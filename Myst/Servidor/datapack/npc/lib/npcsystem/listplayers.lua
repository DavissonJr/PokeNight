
if ( ListPlayers == nil ) then
	
  ListPlayers = {
	players = nil
  }
  
  function ListPlayers:new()
    local obj = {}
	obj.players = {}
	setmetatable(obj, self)
	self.__index = self
	return obj  
  end
  
  function ListPlayers:push(cid)
    if ( isPlayer(cid) ) then
	  self.players[#self.players + 1] = cid
	end
  end
  
  function ListPlayers:remove(i)
    return table.remove(self.players, i)
  end
  
  function ListPlayers:removePlayer(cid)
    for i, pid in ipairs(self.players) do
	  if ( cid == pid ) then
	    table.remove(self.players, i)
	  end
	end
  end
  
  function ListPlayers:getSize()
    return table.maxn(self.players)
  end
  
  function ListPlayers:getList(i)
	return self.players[i]
  end
  
  function ListPlayers:isInQueue(cid)
	return isInArray(self.players, cid)
  end
  
  function ListPlayers:isInQueueIp(cid)
    for i, v in ipairs(self.players) do
	  if ( getPlayerIp(cid) == getPlayerIp(v) ) then
	    return true
	  end
	end
	return false
  end
   
end