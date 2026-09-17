function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Aqua Tail")

return true
end