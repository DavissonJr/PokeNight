table.find = function (table, value)
  for i, v in pairs(table) do
	if(v == value) then
	  return i
    end
  end
  return nil
end

table.contains = function (txt, str)
	for i, v in pairs(str) do
		if(txt:find(v) and not txt:find('(%w+)' .. v) and not txt:find(v .. '(%w+)')) then
			return true
		end
	end

	return false
end
table.isStrIn = table.contains

table.serialize = function(x, recur)
  local t = type(x)
  recur = recur or {}

  if t == nil then
    return "nil"
  elseif t == "string" then
	return string.format("%q", x)
  elseif t == "number" then
	return tostring(x)
  elseif t == "boolean" then
	return t and "true" or "false"
  elseif getmetatable(x) then
	error("Can not serialize a table that has a metatable associated with it.")
  elseif t == "table" then
    if(table.find(recur, x)) then
	  error("Can not serialize recursive tables.")
	end
	table.insert(recur, x)

	local s = "{"
	for k, v in pairs(x) do
	  s = s .. "[" .. table.serialize(k, recur) .. "]"
	  s = s .. " = " .. table.serialize(v, recur) .. ","
	end
	s = s .. "}"
	return s
  else
	error("Can not serialize value of type '" .. t .. "'.")
  end
end