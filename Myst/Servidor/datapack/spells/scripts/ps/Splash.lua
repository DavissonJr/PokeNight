function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Splash")

return true
end