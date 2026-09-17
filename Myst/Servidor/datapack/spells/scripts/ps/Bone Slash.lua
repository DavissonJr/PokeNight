function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bone Slash")

return true
end