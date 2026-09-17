function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Tailwind")

return true
end