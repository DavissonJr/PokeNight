function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Ancient Power")

return true
end