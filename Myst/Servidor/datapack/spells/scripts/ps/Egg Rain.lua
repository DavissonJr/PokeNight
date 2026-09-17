function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Egg Rain")

return true
end