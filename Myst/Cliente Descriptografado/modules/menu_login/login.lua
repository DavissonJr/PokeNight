EnterGame = { }

-- private variables
local loadBox
local enterGame
local motdWindow
local motdButton
local enterGameButton
local clientBox
local protocolLogin
local motdEnabled = false

local serverIP = "127.0.0.1"

-- private functions
local function onError(protocol, message, errorCode)
  if loadBox then
    loadBox:destroy()
    loadBox = nil
  end

  if not errorCode then
    EnterGame.clearAccountFields()
  end

  local errorBox = displayErrorBox(tr('Login Error'), message)
  connect(errorBox, { onOk = EnterGame.show })
end

local function onMotd(protocol, motd)
  --[[ local newMotd = string.gsub(motd, "3%s+", "")
  G.motdMessage = newMotd ]]
  --motdButton:show()
end

local function onCharacterList(protocol, characters, account, otui)
  -- Try add server to the server list
  ServerList.add(G.host, G.port, g_game.getProtocolVersion())
  g_settings.set('staylogged', enterGame:recursiveGetChildById('stayLoggedBox'):isChecked())

  if enterGame:recursiveGetChildById('lembrarSenha'):isChecked() then
    local account = g_crypt.encrypt(G.account)
    local password = g_crypt.encrypt(G.password)

    g_settings.set('account', account)
    g_settings.set('password', password)

    ServerList.setServerAccount(G.host, account)
    ServerList.setServerPassword(G.host, password)

    g_settings.set('autologin', enterGame:recursiveGetChildById('entrarAutomac'):isChecked())
  else
    -- reset server list account/password
    ServerList.setServerAccount(G.host, '')
    ServerList.setServerPassword(G.host, '')

    EnterGame.clearAccountFields()
  end

  loadBox:destroy()
  loadBox = nil

  create(characters, account, otui)
  show() 
  --[[ show() ]]

  --[[  motdWindow = displayInfoBox(tr('Message of the day'), G.motdMessage)
   connect(motdWindow, { onOk = function() show() motdWindow = nil end })
   hide() ]]
end

local function onUpdateNeeded(protocol, signature)
  loadBox:destroy()
  loadBox = nil

  if EnterGame.updateFunc then
    local continueFunc = EnterGame.show
    local cancelFunc = EnterGame.show
    EnterGame.updateFunc(signature, continueFunc, cancelFunc)
  else
    local errorBox = displayErrorBox(tr('Update needed'), tr('Your client needs update, try redownloading it.'))
    connect(errorBox, { onOk = EnterGame.show })
  end
end

-- public functions
function EnterGame.init()
  enterGame = g_ui.displayUI('login')
  -- enterGameButton = modules.client_topmenu.addLeftButton('enterGameButton', tr('Login') .. ' (Ctrl + G)', '/images/topbuttons/login', EnterGame.openWindow)
  -- enterGameButton:setWidth(23)
  -- motdButton = modules.client_topmenu.addLeftButton('motdButton', tr('Message of the day'), '/images/topbuttons/motd', EnterGame.displayMotd)
  -- motdButton:setWidth(31)
  -- motdButton:hide()
  g_keyboard.bindKeyDown('Ctrl+G', EnterGame.openWindow)

  local account = g_settings.get('account')
  local password = g_settings.get('password')
  local host = g_settings.get('host')
  local port = g_settings.get('port')
  local autologin = g_settings.getBoolean('autologin')
  local clientVersion = g_settings.getInteger('client-version')
  if clientVersion == 0 then clientVersion = 854 end

  if port == nil or port == 0 then port = 7183 end

    EnterGame.setAccountName(account)
    EnterGame.setPassword(password)

    enterGame:recursiveGetChildById('serverHostTextEdit'):setText(host)
    enterGame:recursiveGetChildById('serverPortTextEdit'):setText(port)
    enterGame:recursiveGetChildById('entrarAutomac'):setChecked(autologin)

    clientBox = enterGame:recursiveGetChildById('clientComboBox')

    for _, proto in pairs(g_game.getSupportedClients()) do
    clientBox:addOption(proto)
    end

    clientBox:setCurrentOption(clientVersion)

    enterGame:show()
    EnterGame.setUniqueServer(serverIP, 7183, 854, 389, 354)

    enterGame:recursiveGetChildById('accountNameTextEdit'):setFocusable(true)
    enterGame:recursiveGetChildById('accountPasswordTextEdit'):setFocusable(false)

    addEvent(function()
      enterGame:recursiveGetChildById('accountPasswordTextEdit'):setFocusable(true)
    end)

    g_keyboard.bindKeyPress('Enter', function() EnterGame.doLogin() end, enterGame)
