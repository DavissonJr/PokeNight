function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Flamethrower")

return true
end