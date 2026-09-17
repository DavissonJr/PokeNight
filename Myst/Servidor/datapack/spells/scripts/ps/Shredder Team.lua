function onCastSpell(cid, var)      --alterado v1.8 \/

if isSummon(cid) then return true end
local team = {
["Scyther"] = "ScytherTeam",
["Shiny Scyther"] = "Shiny ScytherTeam",
["Scizor"] = "ScizorTeam",
}

function adjustLife(cid, health)
if isCreature(cid) then
   setCreatureMaxHealth(cid, (getVitality(cid) * HPperVITwild)) 
   doCreatureAddHealth(cid,  getCreatureMaxHealth(cid))
   doCreatureAddHealth(cid, -(math.abs(health)))
end
end   
   
function setStorage(cid, storage)
if isCreature(cid) then
   if getPlayerStorageValue(cid, storage) >= 1 then
      setPlayerStorageValue(cid, storage, 0)
   end
end
end

function RemoveTeam(cid)
if isCreature(cid) then
  doSendMagicEffect(getThingPos(cid), 211)
  doRemoveCreature(cid)
end
end

if getPlayerStorageValue(cid, 637500) >= 1 or getPlayerStorageValue(cid, 637501) >= 1 then
return true
end

local name = getCreatureName(cid)
local pos = getThingPos(cid)
local time = 15
local life, maxLife = getCreatureHealth(cid), getCreatureMaxHealth(cid)
local gender = getPokemonGender(cid)
local num = (name == "Scizor") and 4 or 3
local pk = {}

doCreatureSay(cid, "Shredder Team!", TALKTYPE_MONSTER)
if team[name] then

   pk[1] = cid
   doSendMagicEffect(getThingPos(pk[1]), 211)
   addEvent(doTeleportThing, math.random(0, 5), pk[1], getClosestFreeTile(pk[1], pos), false)
   
   for i = 2, num do
       pk[i] = doSummonCreature(team[name], pos)
       doConvinceCreature(pk[1], pk[i])
       ----
       addEvent(setPokemonGender, 150, pk[i], gender)
       addEvent(adjustLife, 150, pk[i], life-maxLife)
       doSendMagicEffect(getThingPos(pk[i]), 211)
   end
   
   setPlayerStorageValue(pk[1], 637501, 1)
   addEvent(setStorage, time * 1000, pk[1], 637501)
   ---
   setPlayerStorageValue(pk[2], 637500, 1)
   addEvent(RemoveTeam, time * 1000, pk[2])
   ---
   setPlayerStorageValue(pk[3], 637500, 1)
   addEvent(RemoveTeam, time * 1000, pk[3])
   ---
   if name == "Scizor" then
      setPlayerStorageValue(pk[4], 637500, 1)
      addEvent(RemoveTeam, time * 1000, pk[4])
   end
end

return true
end