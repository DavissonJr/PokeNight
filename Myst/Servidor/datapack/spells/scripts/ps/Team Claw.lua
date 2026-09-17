function onCastSpell(cid, var)
if isSummon(cid) then return true end

local function nois(cid, s)
if not isCreature(cid) then return true end
    doChangeSpeed(cid, s)
end

local function doTeam(cid, a, eff, posis, target)
if isCreature(cid) then
   doDisapear(cid)
   doChangeSpeed(cid, -a)
   addEvent(doSendMagicEffect, 300, posis, 211)
   addEvent(doSendDistanceShoot, 350, posis, getThingPos(target), eff)
   addEvent(doSendDistanceShoot, 450, getThingPos(target), posis, eff)
   addEvent(doSendDistanceShoot, 600, posis, getThingPos(target), eff)
   addEvent(doSendDistanceShoot, 650, getThingPos(target), posis, eff)
   addEvent(nois, 670, cid, a)
   addEvent(doAppear, 670, cid)
end
end

local master = getCreatureMaster(cid) or cid
local summons = getCreatureSummons(master)
local posis = {[1] = pos1, [2] = pos2, [3] = pos3, [4] = pos4}
local target = getCreatureTarget(master)
local a = getCreatureSpeed(cid)
local minn = 80 * 9
local maxx = minn + 80 * 2

if getCreatureOutfit(cid).lookType == 366 then
 eff = 27
elseif getCreatureOutfit(cid).lookType == 1317 then
 eff = 29
else
 eff = 20
end

   if #getCreatureSummons(master) >= 1 and isCreature(target) and not ehNPC(master) then
      if isCreature(cid) then
         doCreatureSay(master, "Team Slice!", TALKTYPE_MONSTER)
         addEvent(doTargetCombatHealth, 500, cid, target, BUGDAMAGE, -minn, -maxx, 255)
         posis[1] = getThingPos(master)
         doTeam(master, a, eff, posis[1], target)
         for i = 1, #summons do
             posis[i+1] = getThingPos(summons[i])
             doTeam(summons[i], a, eff, posis[i+1], target)
         end
      end
    end

return true
end