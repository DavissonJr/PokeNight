-- ---------------------------------------------------------------------------
-- Criacao de conta e personagem pelo cliente (PokeOrigin).
--
-- Conversa com a API em PKO_API via g_http, que ja existe no cliente
-- (framework/net/protocolhttp.cpp) -- nao precisa recompilar nada.
--
-- O fluxo e unico, como no PXG: cria a conta e cai direto na escolha do
-- personagem; ao terminar, preenche o login e entra sozinho.
--
-- Este arquivo estende a tabela EnterGame definida em login.lua, entao
-- precisa ser carregado DEPOIS dele (ver login.otmod).
-- ---------------------------------------------------------------------------

PKO_API = 'http://127.0.0.1:8088/'

-- Guarda o que foi cadastrado na etapa 1 para reutilizar na etapa 2 e no
-- login automatico do final.
local pending = { account = nil, password = nil, sex = 'male' }

-- Evita disparar uma consulta de disponibilidade a cada tecla digitada.
local checkEvent = { account = nil, character = nil }

local COLOR_DIM  = '#8a8a92'
local COLOR_OK   = '#4ade80'
local COLOR_ERR  = '#ff6b6b'
local COLOR_WARN = '#ff7a18'

-- login.lua declara `local enterGame`, que nao atravessa o dofile. Por isso
-- localizamos a janela pelo root do UI em vez de depender daquele local --
-- caso contrario todo widget() volta nil e a tela falha em silencio.
local rootWindow = nil

local function window()
  if rootWindow and not rootWindow:isDestroyed() then
    return rootWindow
  end
  rootWindow = g_ui.getRootWidget():recursiveGetChildById('enterGame')
  return rootWindow
end

local function widget(id)
  local w = window()
  if not w then return nil end
  return w:recursiveGetChildById(id)
end

local function say(id, text, color)
  local w = widget(id)
  if not w then return end
  w:setText(text or '')
  w:setColor(color or COLOR_DIM)
end

--- Envia JSON e devolve a resposta ja decodificada.
-- Usa HTTP.postJSON do corelib, que faz encode na ida, decode na volta e
-- chama callback(data, err). Qualquer erro de rede ou corpo invalido vira
-- mensagem tratada, para a tela nunca travar.
local function apiPost(route, body, onDone)
  HTTP.postJSON(PKO_API .. '?r=' .. route, body, function(data, err)
    if err and err ~= '' then
      return onDone(nil, 'Nao foi possivel falar com o servidor.')
    end
    if type(data) ~= 'table' then
      return onDone(nil, 'Resposta invalida do servidor.')
    end
    onDone(data, nil)
  end)
end

local function apiGet(route, onDone)
  HTTP.getJSON(PKO_API .. '?r=' .. route, function(data, err)
    if (err and err ~= '') or type(data) ~= 'table' then
      return onDone(nil)
    end
    onDone(data)
  end)
end

-- ---------------------------------------------------------------------------
-- Abas
-- ---------------------------------------------------------------------------
function EnterGame.switchTab(which)
  local isLogin = (which == 'login')
  local tl, tr = widget('tabLogin'), widget('tabRegister')
  if tl then tl:setChecked(isLogin) end
  if tr then tr:setChecked(not isLogin) end

  local lp, rp = widget('loginPanel'), widget('registerPanel')
  if lp then lp:setVisible(isLogin) end
  if rp then rp:setVisible(not isLogin) end
end

function EnterGame.backToStep1()
  local s1, s2 = widget('step1'), widget('step2')
  if s1 then s1:setVisible(true) end
  if s2 then s2:setVisible(false) end
end

-- ---------------------------------------------------------------------------
-- Disponibilidade em tempo real
-- ---------------------------------------------------------------------------
local function scheduleCheck(kind, name, statusId, minLen, label)
  if checkEvent[kind] then
    removeEvent(checkEvent[kind])
    checkEvent[kind] = nil
  end
  if #name == 0 then
    return say(statusId, '')
  end
  if #name < minLen then
    return say(statusId, label .. ' precisa de pelo menos ' .. minLen .. ' caracteres.', COLOR_DIM)
  end

  say(statusId, 'verificando...', COLOR_DIM)
  checkEvent[kind] = scheduleEvent(function()
    checkEvent[kind] = nil
    local route = (kind == 'account') and 'check-account' or 'check-character'
    apiGet(route .. '&name=' .. name:gsub(' ', '%%20'), function(res)
      if not res or not res.ok then
        return say(statusId, 'Nao foi possivel verificar agora.', COLOR_WARN)
      end
      if res.available then
        say(statusId, label .. ' disponivel.', COLOR_OK)
      else
        say(statusId, label .. ' ja esta em uso.', COLOR_ERR)
      end
    end)
  end, 450)
