function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Silver Wind")

return true
end