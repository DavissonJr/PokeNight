function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Intubate")

return true
end