end

function EnterGame.onRegAccountChange()
  local w = widget('regAccount')
  if not w then return end
  scheduleCheck('account', w:getText(), 'regStatus', 4, 'Esse nome de conta')
end

function EnterGame.onCharNameChange()
  local w = widget('charName')
  if not w then return end
  scheduleCheck('character', w:getText(), 'charStatus', 3, 'Esse nome')
end

-- ---------------------------------------------------------------------------
-- Aparencia
-- ---------------------------------------------------------------------------
function EnterGame.setSex(sex)
  pending.sex = sex
  local m, f = widget('sexMale'), widget('sexFemale')
  if m then m:setColor(sex == 'male' and COLOR_WARN or '#f5f5f6') end
  if f then f:setColor(sex == 'female' and COLOR_WARN or '#f5f5f6') end
end

-- ---------------------------------------------------------------------------
-- Etapa 1: criar a conta
-- ---------------------------------------------------------------------------
function EnterGame.doRegisterStep1()
  local acc   = widget('regAccount'):getText()
  local pass  = widget('regPassword'):getText()
  local pass2 = widget('regPassword2'):getText()
  local email = widget('regEmail'):getText()

  if #acc < 4 then
    return say('regStatus', 'O nome da conta precisa de pelo menos 4 caracteres.', COLOR_ERR)
  end
  if #pass < 6 then
    return say('regStatus', 'A senha precisa de pelo menos 6 caracteres.', COLOR_ERR)
  end
  if pass ~= pass2 then
    return say('regStatus', 'As senhas nao sao iguais.', COLOR_ERR)
  end

  local btn = widget('btnRegNext')
  if btn then btn:setEnabled(false) end
  say('regStatus', 'Criando sua conta...', COLOR_DIM)

  apiPost('register', { name = acc, password = pass, email = email }, function(res, err)
    if btn then btn:setEnabled(true) end
    if err then
      return say('regStatus', err, COLOR_ERR)
    end
    if not res.ok then
      return say('regStatus', res.error or 'Nao foi possivel criar a conta.', COLOR_ERR)
    end

    pending.account  = acc
    pending.password = pass
    say('regStatus', '')

    widget('step1'):setVisible(false)
    widget('step2'):setVisible(true)
    EnterGame.setSex('male')
    widget('charName'):focus()
  end)
end

-- ---------------------------------------------------------------------------
-- Etapa 2: criar o personagem e entrar
-- ---------------------------------------------------------------------------
function EnterGame.doCreateCharacter()
  local name = widget('charName'):getText()
  if #name < 3 then
    return say('charStatus', 'O nome precisa de pelo menos 3 caracteres.', COLOR_ERR)
  end

  local btn = widget('btnCharCreate')
  if btn then btn:setEnabled(false) end
  say('charStatus', 'Criando seu personagem...', COLOR_DIM)

  apiPost('create-character', {
    account  = pending.account,
    password = pending.password,
    name     = name,
    sex      = pending.sex,
  }, function(res, err)
    if btn then btn:setEnabled(true) end
    if err then
      return say('charStatus', err, COLOR_ERR)
    end
    if not res.ok then
      return say('charStatus', res.error or 'Nao foi possivel criar o personagem.', COLOR_ERR)
    end

    -- Tudo pronto: leva os dados para a aba de login e entra.
    say('charStatus', 'Pronto! Entrando...', COLOR_OK)
    widget('accountNameTextEdit'):setText(pending.account)
    widget('accountPasswordTextEdit'):setText(pending.password)
    EnterGame.switchTab('login')
    scheduleEvent(function() EnterGame.doLogin() end, 400)
  end)
end

-- ---------------------------------------------------------------------------
-- Contador de jogadores online no painel da marca
-- ---------------------------------------------------------------------------
function EnterGame.refreshOnline()
  apiGet('status', function(res)
    if not res or not res.ok then
      return say('onlineCount', 'servidor offline', COLOR_ERR)
    end
    local n = tonumber(res.online) or 0
    say('onlineCount', n == 1 and '1 jogador online' or (n .. ' jogadores online'), COLOR_WARN)
  end)
end
