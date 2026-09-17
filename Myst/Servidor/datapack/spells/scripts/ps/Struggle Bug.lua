function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Struggle Bug")

return true
end