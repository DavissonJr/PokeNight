function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Egg Bomb")

return true
end