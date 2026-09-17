function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Cross Chop")

return true
end