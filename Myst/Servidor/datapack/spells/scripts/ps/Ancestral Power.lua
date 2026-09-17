function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Ancestral Power")

return true
end