function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Hyper Beam")

return true
end