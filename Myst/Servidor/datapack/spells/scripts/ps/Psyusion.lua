function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Psyusion")

return true
end