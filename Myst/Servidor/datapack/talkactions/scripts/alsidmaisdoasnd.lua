function onSay(cid, words, param)

local typess = {       --alterado v1.9 \/
[1] = "normal",
[2] = "great",
[3] = "super",
[4] = "ultra",
}

if param == "" or param == " " then
   doPlayerSendCancel(cid, 'Command needs parameters.')
   return true
end

local t = string.explode(param, ",")
--
local name = ""
local btype = (tostring(t[4]) and pokeballs[t[4]]) and t[4] or typess[math.random(1, #typess)] 
local gender = (t[3] and tonumber(t[3])) and tonumber(t[3]) or t[3] and t[3] or nil              

if tostring(t[1]) then
	name = doCorrectString(t[1])   
	if not pokes[name] then
	   doPlayerSendCancel(cid, ""..name.." not exists.")
	   return true
	end
end

addPokeToPlayer(cid, name, (t[2] and tonumber(t[2]) or 0), gender, btype)

return true
end
