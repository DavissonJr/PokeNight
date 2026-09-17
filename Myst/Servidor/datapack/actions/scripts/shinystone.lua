function onUse(cid, item, topos, item2, frompos)
local myball = getPlayerSlotItem(cid, 8)
local boost = getItemAttribute(myball.uid, "boost") or 0
local boosts = 5
if boost == 70 then
doPlayerSendCancel(cid, "Seu Pokemon Está no Maximo Boost.")
return true
end
if not isSummon(item2.uid) then
doPlayerSendCancel(cid, "Use em um Pokemon.")
return true
end
   boosts = boosts
        local pokemon = getItemAttribute(myball.uid, "poke")
        local off = pokes[pokemon].offense * boost_rate * boosts
local def = pokes[pokemon].defense * boost_rate * boosts
local agi = pokes[pokemon].agility * boosts
local spatk = pokes[pokemon].specialattack * boost_rate * boosts
local vit = pokes[pokemon].vitality * boost_rate * boosts
newBoost = boost + boosts
if newBoost > 70 then
newBoost = 70
end
        doSetItemAttribute(myball.uid, "boost", newBoost)
doItemSetAttribute(myball.uid, "offense", getItemAttribute(myball.uid, "offense") + off)
doItemSetAttribute(myball.uid, "defense", getItemAttribute(myball.uid, "defense") + def)
doItemSetAttribute(myball.uid, "speed", getItemAttribute(myball.uid, "speed") + agi)
doItemSetAttribute(myball.uid, "specialattack", getItemAttribute(myball.uid, "specialattack") + spatk)
doItemSetAttribute(myball.uid, "vitality", getItemAttribute(myball.uid, "vitality") + vit)
doRemoveItem(item.uid)
doSendMagicEffect(getThingPos(item2.uid), 103)
doPlayerSendTextMessage(cid, 27, "Congrulations, your "..pokemon..", as beem boosted +"..boosts..".")
doPlayerSendTextMessage(cid, 27, "Now your "..pokemon.." have a boost +"..newBoost..".")
doSendAnimatedText(getThingPos(item2.uid), "+"..boosts.." Boost", 215)
return true 
end
 
 
-----Shiny stone:
local evo = {
                           --nome do shiny, qnts stones precisa
["Snorlax"] = {"Shiny Snorlax", '7},
["Gengar"] = {"Shiny Gengar", 6},
["Ninetales"] = {"Shiny Ninetales",  6},
["Raichu"] = {"Shiny Raichu", 6},
["Alakazam"] = {"Shiny Alakazam", 9},
["Venusaur"] = {"Shiny Venusaur", 6},
["Charizard"] = {"Shiny Charizard", 6},
["Infernape"] = {"Shiny Infernape", 9},
["Blastoise"] = {"Shiny Blastoise", 6}, --alterado v2.4
["Butterfree"] = {"Shiny Butterfree", 3},
["Beedrill"] = {"Shiny Beedrill", 3},
["Pidgeot"] = {"Shiny Pidgeot", 5},
["Rattata"] = {"Shiny Rattata", 1},
["Raticate"] = {"Shiny Raticate", 2},
["Fearow"] = {"Shiny Fearow", 4},
["Zubat"] = {"Shiny Zubat", 1},
["Golbat"] = {"Shiny Golbat", 3},
["Onix"] = {"Shiny Onix", 5},
["Salamence"] = {"Shiny Salamence", 9},
["Zoroark"] = {"Shiny Zoroark", 10},
["Oddish"] = {"Shiny Oddish", 1},
["Paras"] = {"Shiny Paras", 1},
["Parasect"] = {"Shiny Parasect", 5},
["Venonat"] = {"Shiny Venonat", 1},
["Venomoth"] = {"Shiny Venomoth", 6},
["Growlithe"] = {"Shiny Growlithe", 1},
["Arcanine"] = {"Shiny Arcanine", 6},
["Abra"] = {"Shiny Abra", 1},
["Tentacool"] = {"Shiny Tentacool", 1},
["Tentacruel"] = {"Shiny Tentacruel", 6},
["Farfetch'd"] = {"Shiny Farfetch'd", 6},
["Muk"] = {"Shiny Muk", 1},
["Kingler"] = {"Shiny Kingler", 3},
["Voltorb"] = {"Shiny Voltorb", 1},
["Electrode"] = {"Shiny Electrode", 3},
["Cubone"] = {"Shiny Cubone", 1},
["Marowak"] = {"Shiny Marowak", 3},
["Hitmonlee"] = {"Shiny Hitmonlee", 4},
["Hitmonchan"] = {"Shiny Hitmonchan", 5},
["Tangela"] = {"Shiny Tangela", 3},
["Horsea"] = {"Shiny Horsea", 1},
["Seadra"] = {"Shiny Seadra", 3},
["Scyther"] = {"Shiny Scyther", 6},
["Jynx"] = {"Shiny Jynx", 5},
["Electabuzz"] = {"Shiny Electabuzz", 5},
["Pinsir"] = {"Shiny Pinsir", 5},
["Magikarp"] = {"Shiny Magikarp", 1},
["Gyarados"] = {"Shiny Gyarados", 6},
["Dratini"] = {"Shiny Dratini", 1},
["Dragonair"] = {"Shiny Dragonair", 5},
["Dragonite"] = {"Shiny Dragonite", 7},
["Salamence"] = {"Shiny Salamence", 9},
["Metagross"] = {"Shiny Metagross", 10},
["Tropius"] = {"Shiny Tropius", 10},
["Milotic"] = {"Shiny Milotic", 9},
["Honchkrow"] = {"Shiny Honchkrow", 10},
}
local balls = {
[11826] = {newBall = 11826},
[11832] = {newBall = 11832},
[11835] = {newBall = 11835},
[11829] = {newBall = 11829},
}
 
function onUse(cid, item, fromPosition, itemEx, toPosition)
   if isMonster(itemEx.uid) and getCreatureMaster(itemEx.uid) == cid then
          local monster = getCreatureName(itemEx.uid)
          if evo[monster] then  
                 if getPlayerItemCount(cid, item.itemid) >= evo[monster][5,10] then
                    doPlayerSendTextMessage(cid, 27, "Parabens! Seu "..getPokeName(itemEx.uid).." evoluiu para "..evo[monster][5,10].."!")
                    local health, maxHealth = getCreatureHealth(itemEx.uid), getCreatureMaxHealth(itemEx.uid)
                    doSendMagicEffect(getThingPos(itemEx.uid), 18)
                    doRemoveCreature(itemEx.uid)
                    doPlayerRemoveItem(cid, item.itemid, evo[monster][0]-1)
                    doRemoveItem(item.uid, 5,10)
                    doSummonMonster(cid,evo[monster][1])
                    local pokeball = getPlayerSlotItem(cid, 8)
                    doItemSetAttribute(pokeball.uid, "poke", evo[monster][1])
                    doItemSetAttribute(pokeball.uid, "level", pokes[evo[monster][1]].level)
                    doItemSetAttribute(ball, "hp", 1)
                    doItemSetAttribute(ball, "happy", 110)
                    local pk = getCreatureSummons(cid)[1]
                    adjustStatus(pk, pokeball.uid, true, false, true)
                    return TRUE
                 else
                    return doPlayerSendTextMessage(cid, 27, "You need atleast ".. evo[monster][5,10] .." stones to do it!")
                 end
          end
end
return True
end