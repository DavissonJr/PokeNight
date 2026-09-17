function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Scizor Attack")

return true
end