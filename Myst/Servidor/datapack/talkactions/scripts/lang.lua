function onSay(cid, words, param)

if(param == '') then
return true
end

if(param == 'en') then
if getPlayerLanguage(cid) == 2 then
doPlayerSendTextMessage(cid, 20, "[Language System (Beta)] Your language is alredy set to english.")
return true
else
doPlayerSendTextMessage(cid, 27, "[Language System (Beta)] You have set english as your language.")
doPlayerSetLanguage(cid, 2)
return true
end
end

if(param == 'pt') then
if getPlayerLanguage(cid) == 0 then
doPlayerSendTextMessage(cid, 20, "[Language System (Beta)] Sua língua já está definida como português.")
return true
else
doPlayerSendTextMessage(cid, 27, "[Language System (Beta)] Você definiu o português como sua língua.")
doPlayerSetLanguage(cid, 0)
return true
end
end

if(param == 'es') then
if getPlayerLanguage(cid) == 1 then
doPlayerSendTextMessage(cid, 20, "[Language System (Beta)] Su lengua ya esta definida como español.")
return true
else
doPlayerSendTextMessage(cid, 27, "[Language System (Beta)] Tu definistes el español como tu lengua.")
doPlayerSetLanguage(cid, 1)
return true
end
end
end
