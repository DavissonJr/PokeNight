-- private variables
local background
local clientVersionLabel

-- public functions
function init()
    background = g_ui.displayUI('background')
    background:lower()

    clientVersionLabel = background:getChildById('clientVersionLabel')
    clientVersionLabel:setText(g_app.getName() .. ' ' .. g_app.getVersion() .. '\n' .. 'Rev  ' ..
                                   g_app.getBuildRevision() .. ' (' .. g_app.getBuildCommit() .. ')\n' .. 'Built on ' ..
                                   g_app.getBuildDate() .. '\n' .. g_app.getBuildCompiler() .. ' - ' ..
                                   g_app.getBuildArch())

    if not g_game.isOnline() then
        addEvent(function()
            g_effects.fadeIn(clientVersionLabel, 1500)
        end)
    end

    connect(g_game, {
        onGameStart = hide
    })
    connect(g_game, {
        onGameEnd = show
    })

    addEvent(function()
        modules.client_background.getBackground():addAnchor(AnchorTop, 'parent', AnchorTop)
    end)
end

function terminate()
    disconnect(g_game, {
        onGameStart = hide
    })
    disconnect(g_game, {
        onGameEnd = show
    })

    g_effects.cancelFade(background:getChildById('clientVersionLabel'))
    background:destroy()

    background = nil
    clientVersionLabel = nil
end

function hide()
    scheduleEvent(function()
        if g_game.isOnline() then
            local player = g_game.getLocalPlayer()
            g_window.setTitle("Poke Night | " .. player:getName() .. " [" .. player:getLevel() .. "]");
        end
    end, 100)

    background:hide()
end

function show()
    g_window.setTitle("Poke Night");
    background:show()
end

function hideVersionLabel()
    background:getChildById('clientVersionLabel'):hide()
end

function setVersionText(text)
    clientVersionLabel:setText(text)
end

function getBackground()
    return background
end