function getmytempo(number)
local s = number
local m = 0
local h = 0

for a = 1, math.floor(number/60) do
    if s <= 59 then
       return {h = h, m = m, s = s}
    else
       s = s - 60
       m = m + 1
	   if m >= 60 then
          m = 0
		  h = h + 1
       end
	end
end
return {h = h, m = m, s = s}
end

function getStringmytempo(number)
local hour = ""
local minu = ""
local seco = ""
	if getmytempo(number).h <= 9 then
	hour = "0"..getmytempo(number).h..""
	else
	hour = ""..getmytempo(number).h..""
	end
	if getmytempo(number).m <= 9 then
	minu = "0"..getmytempo(number).m..""
	else
	minu = ""..getmytempo(number).m..""
	end
 	if getmytempo(number).s <= 9 then
	seco = "0"..getmytempo(number).s..""
	else
	seco = ""..getmytempo(number).s..""
	end
return ""..hour..":"..minu..":"..seco..""
end

ballcooldown = 
{

	check = function (cid, megafuckie)
        if tonumber(getItemAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."")) == nil then
	    return false
	    end

	    if tonumber(getItemAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."")) >= os.time(t) then
	    return true
	    end

	    return false
	end,

	get = function (cid, megafuckie)
	    if getItemAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."") == nil then
		return ""
		end
		local mytempo = math.ceil(getItemAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."") - os.time(t))
		local x = getStringmytempo(mytempo)
		return x
	end,

	numberget = function (cid, megafuckie)
		if getItemAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."") == nil then
		return 0
		end
		local x = math.ceil(getItemAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."") - os.time(t))
		return x
	end,

	set = function (cid, megafuckie, mytempo)
        doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."", os.time(t) + mytempo)
    end,

	clean = function (cid, megafuckie)
		doItemSetAttribute(getPlayerSlotItem(cid, 8).uid, ""..megafuckie.."", 0)
	end
}


exhaustion = 
{

	check = function (cid, storage)
          if(getPlayerFlagValue(cid, PLAYERFLAG_HASNOEXHAUSTION)) then
             return false
          end
          return getPlayerStorageValue(cid, storage) >= os.time(t)
	end,

	get = function (cid, storage)
        if isPlayer(cid) then
           if(getPlayerFlagValue(cid, PLAYERFLAG_HASNOEXHAUSTION)) then
              return false
		   end
        end
                return false
	end,

	set = function (cid, storage, mytempo)
       setPlayerStorageValue(cid, storage, os.time(t) + mytempo)
    end,

	make = function (cid, storage, mytempo)
       local exhaust = exhaustion.get(cid, storage)
       if(not exhaust) then
          exhaustion.set(cid, storage, mytempo)
          return true
       end
       return false
    end
}