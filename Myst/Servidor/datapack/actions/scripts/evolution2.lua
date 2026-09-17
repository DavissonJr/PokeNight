local special = specialevo                  --alterado v1.9 \/ peguem ele todo!

local types = {
[leaf] = {"Bulbasaur", "Ivysaur", "Oddish", "Gloom", "Bellsprout", "Weepinbell", "Exeggcute", "Chikorita", "Bayleef", "Hoppip", "Skiploom", "Sunkern"},
[water] = {"Squirtle", "Wartortle", "Horsea", "Goldeen", "Magikarp", "Psyduck", "Poliwag", "Poliwhirl", "Tentacool", "Krabby", "Staryu", "Omanyte", "Eevee", "Totodile", "Croconow", "Chinchou", "Marill", "Wooper", "Slowpoke", "Remoraid", "Seadra"},
[venom] = {"Zubat", "Ekans", "Nidoran male", "Nidoran female", "Nidorino", "Nidorina", "Gloom", "Venonat", "Tentacool", "Grimer", "Koffing", "Spinarak", "Golbat"},
[thunder] = {"Magnemite", "Pikachu", "Voltorb", "Eevee", "Chinchou", "Pichu", "Mareep", "Flaaffy", "Elekid"},
[rock] = {"Geodude", "Graveler", "Rhyhorn", "Kabuto", "Slugma", "Pupitar"},
[punch] = {"Machop", "Machoke", "Mankey", "Poliwhirl", "Tyrogue"},
[fire] = {"Charmander", "Charmeleon", "Vulpix", "Growlithe", "Ponyta", "Eevee", "Cyndaquil", "Quilava", "Slugma", "Houndour", "Magby"},
[coccon] = {"Caterpie", "Metapod", "Weedle", "Kakuna", "Paras", "Venonat", "Scyther", "Ledyba", "Spinarak", "Pineco"},
[crystal] = {"Dratini", "Dragonair", "Magikarp", "Omanyte", "Kabuto", "Seadra"},
[dark] = {"Gastly", "Haunter", "Eevee", "Houndour", "Pupitar"},
[earth] = {"Cubone", "Sandshrew", "Nidorino", "Nidorina", "Diglett", "Onix", "Rhyhorn", "Wooper", "Swinub", "Phanpy", "Larvitar"},
[enigma] = {"Abra", "Kadabra", "Psyduck", "Slowpoke", "Drowzee", "Eevee", "Natu", "Smoochum"},
[heart] = {"Rattata", "Pidgey", "Pidgeotto", "Spearow", "Clefairy", "Jigglypuff", "Meowth", "Doduo", "Porygon", "Chansey", "Sentret", "Hoothoot", "Cleffa", "Igglybuff", "Togepi", "Snubull", "Teddiursa"},
[ice] = {"Seel", "Shellder", "Smoochum", "Swinub"},
[king] = {"Slowpoke", "Poliwhirl"},
[metal] = {"Onix", "Scyther"},
[dragon] = {"Seadra"},
[upgrade] = {"Porygon", "Nosepass", "Probopass"},
[sun] = {"Sunkern", "Gloom"},
[sfire] = {"Shiny Charmander", "Shiny Charmeleon", "Shiny Vulpix", "Shiny Growlithe", "Shiny Ponyta", "Shiny Eevee"},
[swater] = {"Shiny Squirtle", "Shiny Wartortle", "Shiny Horsea", "Shiny Goldeen", "Shiny Magikarp", "Shiny Psyduck", "Shiny Poliwag", "Shiny Poliwhirl", "Shiny Tentacool", "Shiny Krabby", "Shiny Staryu", "Shiny Omanyte", "Shiny Eevee"},
[sleaf] = {"Shiny Bulbasaur", "Shiny Ivysaur", "Shiny Oddish", "Shiny Gloom", "Shiny Bellsprout", "Shiny Weepinbell", "Shiny Exeggcute"},
[sheart] = {"Shiny Rattata", "Shiny Pidgey", "Shiny Pidgeotto", "Shiny Spearow", "Shiny Clefairy", "Shiny Jigglypuff", "Shiny Meowth", "Shiny Doduo", "Shiny Porygon", "Shiny Chansey"},
[senigma] = {"Shiny Abra", "Shiny Kadabra", "Shiny Psyduck", "Shiny Slowpoke", "Shiny Drowzee", "Shiny Eevee"},
[srock] = {"Shiny Geodude", "Shiny Graveler", "Shiny Rhyhorn", "Shiny Kabuto"},
[svenom] = {"Shiny Zubat", "Shiny Ekans", "Shiny Nidoran male", "Shiny Nidoran female", "Shiny Nidorino", "Shiny Nidorina", "Shiny Gloom", "Shiny Venonat", "Shiny Tentacool", "Shiny Grimer", "Shiny Koffing"},
[sice] = {"Shiny Seel", "Shiny Shellder"},
[sthunder] = {"Shiny Magnemite", "Shiny Pikachu", "Shiny Voltorb", "Shiny Eevee"},
[scrystal] = {"Shiny Dratini", "Shiny Dragonair", "Shiny Magikarp", "Shiny Omanyte", "Shiny Kabuto"},
[scoccon] = {"Shiny Caterpie", "Shiny Metapod", "Shiny Weedle", "Shiny Kakuna", "Shiny Paras", "Shiny Venonat", "Shiny Scyther"},
[sdarkness] = {"Shiny Gastly", "Shiny Haunter", "Shiny Eevee"},
[spunch] = {"Shiny Machop", "Shiny Machoke", "Shiny Mankey", "Shiny Poliwhirl"},
[searth] = {"Shiny Cubone", "Shiny Sandshrew", "Shiny Nidorino", "Shiny Nidorina", "Shiny Diglett", "Shiny Onix", "Shiny Rhyhorn"},
[greena] = {"Tangela,", "Tangrowth"},
[magma] = {"Magmar"}

}

