function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Strafe")

return true
end