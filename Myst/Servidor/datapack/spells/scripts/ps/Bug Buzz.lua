function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Bug Buzz")

return true
end