function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bug Power")

return true
end