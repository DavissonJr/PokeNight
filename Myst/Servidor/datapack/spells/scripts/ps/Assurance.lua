function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Assurance")

return true
end