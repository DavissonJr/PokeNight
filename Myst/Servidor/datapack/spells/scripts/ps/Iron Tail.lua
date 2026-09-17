function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Iron Tail")

return true
end