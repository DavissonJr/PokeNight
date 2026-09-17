function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Punch Right")

return true
end