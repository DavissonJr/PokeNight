function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Night Slash")

return true
end