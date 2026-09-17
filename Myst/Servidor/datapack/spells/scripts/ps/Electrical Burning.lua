function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Electrical Burning")

return true
end