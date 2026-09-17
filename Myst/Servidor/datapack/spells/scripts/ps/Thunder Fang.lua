function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Thunder Fang")

return true
end