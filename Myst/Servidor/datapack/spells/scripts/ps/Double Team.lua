function onCastSpell(cid, var)

	if isSummon(cid) then return true end

   local function RemoveTeam(cid)
   if isCreature(cid) then
      local p = getThingPos(cid)
      doSendMagicEffect(p, 211)
      doRemoveCreature(cid)
   end
   end
   
   local function setGender(cid, gender)
         if not isCreature(cid) then return true end
         doCreatureSetSkullType(cid, gender)
   end
         
   if getPlayerStorageValue(cid, 637500) >= 1 or getPlayerStorageValue(cid, 637501) >= 1 then
   return true
   end
   
   local s = {
   ["Xatu"] = "XatuTeam",
   ["Yanma"] = "YanmaTeam",
   }
   
    doCreatureSay(cid, "Double Team!", TALKTYPE_MONSTER)
    local master = cid
    local pos = getThingPos(cid)                  
    local time = 20
    local life = getCreatureHealth(cid)
    local maxLife = getCreatureMaxHealth(cid)
    local gender = getPokemonGender(cid)
    local random = math.random(5, 10)
    local dir = getCreatureLookDir(cid)
    ---------
    doDisapear(cid)
    doTeleportThing(cid, {x=4, y=3, z=10}, false) 
    doAppear(cid)
    ---------
    doSummonMonster(master, s[getCreatureName(cid)])
    local pk = getCreatureSummons(master)[1]
    addEvent(setGender, 20, cid, gender)
    setCreatureMaxHealth(pk, maxLife)
    doCreatureAddHealth(pk, life-maxLife)
    ---------
    doTeleportThing(pk, getClosestFreeTile(pk, pos), false)
    doTeleportThing(cid, getClosestFreeTile(cid, pos), false)
    doCreatureSetLookDir(pk, dir)
    doCreatureSetLookDir(cid, dir)
    doSendMagicEffect(getThingPos(pk), 211)
    doSendMagicEffect(getThingPos(cid), 211)
    if getPlayerStorageValue(cid, 9658783) >= 1 then          --gambiarra
       doBuffSyst(pk, getPlayerStorageValue(cid, 36847), 0, false, "Future Sight", true)
    end
    --------
    setPlayerStorageValue(pk, 637500, 1)
    setPlayerStorageValue(master, 637501, 1)
    addEvent(RemoveTeam, time*1000, pk)
    addEvent(setPlayerStorageValue, time*1000, master, 637501, -1)

return true
end