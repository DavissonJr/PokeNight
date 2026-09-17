function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Take Down")

return true
end