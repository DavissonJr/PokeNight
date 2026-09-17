function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Hurricane")

return true
end