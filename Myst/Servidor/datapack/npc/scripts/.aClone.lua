local target = 0
local prevTarget = 0
local origPos = 0
local max_distance = 12
local fighting = false
local challenger = 0
local battle_turn = 1		-- don't change
local challenger_turn = 0	-- don't change
---
local pbs = {11826, 11829, 11835, 11832, 11737, 11740, 11743, 11746}
local ball = {
[11826] = "normal",
[11829] = "ultra",
[11835] = "super",
[11832] = "great",
[11737] = "normal",
[11740] = "great", 
[11743] = "super",
[11746] = "ultra",
}

local pokemons = { }

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
local function doClone(cid, npc)
local o = getCreatureOutfit(cid)

local npcname = getCreatureName(cid)
local health, maxHealth = getCreatureHealth(cid), getCreatureMaxHealth(cid)
local npcoutfit = {lookType = o.lookType, lookHead = o.lookHead, lookBody = o.lookBody, lookLegs = o.lookLegs, lookFeet = o.lookFeet}

doSetCreatureOutfit(npc, npcoutfit, -1)
doCreatureSetNick(npc, npcname)
setCreatureMaxHealth(npc, maxHealth)
doCreatureAddHealth(npc, health)
------------
if isNpc(npc) then
local bp = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
local a = 1

----------
bUID = getPlayerSlotItem(cid, 8)

if bUID.itemid ~= 0 then
   local nome = getItemAttribute(bUID.uid, "poke")
   local sexy = getItemAttribute(bUID.uid, "gender")
   local boost = getItemAttribute(bUID.uid, "boost") or 0
   local nick = getItemAttribute(bUID.uid, "nick") or ""
   local balls = ball[bUID.itemid]
   local optional = (getPokemonLevelByName(nome)+boost)+70 --optitional lvl
   local aura = getItemAttribute(bUID.uid, "aura")
   pokemons[a] = {name = nome, optionalLevel = optional, sex = sexy, nick = nick, ball = balls, boost = boost, aura = aura}
   a = a+1
end
----------        
for i = 1, 8 do
local items = getItemsInContainerById(bp.uid, pbs[i]) 
   if #items >= 1 then
      for _, uid in pairs(items) do
          local nome2 = getItemAttribute(uid, "poke")
          local sexy2 = getItemAttribute(uid, "gender")
          local boost2 = getItemAttribute(uid, "boost") or 0
          local nick2 = getItemAttribute(uid, "nick") or ""
          local balls2 = ball[pbs[i]]
          local optional2 = (getPokemonLevelByName(nome2)+boost2)+70 --optitional lvl
          local aura2 = getItemAttribute(uid, "aura")
          pokemons[a] = {name = nome2, optionalLevel = optional2, sex = sexy2, nick = nick2, ball = balls2, boost = boost2, aura = aura2}
          a = a+1
      end
   end
