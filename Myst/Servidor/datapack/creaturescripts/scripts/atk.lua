function onAttack(cid, target)

if not isCreature(cid) then

return false

end

if isPlayer(target) then

if #getCreatureSummons(target) >= 1 then

doMonsterSetTarget(cid, getCreatureSummons(target)[1])

end

end

return true

end