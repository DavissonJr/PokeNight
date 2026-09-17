function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Wing Attack")

return true
end