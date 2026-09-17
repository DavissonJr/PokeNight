function onUse(cid, item)

local t = {
{uid=36667, storage=15354, recompensa=11447, mensagem="Parabéns, você ganhou uma Fire Stone."},
{uid=36668, storage=15354, recompensa=11441, mensagem="Parabéns, você ganhou uma Leaf Stone."},
{uid=36669, storage=15354, recompensa=11442, mensagem="Parabéns, você ganhou uma Water Stone."},
}

if item.uid == t[1].uid and getPlayerStorageValue(cid, t[1].storage) == -1 then
doPlayerAddItem(cid, t[1].recompensa, 1)
doPlayerSendTextMessage(cid, 22, t[1].mensagem)
setPlayerStorageValue(cid, t[1].storage, 1)

elseif item.uid == t[2].uid and getPlayerStorageValue(cid, t[2].storage) == -1 then
doPlayerAddItem(cid, t[2].recompensa, 1)
doPlayerSendTextMessage(cid, 22, t[2].mensagem)
setPlayerStorageValue(cid, t[2].storage, 1)

elseif item.uid == t[3].uid and getPlayerStorageValue(cid, t[3].storage) == -1 then
doPlayerAddItem(cid, t[3].recompensa, 1)
doPlayerSendTextMessage(cid, 22, t[3].mensagem)
setPlayerStorageValue(cid, t[3].storage, 1)

end
return doPlayerSendCancel(cid, "Você já fez está quest.")
end