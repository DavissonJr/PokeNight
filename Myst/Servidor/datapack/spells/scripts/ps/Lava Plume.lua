function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Lava Plume")

return true
end