function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Skull Bash")

return true
end