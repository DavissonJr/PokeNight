function onTimer()
if #getPlayersInArea(torneiokanto.areakanto) <= 0 then
return true
end
for _, pid in ipairs(getPlayersInArea(torneiokanto.waitAreakanto)) do
rand = math.random(-15, 15)
doTeleportThing(pid, {x = torneiokanto.tournamentFightkanto.x + rand, y = torneiokanto.tournamentFightkanto.y + rand, z = torneiokanto.tournamentFightkanto.z})
end
doBroadcastMessage("O torneio de kanto começou!")
return true
end