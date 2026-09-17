function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Healing Rain")

return true
end