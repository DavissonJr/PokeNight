function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bone Club")

return true
end