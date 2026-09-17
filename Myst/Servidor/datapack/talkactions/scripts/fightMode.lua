function onSay(cid, words, param, channel)

if useOTClient then
if tonumber(param) ~= nil and isInArray({1, 2, 3}, tonumber(param)) then
   setPlayerStorageValue(cid, 248759, tonumber(param))
end
end

return true
end