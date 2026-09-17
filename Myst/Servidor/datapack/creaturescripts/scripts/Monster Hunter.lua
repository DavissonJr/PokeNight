function onKill(cid, target, lastHit)
if isPlayer(cid) and isMonster(target) then
    if isPlayer(getCreatureMaster(target)) then
        return true
    end
local name = getGlobalStorageValue(90904488)
    if tostring(string.lower(getCreatureName(target))) == tostring(string.lower(name)) then
        doPlayerSetStorageValue(cid, 90904487, getPlayerStorageValue(cid, 90904487) + 1)
        doPlayerSendTextMessage(cid, 19, "[Pokemon Kill] Voce ja matou "..getPlayerStorageValue(cid, 90904487).." "..name.."s! Continue matando para ser o vencedor!")
    else
	-- print('target: '..string.lower(getCreatureName(target))..'')
	-- print('name: '..string.lower(name)..'')
	end
end
    return true
end

function onLogin(cid)
if getGlobalStorageValue(90904488) == 0 then
doPlayerSetStorageValue(cid, 90904487, 0)
end
registerCreatureEvent(cid, "MonsterHunter")
return true
end

--	registerCreatureEvent(cid, "Monster Hunter")
--    registerCreatureEvent(cid, "Monster Hunterl")

--tag xml
--<event type="kill" name="Monster Hunter" event="script" value="Monster Hunter.lua"/>
--<event type="login" name="Monster Hunterl" event="script" value="Monster Hunter.lua"/>