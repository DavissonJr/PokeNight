function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Ultimate Champion")

return true
end