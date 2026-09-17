function playerAddExp(cid, exp)
   if not isPlayer(cid) then 
       return true 
   end

   if isPremium(cid) then
    exp = exp * 1.2
    doSendAnimatedText(getThingPos(cid), "+ VIP EXP", COLOR_YELLOW)
   end

   if getPlayerLevel(cid) >= 300 then
    exp = exp * 6.5
   end

   doPlayerAddExp(cid, exp)
   doSendAnimatedText(getThingPos(cid), exp, 215)
end

local Exps = {
{minL = 1, maxL = 51, multipler = 0.8},
{minL = 51, maxL = 150, multipler = 0.5},
{minL = 150, maxL = 199, multipler = 0.4},
{minL = 200, maxL = 249, multipler = 0.3},
{minL = 250, maxL = 299, multipler = 0.1},
}

local function calculaExp(cid, expTotal)
if not isPlayer(cid) then return 0 end
   local expFinal = expTotal
   local flag = false
   for _, TABLE in pairs(Exps) do
          if getPlayerLevel(cid) >= TABLE.minL and getPlayerLevel(cid) <= TABLE.maxL then
                 flag = true
                 expFinal = expFinal * TABLE.multipler
                 break
          end
   end
   if not flag then expFinal = expFinal * 0.1 end --lvl 300+
return math.floor(expFinal)
end

function onDeath(cid, corpse, deathList)
   if not isCreature(cid) then 
       return true 
   end

   local givenexp = getWildPokemonExp(cid)
   if givenexp > 0 then
       for a = 1, #deathList do
            local pk = deathList[a]
            local list = getSpectators(getThingPosWithDebug(pk), 7, 7, false)
            if isCreature(pk) then
                local expTotal = math.floor(playerExperienceRate * givenexp / 2.1)
                expTotal = calculaExp(pk, expTotal)

                local party = getPartyMembers(pk)
                if isInParty(pk) and getPlayerStorageValue(pk, 4875498) <= -1 then
                    expTotal = math.floor(expTotal/#party)
                    for i = 1, #party do
                        if isInArray(list, party[i]) then
                            playerAddExp(party[i], expTotal)
                        end
                    end
                else
                    playerAddExp(pk, expTotal)
                end

               -- onSpawnShiny(pk, cid) -- Thalles Vitor - Charm System (MEGA)
            end
        end
   end

   if isNpcSummon(cid) then
        local master = getCreatureMaster(cid)
        doSendMagicEffect(getThingPos(cid), getPlayerStorageValue(cid, 10000))
        doCreatureSay(master, getPlayerStorageValue(cid, 10001), 1)
        doRemoveCreature(cid)
        return false
   end

   if corpse.itemid ~= 0 then --alterado v1.8
        doItemSetAttribute(corpse.uid, "corpseName", "fainted " .. getCreatureName(cid))
        doItemSetAttribute(corpse.uid, "level", getPokemonLevel(cid))
        doItemSetAttribute(corpse.uid, "gender", getPokemonGender(cid))

        if not isInArray({3, 4, 1, -1}, getPokemonGender(cid)) then
            doItemSetAttribute(corpse.uid, "gender", math.random(3, 4))
            doItemSetAttribute(corpse.uid, "level", 1)
        end

        -- Thalles Vitor - Horder System --
        local horder_addon = horders_addon[getCreatureOutfit(cid).lookType]
        if horder_addon and horder_addon.horder and horder_addon.horder == getCreatureName(cid) then
            doItemSetAttribute(corpse.uid, "isHorder", 1)
            doItemSetAttribute(corpse.uid, "addonLookType", getCreatureOutfit(cid).lookType)
        end
        --
   end
    return true
end