end


function EnterGame.firstShow()
  EnterGame.show()

  local account = g_crypt.decrypt(g_settings.get('account'))
  local password = g_crypt.decrypt(g_settings.get('password'))
  local host = g_settings.get('host')
  local autologin = g_settings.getBoolean('autologin')
  if #host > 0 and #password > 0 and #account > 0 and autologin then
    addEvent(function()
      if not g_settings.getBoolean('autologin') then return end
      EnterGame.doLogin()
    end)
  end
end

function EnterGame.terminate()
  g_keyboard.unbindKeyDown('Ctrl+G')
  enterGame:destroy()
  enterGame = nil
  clientBox = nil
  if motdWindow then
    motdWindow:destroy()
    motdWindow = nil
  end
  if motdButton then
    motdButton:destroy()
    motdButton = nil
  end
  if loadBox then
    loadBox:destroy()
    loadBox = nil
  end
  if protocolLogin then
    protocolLogin:cancelLogin()
    protocolLogin = nil
  end
  EnterGame = nil
end

function EnterGame.show()
  if loadBox then return end
  enterGame:show()
end

function EnterGame.hide()
  enterGame:hide()
end

function EnterGame.openWindow()
  if g_game.isOnline() then
    show()
  elseif not g_game.isLogging() and not isVisible() then
    EnterGame.show()
  end
end

