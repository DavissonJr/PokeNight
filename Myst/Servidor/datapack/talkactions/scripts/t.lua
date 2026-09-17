

function dk(n)
	if n < 10 then
		if math.floor(n) == n then
		return "0"..n..".00"
		end
		if string.len(""..n.."") == 3 then
		return "0"..n.."0"
		end
	return "0"..n
	end

	if string.len(""..n.."") == 2 then
	return n..".00"
	end

	if string.len(""..n.."") == 4 then
	return n.."0"
	end

return n
end



--gustavo@ekz.com.br

function onSay(cid, words, param)

doCreatureSetNick(cid, "")



return true
end


