function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Primordial Attack")

return true
end