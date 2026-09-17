function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Toxic Spikes")

return true
end