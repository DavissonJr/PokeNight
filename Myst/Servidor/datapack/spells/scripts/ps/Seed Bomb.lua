function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Seed Bomb")

return true
end