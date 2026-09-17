function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Twister")

return true
end