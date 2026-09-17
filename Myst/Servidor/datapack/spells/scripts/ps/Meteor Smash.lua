function onCastSpell(cid, var)

	if isSummon(cid) then return true end

	docastspell(cid, "Meteor Smash")

return true
end