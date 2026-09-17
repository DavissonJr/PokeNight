local time = 5 -- 1 = 1 sec, 2 = 2 sec, ...

local say_events = {}

local function SayText(cid)

if isPlayer(cid) == TRUE then

if say_events[getPlayerGUID(cid)] ~= nil then

if isPlayer(cid) == TRUE then

doSendAnimatedText(getPlayerPosition(cid),"Já volto!", math.random(01,255))

end

say_events[getPlayerGUID(cid)] = addEvent(SayText, time * 1000 / 2, cid)

end

end

return TRUE

end

function onSay(cid, words, param, channel)

if(param == '') then

doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Fale !afk on para começar a ficar afk e fale !afk off para sair do afk.")

return true

end

if param == "on" then

if isPlayer(cid) == TRUE then

doSendAnimatedText(getPlayerPosition(cid),"Já volto!", math.random(01,255))

end

say_events[getPlayerGUID(cid)] = addEvent(SayText, time * 1000, cid)

doPlayerSendTextMessage(cid,MESSAGE_STATUS_WARNING,"Agora você esta afk.")

elseif param == "off" then

stopEvent(say_events[getPlayerGUID(cid)])

say_events[getPlayerGUID(cid)] = nil

doPlayerSendTextMessage(cid,MESSAGE_STATUS_WARNING,"Agora você não esta mais afk.")

end

return TRUE

end