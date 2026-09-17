function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Gyro Ball")

return true
end