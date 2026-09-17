function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "War Dog")

return true
end