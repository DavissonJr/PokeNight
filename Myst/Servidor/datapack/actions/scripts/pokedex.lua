local rate = 20

function onUse(cid, item, fromPos, item2, toPos)
 
	if not isCreature(item2.uid) then
		return true
	end

	if tonumber(getPlayerStorageValue(item2.uid, GUARDIAN_STORAGE_ISGUARDIAN)) >= 1 then
		doPlayerSendTextMessage(cid, 25, "Você não pode usar pokedex em um guardião.")
		return true
	end

	local poke = getCreatureName(item2.uid)
	if isMonster(item2.uid) then
       local this = newpokedex[getCreatureName(item2.uid)]
	   local myball = 0
	   if isSummon(item2.uid) then
	      myball = getPlayerSlotItem(getCreatureMaster(item2.uid), 8)
       end

	   if not getPlayerInfoAboutPokemon(cid, poke) then
		  doPlayerSendTextMessage(cid, 25, "O pokémon: " .. poke .. " nao está registrado no sistema, contate um administrador.")
		  return true
	   end

       if not getPlayerInfoAboutPokemon(cid, poke).dex then
	      local exp = 1000 + math.random(300, 320)
		  if string.find(poke, "Shiny") then
			exp = 1500 + math.random(300, 450)
		  elseif string.find(poke, "Black") then
			exp = 2000 + math.random(300, 700)
		  elseif string.find(poke, "Virus") then
			exp = 3000 + math.random(100, 300)
		  end

          doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Parabéns, você desbloqueou ".. getCreatureName(item2.uid).." em sua Pokédex.")
	      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você ganhou "..exp.." pontos de experiência.")
          doSendMagicEffect(getThingPos(cid), 210)
          doPlayerAddExperience(cid, exp)
          doAddPokemonInDexList(cid, poke)
       else
          doShowPokedexRegistration(cid, item2, myball)
		 --sendPokedexWindow(cid, poke, item2.uid)
       end
	return true
	end
return true
end