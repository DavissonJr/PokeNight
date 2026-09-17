function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Combined Attack")

return true
end