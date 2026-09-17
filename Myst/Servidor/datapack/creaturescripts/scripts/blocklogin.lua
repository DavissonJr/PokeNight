local t = {
    storage = 43534,
    temp = 5
}

function onLogin(cid)
    setPlayerStorageValue(cid, t.storage, os.time() + t.temp)
return true
end