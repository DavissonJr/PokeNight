function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Tri-Attack")

return true
end