local config = {
max = 1, -- Número de players permitido com o mesmo IP.
group_id = 1 -- Kikar apenas player com o group id 1.
}

local accepted_ip_list = {"179.99.72.231"} -- Lista dos players permitidos a usar MC, exemplo: {"152.250.192.133", "152.250.192.133"}

local function antiMC(p)
if not isCreature(p.pid) then return true end
if #getPlayersByIp(getPlayerIp(p.pid)) >= p.max then
doRemoveCreature(p.pid)
end
return true
end

function onLogin(cid)
if not isCreature(cid) then return true end
if getPlayerGroupId(cid) <= config.group_id then
if isInArray(accepted_ip_list,doConvertIntegerToIp(getPlayerIp(cid))) == false then
addEvent(antiMC, 1000, {pid = cid, max = config.max+1})
end
end
return true
end