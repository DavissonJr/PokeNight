function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Zap Cannon")

return true
end