local specEvos = {   --alterado v1.9 \/
["Eevee"] = {
               [thunder] = "Jolteon",
               [water] = "Vaporeon",
               [fire] = "Flareon",
               [enigma] = "Espeon",
               [dark] = "Umbreon",
               [leaf] = "Leafeon",
               [ice] = "Glaceon",
            },

["Kirlia"] = {
   [punch] = "Galade",
   [enigma] = "Gardevoir",
},
}

function onUse(cid, item, frompos, item2, topos)

local pokeball = getPlayerSlotItem(cid, 8)

if not isMonster(item2.uid) or not isSummon(item2.uid) then
   return true
end
if #getCreatureSummons(cid) > 1 then
   return true                           --alterado v1.9
end

if getCreatureCondition(item2.uid, CONDITION_INVISIBLE) then return true end

local pevo = poevo[getCreatureName(item2.uid)]

if not spcevo[getCreatureName(item2.uid)] then
   if not pevo then
      doPlayerSendCancel(cid, "This pokemon can't evolve.")
      return true
   end
   if not isPlayer(getCreatureMaster(item2.uid)) or getCreatureMaster(item2.uid) ~= cid then
      doPlayerSendCancel(cid, "You can only use stones on pokemons you own.")
      return true
   end
   if pevo.stoneid ~= item.itemid and pevo.stoneid2 ~= item.itemid then 
      doPlayerSendCancel(cid, "This isn't the needed stone to evolve this pokemon.")
      return true
   end
end

local minlevel = 0

if getPokemonName(item2.uid) == "Eevee" then
   local eevee = specEvos["Eevee"][item.itemid]
   if not eevee then
      doPlayerSendCancel(cid, "This isn't the required stone to evolve this pokemon.")
      return true
   end   

   minlevel = pokes[eevee].level

   if getPlayerLevel(cid) < minlevel then
      doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
      return true
   end

   doRemoveItem(item.uid, 1)
   doEvolvePokemon(cid, item2, eevee, 0, 0)
   return true
end

