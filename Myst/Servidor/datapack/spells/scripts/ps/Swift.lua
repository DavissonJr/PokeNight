function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Swift")

return true
end