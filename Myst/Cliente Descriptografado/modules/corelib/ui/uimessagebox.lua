if not UIWindow then
    dofile 'uiwindow'
end

-- @docclass
UIMessageBox = extends(UIWindow, 'UIMessageBox')

-- messagebox cannot be created from otui files
UIMessageBox.create = nil

function UIMessageBox.display(title, message, buttons, onEnterCallback, onEscapeCallback)
    local messageBox = UIMessageBox.internalCreate()
    rootWidget:addChild(messageBox)

    -- Thalles Vitor
    messageBox:setStyle('NewPopUpWindow')

    -- Thalles Vitor
    if string.find(title, "Erro de Autenticação") then
        title = string.gsub(title, "Erro de Autenticação", "Error")
    end

    if string.find(message, "Invalid account name.") then
        message = string.gsub(message, "Invalid account name.", "Nome de conta inválido.")
    end
        
    -- Thalles Vitor
    if string.find(message, "sair") then
        messageTitle = g_ui.createWidget("NewPopUpWindowTitle2", messageBox)
    elseif string.find(message, "Promoção") then
        messageTitle = g_ui.createWidget("NewPopUpWindowTitle3", messageBox)
        title = "Informação"
    else
        messageTitle = g_ui.createWidget("NewPopUpWindowTitle", messageBox)
    end

    messageTitle:setSize("140 28")
    messageTitle:setImageSource("images/titleTab.png")
    messageTitle:setText(title)
    messageTitle:setColor("#e0680f")
    messageTitle:setFont("sans-bold-16px")

    local messageLabel = g_ui.createWidget('MessageBoxLabel', messageBox)
    --[[ messageLabel:setFont("terminus-14px-bold") ]]
    messageLabel:setColor("white")
    messageLabel:setText(message)

    local buttonsWidth = 0
    local buttonsHeight = 0

    local anchor = AnchorRight
    if buttons.anchor then
        anchor = buttons.anchor
    end

    local buttonHolder = g_ui.createWidget('MessageBoxButtonHolder', messageBox)
    buttonHolder:addAnchor(anchor, 'parent', anchor)

    for i = 1, #buttons do
        local button = messageBox:addButton(buttons[i].text, buttons[i].callback)
        if i == 1 then
            button:setMarginLeft(0)
            button:addAnchor(AnchorBottom, 'parent', AnchorBottom)
            button:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            buttonsHeight = button:getHeight()
        else
            button:addAnchor(AnchorBottom, 'prev', AnchorBottom)
            button:addAnchor(AnchorLeft, 'prev', AnchorRight)
        end
        buttonsWidth = buttonsWidth + button:getWidth() + button:getMarginLeft()
    end

    buttonHolder:setWidth(buttonsWidth)
    buttonHolder:setHeight(24)

    if onEnterCallback then
        connect(messageBox, {
            onEnter = onEnterCallback
        })
    end
    if onEscapeCallback then
        connect(messageBox, {
            onEscape = onEscapeCallback
        })
    end

    messageBox:setWidth(math.max(messageLabel:getWidth(), messageBox:getTextSize().width, buttonHolder:getWidth()) +
                            messageBox:getPaddingLeft() + messageBox:getPaddingRight())
    messageBox:setHeight(messageLabel:getHeight() + messageBox:getPaddingTop() + messageBox:getPaddingBottom() +
                             buttonHolder:getHeight() + buttonHolder:getMarginTop())
    return messageBox
end

function displayInfoBox(title, message)
    local messageBox
    local defaultCallback = function()
        messageBox:ok()
    end
    messageBox = UIMessageBox.display(title, message, {{
        text = 'Ok',
        callback = defaultCallback
    }}, defaultCallback, defaultCallback)
    return messageBox
end

function displayErrorBox(title, message)
    local messageBox
    local defaultCallback = function()
        messageBox:ok()
    end
    messageBox = UIMessageBox.display(title, message, {{
        text = 'Ok',
        callback = defaultCallback
    }}, defaultCallback, defaultCallback)
    return messageBox
end

function displayCancelBox(title, message)
    local messageBox
    local defaultCallback = function()
        messageBox:cancel()
    end
    messageBox = UIMessageBox.display(title, message, {{
        text = 'Cancel',
        callback = defaultCallback
    }}, defaultCallback, defaultCallback)
    return messageBox
end

function displayGeneralBox(title, message, buttons, onEnterCallback, onEscapeCallback)
    return UIMessageBox.display(title, message, buttons, onEnterCallback, onEscapeCallback)
end

function UIMessageBox:addButton(text, callback)
    local buttonHolder = self:getChildById('buttonHolder')
    local button = g_ui.createWidget('UIButton', buttonHolder)
    button:setId("buttonHolder")
    button:setImageSource("images/button.png")
    button:setImageBorder("20")
    button:setMarginLeft(5)
    button.onHoverChange = function(self, hovered)
        if hovered then
            button:setImageSource("images/button_hover.png")
        else
            button:setImageSource("images/button.png")
        end
    end

    button:setText(text)
    connect(button, {
        onClick = callback
    })
    return button
end

function UIMessageBox:ok()
    signalcall(self.onOk, self)
    self.onOk = nil
    self:destroy()
end

function UIMessageBox:cancel()
    signalcall(self.onCancel, self)
    self.onCancel = nil
    self:destroy()
end