if isInArray(specialevo, getPokemonName(item2.uid)) then
   if getPokemonName(item2.uid) == "Poliwhirl" then
      local evolution = 0
      local theevo = ""
      
      if item.itemid == water then
         if getPlayerItemCount(cid, king) >= 1 then
            evolution = king
			theevo = "Politoed"
         elseif getPlayerItemCount(cid, punch) >= 1 then
			evolution = punch
			theevo = "Poliwrath"
         else
            doPlayerSendCancel(cid, "You need a water stone and a punch stone (Poliwrath) or a King's Rock (Politoed) to evolve this pokemon.")
            return true
         end
         
         minlevel = pokes[theevo].level
         
         if getPlayerLevel(cid) < minlevel then
            doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			return true
         end
         if getPlayerItemCount(cid, punch) >= 1 and getPlayerItemCount(cid, king) >= 1 then
            doPlayerSendCancel(cid, "Please, use your Punch Stone to evolve this pokemon to a Poliwrath, or a King's Rock to a Politoed.")
			return true
         end
         doEvolvePokemon(cid, item2, theevo, evolution, water)

	  elseif item.itemid == punch then
         minlevel = pokes["Poliwrath"].level
         
         if getPlayerLevel(cid) < minlevel then
			doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			return true
         end
         if getPlayerItemCount(cid, water) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Punch Stone and one Water Stone to evolve this pokemon.")
			return true
         end

         local theevo = "Poliwrath"
         doEvolvePokemon(cid, item2, theevo, water, punch)
	
	  elseif item.itemid == king then
         minlevel = pokes["Politoed"].level

         if getPlayerLevel(cid) < minlevel then
			doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			return true
         end
         if getPlayerItemCount(cid, water) <= 0 then
			doPlayerSendCancel(cid, "You need at least one Punch Stone and one King's Rock to evolve this pokemon.")
			return true
         end
         local theevo = "Politoed"
         doEvolvePokemon(cid, item2, theevo, water, king)
      end

	elseif getPokemonName(item2.uid) == "Gloom" then
       local theevo = ""
	   local evolution = 0
       if item.itemid == leaf then
          if getPlayerItemCount(cid, venom) >= 1 then
	         theevo = "Vileplume"
			 evolution = venom
	      elseif getPlayerItemCount(cid, sun) >= 1 then
             theevo = "Bellossom"
			 evolution = sun
          else
             doPlayerSendCancel(cid, "You need at least one Leaf Stone, and a Sun Stone (Bellossom) or a Venom Stone (Vileplume) to evolve this pokemon.")
			 return true
	      end
	      
	      minlevel = pokes[theevo].level
	      
	      if getPlayerLevel(cid) < minlevel then
	         doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			 return true
	      end
          if getPlayerItemCount(cid, venom) >= 1 and getPlayerItemCount(cid, sun) >= 1 then
	         doPlayerSendCancel(cid, "Please, use your Venom Stone to evolve this pokemon to a Vileplume, or a Sun Stone to a Bellossom.")
			 return true
	      end
          
          doEvolvePokemon(cid, item2, theevo, evolution, leaf)

	   elseif item.itemid == venom then
          minlevel = pokes["Vileplume"].level

          if getPlayerLevel(cid) < minlevel then
             doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			 return true
          end
          if getPlayerItemCount(cid, leaf) <= 0 then
			 doPlayerSendCancel(cid, "You need at least one Leaf Stone and one Venom Stone to evolve this pokemon.")
			 return true
          end
          doEvolvePokemon(cid, item2, "Vileplume", venom, leaf)
          
       elseif item.itemid == sun then
          minlevel = pokes["Bellossom"].level

          if getPlayerLevel(cid) < minlevel then
             doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
             return true
          end
          if getPlayerItemCount(cid, leaf) <= 0 then
			 doPlayerSendCancel(cid, "You need at least one Leaf Stone and one Sun Stone to evolve this pokemon.")
			 return true
          end
          doEvolvePokemon(cid, item2, "Bellossom", sun, leaf)
       end
       
	elseif getPokemonName(item2.uid) == "Slowpoke" then
       if item.itemid == enigma then
          minlevel = pokes["Slowbro"].level

          if getPlayerLevel(cid) < minlevel then
			 doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			 return true
          end
          doEvolvePokemon(cid, item2, "Slowbro", enigma, 0)

		elseif item.itemid == king then
          minlevel = pokes["Slowking"].level

          if getPlayerLevel(cid) < minlevel then
             doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
			 return true
          end
          doEvolvePokemon(cid, item2, "Slowking", king, 0)
        end

	elseif getPokemonName(item2.uid) == "Tyrogue" then
        local evolution = ""

        evolution = choose("Hitmonlee", "Hitmonchan", "Hitmontop")
		minlevel = pokes[evolution].level

		if getPlayerLevel(cid) < minlevel then
		   doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
		   return true
		end
        doEvolvePokemon(cid, item2, evolution, punch, 0)
	end
return true
end

local count = 1
local stnid = 0
local stnid2 = 0
local evo = ""

if spcevo[getCreatureName(item2.uid)] then
   local tabela = spcevo[getCreatureName(item2.uid)]
   for i = 1, #tabela do
      if item.itemid == tabela[i].stoneid then
         if getPlayerItemCount(cid, item.itemid, -1) >= tabela[i].count then
            count = tabela[i].count
            stnid = tabela[i].stoneid
            stnid2 = tabela[i].stoneid2
            evo = tabela[i].evolution
         end
      end
   end
else
   count = poevo[getPokemonName(item2.uid)].count
   stnid = poevo[getPokemonName(item2.uid)].stoneid
   stnid2 = poevo[getPokemonName(item2.uid)].stoneid2
   evo = poevo[getPokemonName(item2.uid)].evolution
end

if stnid2 > 1 and (getPlayerItemCount(cid, stnid2) < count or getPlayerItemCount(cid, stnid) < count) then
   doPlayerSendCancel(cid, "You need at least one "..getItemNameById(stnid).." and one "..getItemNameById(stnid2).." to evolve this pokemon!")
   return true
end

if getPlayerItemCount(cid, stnid) < count then
   local str = ""
   if count >= 2 then
      str = "s"
   end
return doPlayerSendCancel(cid, "You need at least "..count.." "..getItemNameById(stnid)..""..str.." to evolve this pokemon!")
end

minlevel = pokes[evo].level

if getPlayerLevel(cid) < minlevel then
   doPlayerSendCancel(cid, "You don't have enough level to evolve this pokemon ("..minlevel..").")
   return true
end

if count >= 2 then
   stnid2 = stnid
end

doEvolvePokemon(cid, item2, evo, stnid, stnid2)

return TRUE
end