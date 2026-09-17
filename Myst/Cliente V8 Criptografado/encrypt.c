--[[Instructions to use windows version]]--

-- [0] Check if the correct OS is selected
-- [1] Execute lua53.exe
-- [2] Run the following command => local func = loadfile("encrypt.c") func()
-- [3] Insert the key you want to use to encrypt data and the other information that are asked
-- [4] Confirm your choices

--[[Instructions to use windows version]]--

--[[Instructions to use linux version]]--

-- [0] Check if the correct OS is selected
-- [1] Run the following command => local func = loadfile("encrypt.c") func(), using lua from the OS [normally can be found at "/opt/lua/bin/lua"]
-- [2] Insert the key you want to use to encrypt data and the other information that are asked
-- [3] Confirm your choices

--[[Instructions to use linux version]]--

local OS = "windows" -- [windows/linux/macos]

local encryptionOrder = {
  "lua",
  "otui",
  "otmod",
  "otml",
  "otfont",
  "otps",
  "png",
  "PNG",
  "dat"
}

local commandsTable = {
  ["lua"] = {macos = "find . -iname '*.lua' -type f", linux = "find . -iname '*.lua' -type f", windows = "dir *.lua /s /b"},
  ["otui"] = {macos = "find . -iname '*.otui' -type f", linux = "find . -iname '*.otui' -type f", windows = "dir *.otui /s /b"},
  ["otmod"] = {macos = "find . -iname '*.otmod' -type f", linux = "find . -iname '*.otmod' -type f", windows = "dir *.otmod /s /b"},
  ["otml"] = {macos = "find . -iname '*.otml' -type f", linux = "find . -iname '*.otml' -type f", windows = "dir *.otml /s /b"},
  ["otfont"] = {macos = "find . -iname '*.otfont' -type f", linux = "find . -iname '*.otfont' -type f", windows = "dir *.otfont /s /b"},
  ["otps"] = {macos = "find . -iname '*.otps' -type f", linux = "find . -iname '*.otps' -type f", windows = "dir *.otps /s /b"},
  ["png"] = {macos = "find . -iname '*.png' -type f", linux = "find . -iname '*.png' -type f", windows = "dir *.png /s /b", numericProtection = true, showPercent = true},
  ["PNG"] = {macos = "find . -iname '*.PNG' -type f", linux = "find . -iname '*.PNG' -type f", windows = "dir *.PNG /s /b", numericProtection = true, showPercent = true},
  ["dat"] = {macos = "find . -iname '*.dat' -type f", linux = "find . -iname '*.dat' -type f", windows = "dir *.dat /s /b", numericProtection = true, showPercent = true},
}




































































print("Insert the key you want to use to encrypt your client:")

local stringKey = io.read()

function xor(a,b)
  local r = 0
  local f = math.floor
  for i = 0, 31 do
    local x = a / 2 + b / 2
    if x ~= f(x) then
      r = r + 2^i
    end
    a = f(a / 2)
    b = f(b / 2)
  end
  return r
end

local key = {}

for i=1, string.len(stringKey) do
  key[i] = string.sub(stringKey, i, i)
end

local ekey = {}

for i=1, string.len(stringKey) do
  ekey[i] = string.sub(stringKey, i, i)
end

for i=1, string.len(stringKey) do
  ekey[i] = string.char( xor( string.byte(ekey[i]), string.byte(key[ ( string.len(stringKey)-(i-1) ) ]) ) )
end

local ekeystring = ""

for i=1, string.len(stringKey) do
  ekeystring = ekeystring..ekey[i]
end

print("\nYour security key is: ")
print(">> "..ekeystring..".")

local ekeystringbytes = ">>> "
for i=1, string.len(stringKey) do
  ekeystringbytes = ekeystringbytes..string.byte(ekey[i]).."&"
end

print(ekeystringbytes)

print("\nDo you want to encrypt your client using this security key ? [Y/N]")

