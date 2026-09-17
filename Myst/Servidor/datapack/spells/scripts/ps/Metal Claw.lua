function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Metal Claw")

return true
end