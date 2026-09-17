local monsters = { "Rattata", "Magikarp", "Rattata", "Alakazam", "Gengar", "Rattata", "Lapras", "Regice", "Venusaur", "Caterpie", "Horsea", "Charizard", "Gloom"} -- Monstros que podem ser sorteados
local time_min, max = 9,10  -- Em minutos
local premioos = {11441, 11442, 11443, 11444, 11445, 11446, 11447, 11448, 11449, 11450, 11451, 12618, 13088}

local premios, gold = {{2152, 10}}, 10000 -- {id do item, quantidade} que o jogador ganha e quantia de gold

function winMonsterEvent()
local max_sto, winner = 0, 0
local monster = getGlobalStorageValue(90904488)
for _, pid in pairs(getPlayersOnline()) do
local sto = getPlayerStorageValue(pid, 90904487)
if sto > max_sto then
max_sto = sto
winner = pid
end
end
local randomChance = math.random(1, #premioos)
if isPlayer(winner) then
local artigo = getPlayerSex(winner) == 0 and "[PokeHUNTING] A jogadora" or "[PokeHUNTING] O jogador"
doBroadcastMessage(artigo.." "..getCreatureName(winner).." matou "..getPlayerStorageValue(winner, 90904487).." "..monster.."s e venceu o evento, parabens!",25)
for _, prize in pairs(premios) do
doPlayerAddItem(winner, prize[1], prize[2])
doPlayerAddItem(winner, premioos[randomChance])
end
else
doBroadcastMessage("[PokeHUNTING] O evento terminou e nao houve nenhum vencedor.")
end
setGlobalStorageValue(90904488, 0)
end 


function onTimer()
local random = math.random(1, #monsters)
local time = math.random(time_min, max)
for _, pid in pairs(getPlayersOnline()) do
doPlayerSetStorageValue(pid, 90904487, 0)
end
setGlobalStorageValue(90904488, monsters[random])
doBroadcastMessage("[PokeHUNTING] O evento comecou e vai durar "..time.." minuto. O pokemon sorteado foi "..monsters[random].."! Quem matar mais deles ate o fim sera o vencedor!",25)
addEvent(winMonsterEvent, time*1000*60) 
return true
end

--tag xml

-- <globalevent name="Monster Hunter Event" time="09:31" event="script" value="Monster Hunter.lua"/> 