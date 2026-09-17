function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Stone Edge")

return true
end