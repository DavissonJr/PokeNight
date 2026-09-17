function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Shell Attack")

return true
end