local answer = io.read()
if string.lower(answer) == "n" then
  local repeatFunc = loadfile("w_encrypt.c")
  return repeatFunc()
end

print("Now, insert the first numeric key [1-255]:")

local numericKeys = {}

numericKeys[1] = tonumber(io.read())

if not numericKeys[1] or numericKeys[1] < 1 or numericKeys[1] > 255 then
  print("Sorry, the key you entered is not available in the range of 1 to 255.")

  local repeatFunc = loadfile("w_encrypt.c")
  return repeatFunc()
end

print("Now, insert the second numeric key [0-"..(numericKeys[1]-1).."]:")
numericKeys[2] = tonumber(io.read())

if not numericKeys[2] or numericKeys[2] < 0 or numericKeys[2] > numericKeys[1] then
  print("Sorry, the key you entered is not available in the range of 1 to "..numericKeys[1]..".")

  local repeatFunc = loadfile("w_encrypt.c")
  return repeatFunc()
end

print("Now, insert the third numeric key [1-255]:")
numericKeys[3] = tonumber(io.read())

if not numericKeys[3] or numericKeys[3] < 1 or numericKeys[1] > 255 then
  print("Sorry, the key you entered is not available in the range of 1 to 255.")

  local repeatFunc = loadfile("w_encrypt.c")
  return repeatFunc()
end

print("\nThis was your choices:")
print("[0] = "..stringKey..",")
print("[1] = "..numericKeys[1]..",")
print("[2] = "..numericKeys[2]..",")
print("[3] = "..numericKeys[3].."")
print("Can I start encrypting your files ? [Y/N]")

local answer = io.read()
if string.lower(answer) == "n" then
  local repeatFunc = loadfile("w_encrypt.c")
  return repeatFunc()
end

print("\n\nStarting to encrypt your data:")


local initTime = os.time()

local pwd = ""

if OS == "windows" then
  for path in io.popen("echo %cd%"):lines() do
    pwd = path
  end
  
  print("Current path: "..pwd)
end

local pwdSize = string.len(pwd)

for index, fileType in ipairs(encryptionOrder) do
  for fileName in io.popen(commandsTable[fileType][OS]):lines() do
    local fileNameConverted

    if OS == "windows" then
      fileNameConverted = string.sub(fileName, pwdSize+2)
    else
      fileNameConverted = fileName
    end

    if fileNameConverted:find("."..fileType) then
      print('['..fileNameConverted..']')
      print('>> Reading...')
      local file = io.open(fileNameConverted, 'rb')
      assert(file, 'Could not read file `' .. fileNameConverted .. '`')
      local buffer = file:read('*all')
      file:close()

      print('>> Processing... '..( string.len(buffer) )..'bytes')

      local newBufferTable = {}
      for i = 1, string.len(buffer) do
        local byte1 = string.byte( string.sub(buffer, i, i) )
        local byte2 = string.byte(ekey[math.fmod(i-1,#ekey)+1])

        if not commandsTable[fileType].numericProtection or math.fmod(i, numericKeys[1]) ~= numericKeys[2] then
          newBufferTable[#newBufferTable+1] = string.char(xor(byte1, byte2) )
        else
          newBufferTable[#newBufferTable+1] = string.char( xor(byte1, string.byte( string.char(numericKeys[3]) ) ) )
        end

        if commandsTable[fileType].showPercent and (math.fmod(i, 10000) == 0) then
          print("["..i.."/"..string.len(buffer).."] ".. (i/(string.len(buffer))*100) .."%")
        end
      end

      local newBuffer = table.concat( newBufferTable )

      print('>> Writing...')
      local file = io.open(fileNameConverted, 'w+')
      file:close()

      local file = io.open(fileNameConverted, 'wb')
      file:write(newBuffer)
      file:close()

      print(">> OK\n")
    end
  end
end

local finishTime = os.time()-initTime

print('> All the files was encrypted in '.. math.floor(finishTime/60) ..' minutes and '.. math.fmod(finishTime, 60) ..' seconds.')
print('Done !')
