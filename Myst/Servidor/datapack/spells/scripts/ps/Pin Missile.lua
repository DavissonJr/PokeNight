function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Pin Missile")

return true
end