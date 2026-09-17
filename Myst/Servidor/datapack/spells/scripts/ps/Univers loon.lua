function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Univers loon")

return true
end