function onThink(interval, lastExecution, thinkInterval)

	local result = db.getResult("SELECT * FROM shop_history WHERE `processed` = 0;")
	
		if(result:getID() ~= -1) then
			while(true) do
				cid = getCreatureByName(tostring(result:getDataString("player")))
				product = tonumber(result:getDataInt("product"))
				itemr = db.getResult("SELECT * FROM shop_history WHERE `product` = "..product..";")
					if isPlayer(cid) then
						local id = tonumber(result:getDataInt("product"))
						local tid = tonumber(result:getDataInt("id"))
						local count = tonumber(result:getDataInt("session"))
						local tipe = tostring(result:getDataString("category"))
						local productn = tostring(result:getDataString("name"))
							if isInArray({"Items", "Outfits"}, tipe) then
								-- if getPlayerFreeCap(cid) >= 1 then
									if isContainer(getPlayerSlotItem(cid, 3).uid) then

										if getItemInfo(id).stackable == false then
											for i = 1, count do
												doPlayerAddItem(cid, id, i)
											end
										else
											doPlayerAddItem(cid, id, count)
										end

										doPlayerSendTextMessage(cid,19, "Voce recebeu >> "..productn.." << Da compra efetuada no site")
										db.executeQuery("UPDATE `shop_history` SET `processed`='1' WHERE id = " .. tid .. ";")
									else
										doPlayerSendTextMessage(cid,19, "Sorry, you don't have a container to receive >> "..productn.." <<")
									end
								-- else
									-- doPlayerSendTextMessage(cid,19, "Sorry, you don't have enough capacity to receive >> "..productn.." << (You need: "..getItemWeightById(id, count).." Capacity)")
								-- end
							elseif isInArray({"Pokemons"},tipe) then
									-- if getPlayerFreeCap(cid) >= (getItemWeightById(1987, 1) + getItemWeightById(id,count * bcap)) then
										local ballid = 11826
										local received = doCreateItemEx(ballid, 1)

										doItemSetAttribute(received, "poke", productn)
										doItemSetAttribute(received, "boost", 0)

										doItemSetAttribute(received, "ball", "poke")
										--doSetAttributesBallsByPokeName(cid, received, productn)

										doItemSetAttribute(received, "description", "Contains a "..productn..".")
										doItemSetAttribute(received, "fakedesc", "Contains a "..productn..".")

										doPlayerSendMailByName(getCreatureName(cid), received, 1)
										doPlayerSendTextMessage(cid,19, "You have received >> "..productn.." << from our shop system, check deposit please.")
										db.executeQuery("UPDATE `shop_history` SET `processed`='1' WHERE id = " .. tid .. ";")
									else
										doPlayerSendTextMessage(cid,19, "Sorry, you don't have enough capacity to receive >> "..productn.." << (You need: "..getItemWeightById(id, count).." Capacity)")
									end
							-- end
					end

				if itemr:getID() ~= -1 then
					itemr:free()
				end
				
				if not(result:next()) then
					break
				end
			end
			result:free()
		end
	return true
end
