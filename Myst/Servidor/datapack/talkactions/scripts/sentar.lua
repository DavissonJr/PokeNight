  local sentar = {health = 5, mana = 5}
        local storage = 12345
        local events = {}

function onSay(cid, words)  

   if getTilePzInfo(getPlayerPosition(cid)) then
        if getPlayerStorageValue(cid, 12345) == -1 then
                doCreatureSay(cid, "Ahh, vou descansar...", TALKTYPE_MONSTER)
                doSendMagicEffect(getCreaturePosition(cid), 1)
                doPlayerAddHpManaSentar(cid, sentar)
                doCreatureSetNoMove(cid, true)
                setPlayerStorageValue(cid, 12345, 1)
else
                setPlayerStorageValue(cid, 12345, -1)
                doCreatureSetNoMove(cid, false)
                doCreatureSay(cid, "Já descansei.", TALKTYPE_MONSTER)
                stopEvent(hpmana)
        end
        end
return true
end

function doPlayerAddHpManaSentar(cid, formula)
if not isCreature(cid) then return true end
  doCreatureAddHealth(cid, formula.health)
  doCreatureAddMana(cid, formula.mana)
  hpmana = addEvent(doPlayerAddHpManaSentar, 5000, cid, formula)
end