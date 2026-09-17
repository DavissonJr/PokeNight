function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Emergency Call")

return true
end