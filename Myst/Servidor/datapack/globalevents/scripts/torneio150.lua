function onTimer()
if #getPlayersInArea(torneiomary.areamary) <= 0 then
return true
end
for _, pid in ipairs(getPlayersInArea(torneiomary.waitAreamary)) do
rand = math.random(-15, 15)
doTeleportThing(pid, {x = torneiomary.tournamentFightmary.x + rand, y = torneiomary.tournamentFightmary.y + rand, z = torneiomary.tournamentFightmary.z})
end
doBroadcastMessage("O torneio de johto 150- começou!")
return true
end