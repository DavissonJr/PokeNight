function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Two Face Shock")

return true
end