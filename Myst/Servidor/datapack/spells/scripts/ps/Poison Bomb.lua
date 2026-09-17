function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Poison Bomb")

return true
end