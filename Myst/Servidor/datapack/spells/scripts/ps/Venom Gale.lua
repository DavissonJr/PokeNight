function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Venom Gale")

return true
end