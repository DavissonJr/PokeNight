function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bullet Seed")

return true
end