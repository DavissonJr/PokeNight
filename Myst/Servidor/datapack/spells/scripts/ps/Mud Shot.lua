function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Mud Shot")

return true
end