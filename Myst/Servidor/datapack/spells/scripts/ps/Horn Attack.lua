function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Horn Attack")

return true
end