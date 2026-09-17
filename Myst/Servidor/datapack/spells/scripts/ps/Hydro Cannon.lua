function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Hydro Cannon")

return true
end