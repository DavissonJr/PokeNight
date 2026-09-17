function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Aurora Beam")

return true
end