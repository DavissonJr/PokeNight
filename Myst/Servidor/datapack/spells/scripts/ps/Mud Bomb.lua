function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Mud Bomb")

return true
end