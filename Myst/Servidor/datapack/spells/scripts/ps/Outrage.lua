function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Outrage")

return true
end