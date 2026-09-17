function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "ExtremeSpeed")

return true
end