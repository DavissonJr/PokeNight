function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Aerial Ace")

return true
end