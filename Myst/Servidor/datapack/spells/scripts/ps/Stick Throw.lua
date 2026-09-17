function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Stick Throw")

return true
end