function getTopt(cid)
local check4 = db.getResult("SELECT `torneio` FROM `players` WHERE `id` = " .. getPlayerGUID(cid) .. " LIMIT 1")
return check4:getDataInt("torneio") <= 0 and 0 or check4:getDataInt("torneio") end

function addTopt(cid,amount)
db.executeQuery("UPDATE `players` SET `torneio` = "..getTopt(cid).."+"..amount.." WHERE `id` = "..getPlayerGUID(cid)) 
db.executeQuery("UPDATE `player_skills` SET `value` = '".. (getTopt(cid) + amount) .."' WHERE `player_id` = '"..getPlayerGUID(cid).."' AND `skillid` = '2'") 
end

function removeTopt(cid,amount)
db.executeQuery("UPDATE `players` SET `torneio` = "..getTopt(cid).."-"..amount.." WHERE `id` = "..getPlayerGUID(cid))
db.executeQuery("UPDATE `player_skills` SET `value` = "..getTopt(cid).."-"..amount.." WHERE `player_id` = "..getPlayerGUID(cid).." AND `skillid` = 2") 
end

function setTopt(cid,value)
db.executeQuery("UPDATE `players` SET `torneio` = "..value.." WHERE `id` = "..getPlayerGUID(cid)) 
db.executeQuery("UPDATE `player_skills` SET `value` = "..value.." WHERE `player_id` = "..getPlayerGUID(cid).." AND `skillid` = 2") 
end