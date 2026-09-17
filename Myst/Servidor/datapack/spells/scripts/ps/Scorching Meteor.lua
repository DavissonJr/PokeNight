function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Scorching Meteor")

return true
end