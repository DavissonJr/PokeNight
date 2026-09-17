function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Doubleslap")

return true
end