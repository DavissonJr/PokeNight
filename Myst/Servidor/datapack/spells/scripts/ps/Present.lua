function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Present")

return true
end