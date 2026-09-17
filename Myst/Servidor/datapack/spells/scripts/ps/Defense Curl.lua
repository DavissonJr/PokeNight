function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Defense Curl")

return true
end