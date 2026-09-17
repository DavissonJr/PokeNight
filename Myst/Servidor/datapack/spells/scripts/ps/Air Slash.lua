function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Air Slash")

return true
end