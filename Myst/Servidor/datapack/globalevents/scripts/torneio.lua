function onTimer()
if #getPlayersInArea(torneio.area) <= 0 then
return true
end
for _, pid in ipairs(getPlayersInArea(torneio.waitArea)) do
rand = math.random(-15, 15)
doTeleportThing(pid, {x = torneio.tournamentFight.x + rand, y = torneio.tournamentFight.y + rand, z = torneio.tournamentFight.z})
end
doBroadcastMessage("O torneio de johto 150+ começou!")
return true
end