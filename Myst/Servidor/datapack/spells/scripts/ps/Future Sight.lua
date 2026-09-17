function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Future Sight")

return true
end