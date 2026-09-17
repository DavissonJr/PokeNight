function onSay(cid, words, param, channel)
        local Info = db.getResult("SELECT * FROM `players` WHERE `online` = '1' AND `group_id` > 1")
        local PlayerString = "Online Staff Members:\n"
        if Info:getID() ~= -1 then
                local count, i = Info:getRows(false), 0
                   repeat
                   PlayerString = PlayerString .. "Help"
                   elseif Info:getDataInt("group_id") == 3 then
                   PlayerString = PlayerString .. "Tutor"        
                   elseif Info:getDataInt("group_id") == 4 then
                   PlayerString = PlayerString .. "Game Master"                
                   elseif Info:getDataInt("group_id") == 5 then
                   PlayerString = PlayerString .. "Game Master"  
                   elseif Info:getDataInt("group_id") == 6 then
                   PlayerString = PlayerString .. "Administrator"
				   elseif Info:getDataInt("group_id") == 7 then
                   PlayerString = PlayerString .. "Youtuber"
                        end
						
                 PlayerString = PlayerString .. "\n"
                   until not(Info:next())
                                                  Info:free()
                   else
                   PlayerString = PlayerString .. "No staff online, try again later"
                   end
                   doPlayerPopupFYI(cid, PlayerString);
        return true
end