function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Hammer Arm")

return true
end