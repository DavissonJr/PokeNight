function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Eletric Claw")

return true
end