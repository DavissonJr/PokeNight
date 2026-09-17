function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Ice Shards")

return true
end