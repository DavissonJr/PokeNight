function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Metronome")

return true
end