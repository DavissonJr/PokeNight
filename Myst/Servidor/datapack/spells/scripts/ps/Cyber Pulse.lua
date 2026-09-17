function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Cyber Pulse")

return true
end