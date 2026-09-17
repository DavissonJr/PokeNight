function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Charm")

return true
end