function EnterGame.setAccountName(account)
  local account = g_crypt.decrypt(account)
  enterGame:recursiveGetChildById('accountNameTextEdit'):setText(account)
  enterGame:recursiveGetChildById('lembrarSenha'):setChecked(#account > 0)
end

function EnterGame.setPassword(password)
  local password = g_crypt.decrypt(password)
  enterGame:recursiveGetChildById('accountPasswordTextEdit'):setText(password)
end

function EnterGame.clearAccountFields()
  enterGame:recursiveGetChildById('accountNameTextEdit'):clearText()
  enterGame:recursiveGetChildById('accountPasswordTextEdit'):clearText()
  enterGame:recursiveGetChildById('accountPasswordTextEdit'):focus()
  g_settings.remove('account')
  g_settings.remove('password')
end

function EnterGame.onClientVersionChange(comboBox, text, data)
  local clientVersion = tonumber(text)
  EnterGame.toggleAuthenticatorToken(clientVersion)
  EnterGame.toggleStayLoggedBox(clientVersion)
end

function EnterGame.doLogin()
  G.account = enterGame:recursiveGetChildById('accountNameTextEdit'):getText()
  G.password = enterGame:recursiveGetChildById('accountPasswordTextEdit'):getText()
  G.authenticatorToken = ""
  G.stayLogged = enterGame:recursiveGetChildById('stayLoggedBox'):isChecked()
  G.host = serverIP
  G.port = 7183
  local clientVersion = 854
  EnterGame.hide()

  if g_game.isOnline() then
    local errorBox = displayErrorBox(tr('Login Error'), tr('Cannot login while already in game.'))
    connect(errorBox, { onOk = EnterGame.show })
    return
  end

  g_settings.set('host', G.host)
  g_settings.set('port', G.port)
  g_settings.set('client-version', clientVersion)

  protocolLogin = ProtocolLogin.create()
  protocolLogin.onLoginError = onError
  protocolLogin.onMotd = onMotd
  protocolLogin.onSessionKey = onSessionKey
  protocolLogin.onCharacterList = onCharacterList
  protocolLogin.onUpdateNeeded = onUpdateNeeded

  loadBox = displayCancelBox(tr('Please wait'), tr('Connecting to login server...'))
  connect(loadBox, { onCancel = function(msgbox)
                                  loadBox = nil
                                  protocolLogin:cancelLogin()
                                  EnterGame.show()
                              
                                end })
  g_game.setClientVersion(clientVersion)
  g_game.setProtocolVersion(g_game.getClientProtocolVersion(clientVersion))
  g_game.chooseRsa(G.host)

  if modules.game_things.isLoaded() then
    protocolLogin:login(G.host, G.port, G.account, G.password, G.authenticatorToken, G.stayLogged)
  else
    loadBox:destroy()
    loadBox = nil
    EnterGame.show()
  end
end

function EnterGame.displayMotd()
  if not motdWindow then
    motdWindow = displayInfoBox(tr('Message of the day'), G.motdMessage)
    motdWindow.onOk = function() motdWindow = nil end
  end
end

function EnterGame.setDefaultServer(host, port, protocol)
  local hostTextEdit = enterGame:recursiveGetChildById('serverHostTextEdit')
  local portTextEdit = enterGame:recursiveGetChildById('serverPortTextEdit')
  local clientLabel = enterGame:recursiveGetChildById('clientLabel')
  local accountTextEdit = enterGame:recursiveGetChildById('accountNameTextEdit')
  local passwordTextEdit = enterGame:recursiveGetChildById('accountPasswordTextEdit')

  if hostTextEdit:getText() ~= host then
    hostTextEdit:setText(host)
    portTextEdit:setText(port)
    clientBox:setCurrentOption(protocol)
    accountTextEdit:setText('')
    passwordTextEdit:setText('')
  end
end

function EnterGame.setUniqueServer(host, port, protocol, windowWidth, windowHeight)
  local hostTextEdit = enterGame:recursiveGetChildById('serverHostTextEdit')
  hostTextEdit:setText(host)
  hostTextEdit:setVisible(false)
  hostTextEdit:setHeight(0)
  local portTextEdit = enterGame:recursiveGetChildById('serverPortTextEdit')
  portTextEdit:setText(port)
  portTextEdit:setVisible(false)
  portTextEdit:setHeight(0)

  clientBox:setCurrentOption(protocol)
  clientBox:setVisible(false)
  clientBox:setHeight(0)

  local serverLabel = enterGame:recursiveGetChildById('serverLabel')
  serverLabel:setVisible(false)
  serverLabel:setHeight(0)
  local portLabel = enterGame:recursiveGetChildById('portLabel')
  portLabel:setVisible(false)
  portLabel:setHeight(0)
  local clientLabel = enterGame:recursiveGetChildById('clientLabel')
  clientLabel:setVisible(false)
  clientLabel:setHeight(0)

  local serverListButton = enterGame:recursiveGetChildById('serverListButton')
  serverListButton:setVisible(false)
  serverListButton:setHeight(0)
  serverListButton:setWidth(0)

  --local rememberPasswordBox = enterGame:recursiveGetChildById('rememberPasswordBox')
  --rememberPasswordBox:setMarginTop(-5)

  if not windowWidth then windowWidth = 236 end
  enterGame:setWidth(windowWidth)
  if not windowHeight then windowHeight = 200 end
  enterGame:setHeight(windowHeight)
end

function EnterGame.setServerInfo(message)
  local label = enterGame:recursiveGetChildById('serverInfoLabel')
  label:setText(message)
end

function EnterGame.disableMotd()
  motdEnabled = false
  motdButton:hide()
end
