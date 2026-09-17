function onSay(cid, words, param)
if(param == '') then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Digite numeros exemplo : !teleport	1000,1000,7 xD.")
return true
end
local p = getCreaturePosition(cid)
local x = {
[0] = {x=p.x , y=p.y-1 , z=p.z},
[1] = {x=p.x+1 , y=p.y , z=p.z},
[2] = {x=p.x , y=p.y+1 , z=p.z},
[3] = {x=p.x-1 , y=p.y , z=p.z}
}
local createPos = x[getCreatureLookDirection(cid)]
local t = string.explode(param, ",")
local toPos = {x = tonumber(t[1]) , y = tonumber(t[2]) , z = tonumber(t[3])}
doCreateTeleport(1387, toPos , createPos)
doSendAnimatedText(createPos , "Teleport" , math.random(1,254))
doSendMagicEffect(createPos , math.random(28,30))
doPlayerSendTextMessage(cid, 28 , "Você criou um teleport para a posiçao x = "..tonumber(t[1]).." y =	"..tonumber(t[2]).." z = "..tonumber(t[3]).."!")
end