end 
end
end	
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
local function doSummonGymPokemon(npc)
	local this = npc
	if not isCreature(this) or not ehNPC(this) then return true end  --alterado v1.6
	if #getCreatureSummons(this) >= 1 or target == 0 then return true end
	local it = pokemons[battle_turn]
	if not it then return true end
	doSummonMonster(this, it.name)              
	local summon = getCreatureSummons(this)[1]
	local balleffect = pokeballs["normal"].effect
		if it.ball and pokeballs[it.ball] then
			balleffect = pokeballs[it.ball].effect
		end
	doSendMagicEffect(getThingPos(summon), balleffect)
	setPlayerStorageValue(summon, 10000, balleffect)
	setPlayerStorageValue(summon, 10001, gobackmsgs[math.random(#gobackmsgs)].back:gsub("doka", it.nick ~= "" and it.nick or it.name))
	setPlayerStorageValue(summon, 1007, it.nick ~= "" and it.nick or it.name)
	doSetMonsterGym(summon, target)
	addEvent(adjustWildPoke, 15, summon, it.optionalLevel)
	local name = it.nick ~= "" and it.nick or getCreatureName(this).."s "..it.name    --alterado v1.3
	---
    doCreatureSetNick(summon, it.nick ~= "" and it.nick or it.name)
	if it.boost == 50 then
       sendAuraEffect(summon, auraSyst[it.aura])
    end
    doCreatureSetSkullType(summon, it.gender)
    ---
    doCreatureSay(this, gobackmsgs[math.random(#gobackmsgs)].go:gsub("doka", getPlayerStorageValue(summon, 1007)), 1)
	fighting = true
	battle_turn = battle_turn + 1
end
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
local function goToOrigPos()
target = 0
selfFollow(0)
fighting = false
challenger = 0
challenger_turn = 0
battle_turn = 1
if #getCreatureSummons(getNpcCid()) >= 1 then
   setPlayerStorageValue(getCreatureSummons(getNpcCid())[1], 1006, 0)
   doCreatureAddHealth(getCreatureSummons(getNpcCid())[1], -getCreatureMaxHealth(getCreatureSummons(getNpcCid())[1]))
end
doChangeSpeed(getNpcCid(), -getCreatureSpeed(getNpcCid()))
doTeleportThing(getNpcCid(), origPos)
end
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
local function updateTarget()
if(target == 0) then
    local list = getSpectators(getNpcPos(), 9, 9, false)
    for i = 1, table.getn(list) do
        local _target = list[i]
        if(_target ~= 0) then
           if isPlayer(_target) and not getTileInfo(getThingPos(_target)).protection then --alterado v1.8
              selfSay("Você será morto sozinho! o.O")
              doClone(_target, getNpcCid())
              doNpcSetCreatureFocus(_target) 
              target = _target
              prevTarget = target
              break
           end
        end
    end
end
end
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--		
function onCreatureAppear(cid)
end

function onCreatureDisappear(cid)
end

function onCreatureMove(creature, oldPos, newPos)
--
end
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
function onThink()
if not isCreature(getNpcCid()) then return false end --alterado v1.6
if origPos == 0 then
   origPos = getNpcPos()
end
updateTarget() 
------------------------------------------------------
if getDistanceBetween(getNpcPos(), origPos) >= max_distance or (isCreature(target) and getTileInfo(getThingPos(target)).protection) or getTileInfo(getThingPos(getNpcCid())).protection then  
goToOrigPos()                                                                                                                          --alterado v1.9
end
------------------------------------------------------
if(target == 0) then
if getPlayerStorageValue(getNpcCid(), 154788) <= 0 then
   setPlayerStorageValue(getNpcCid(), 154788, 1)
   doChangeSpeed(getNpcCid(), -getCreatureSpeed(getNpcCid()))
   addEvent(randWalk, 2000, getNpcCid(), 1000, getPlayerStorageValue(getNpcCid(), 154788))
end
return true
end 
-----------------------------------------------------
local playerPos = getThingPosWithDebug(target)   --alterado v1.6
local myPos = getNpcPos()
-----------------------------------------------------
if(myPos.z ~= playerPos.z) then
goToOrigPos()
return
end
-----------------------------------------------------
if getDistanceBetween(playerPos, myPos) > max_distance then
goToOrigPos()
return
end
-----------------------------------------------------
if getDistanceBetween(playerPos, myPos) >= 5 then
if getPlayerStorageValue(getNpcCid(), 154788) >= 1 then
   setPlayerStorageValue(getNpcCid(), 154788, -1)
   doRegainSpeed(getNpcCid()) 
   if isCreature(target) then
      selfFollow(target)
   end
end
end
------------------------------------------------------
if getDistanceBetween(playerPos, myPos) <= 3 then
if getPlayerStorageValue(getNpcCid(), 154788) <= 0 then
   setPlayerStorageValue(getNpcCid(), 154788, 1)
   doChangeSpeed(getNpcCid(), -getCreatureSpeed(getNpcCid()))
   addEvent(randWalk, 2000, getNpcCid(), 1000, getPlayerStorageValue(getNpcCid(), 154788))
end
end
------------------------------------------------------
if getDistanceBetween(playerPos, myPos) <= 5 then
   challenger = target
   addEvent(doSummonGymPokemon, 850, getNpcCid())
   ---
local change = false

if not isCreature(target) then
   target = 0
   return true
end

if fighting then

   if not isCreature(getCreatureTarget(getNpcCid())) then
      if #getCreatureSummons(challenger) >= 1 then
         selfAttackCreature(getCreatureSummons(challenger)[1])
		 change = true
	  else
	      if change then
		     change = false
	         challenger_turn = challenger_turn + 1
		  end
      end
   end
		
   if #getCreatureSummons(getNpcCid()) == 0 and isCreature(target) then
      if battle_turn > #pokemons then      
         addEvent(doCreateNpc, 300000, ".aClone", myPos) --alterado v1.5
         doRemoveCreature(getNpcCid())
         local monster = doCreateMonster("aClone", myPos)
         addEvent(beDrunk, 100, monster)
         addEvent(doClone, 100, target, monster)
      end
	     addEvent(doSummonGymPokemon, 1000, getNpcCid())
   end

   if #getCreatureSummons(challenger) <= 0 then
      selfAttackCreature(challenger) 
   end  
end
end
end