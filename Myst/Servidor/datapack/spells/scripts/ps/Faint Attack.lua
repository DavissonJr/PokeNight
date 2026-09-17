function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Faint Attack")

return true
end