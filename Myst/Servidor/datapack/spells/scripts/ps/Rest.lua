function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Rest")

return true
end