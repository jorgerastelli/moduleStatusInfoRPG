OPCODE_API_INTERFACE = 30
---------------------------------------------------------------
-- VARIÁVEIS DO MÓDULO
---------------------------------------------------------------
local statusInfoWindow = nil
local statusInfoButton = nil
local totalStats = {}

---------------------------------------------------------------
-- INIT
---------------------------------------------------------------
function init()
    -- Carrega o UI
    statusInfoWindow = g_ui.displayUI('statusInfoRPG.otui')
    if not statusInfoWindow then
        perror("[statusInfoRPG] Falha ao carregar statusInfoRPG.otui")
        return
    end

    statusInfoWindow:hide()

    -- Botão no topo para abrir/fechar
    statusInfoButton = modules.client_topmenu.addRightGameToggleButton(
        'statusInfoRPGButton',
        "Status Info RPG",
        'icon',
        toggleWindow,
        true
    )


    print("[statusInfoRPG] Loaded successfully, e Thanatos melhor PET! ")
    connect(ProtocolGame, { onExtendedOpcode = onExtendedOpcode }, true)
end

---------------------------------------------------------------
-- TERMINATE
---------------------------------------------------------------
function terminate()
    if statusInfoButton then
        statusInfoButton:destroy()
        statusInfoButton = nil
    end

    if statusInfoWindow then
        statusInfoWindow:destroy()
        statusInfoWindow = nil
    end
    disconnect(ProtocolGame, { onExtendedOpcode = onExtendedOpcode })
end

---------------------------------------------------------------
-- TOGGLE WINDOW
---------------------------------------------------------------
function toggleWindow()
    if not statusInfoWindow then return end

    if statusInfoWindow:isVisible() then
        statusInfoWindow:hide()
    else
        g_game.getProtocolGame():sendExtendedOpcode(OPCODE_API_INTERFACE, "ModuleStatusInfoRPG;PLAYER-STATS")

    end
end

function onExtendedOpcode(protocol, opcode, buffer)
    if opcode == OPCODE_API_INTERFACE then
        local params = string.explode(buffer, ";", 1)
        local paramType = params[1]
        local paramValue = params[2]

        if paramType == "PLAYER-STATS-RESPONSE" then
            statusInfoWindow:show()
            statusInfoWindow:raise()
            statusInfoWindow:focus()
            local response = loadstring("return " .. paramValue)()
            local stats = response.refineSystem.attributes

            -- Chamar função pra ler e escrever as labels
            updateStatusModule(stats)
        end
    end
end

---------------------------------------------------------------
-- ATUALIZA GUI 
---------------------------------------------------------------
function updateStatusModule(stats)
    if not statusInfoWindow then
        print("[statusInfoRPG] statusInfoWindow NIL ao atualizar GUI!")
        return
    end

    -- Função auxiliar para atualizar a label
    local function setLabel(id, value, suffix)
        local lbl = statusInfoWindow:recursiveGetChildById(id)
        if lbl then
            suffix = suffix or ""
            -- Pega o texto original da label até ": " para manter o prefixo
            local baseText = lbl:getText():match("^[^:]+:%s*") or ""
            lbl:setText(baseText .. tostring(value) .. suffix)
        else
            print("[statusInfoRPG] Label '" .. id .. "' não encontrada ao atualizar!")
        end
    end

    -- Status básicos
    setLabel("trpgb_stat_health", stats.trpgb_stat_health)
    setLabel("trpgb_stat_healthpercent", stats.trpgb_stat_healthpercent, "%")
    setLabel("trpgb_stat_manapercent", stats.trpgb_stat_manapercent, "%")
    setLabel("trpgb_stat_mana", stats.trpgb_stat_mana)
    setLabel("trpgb_armor", stats.trpgb_armor)
    setLabel("trpgb_stat_magiclevel", stats.trpgb_stat_magiclevel)
    setLabel("trpgb_attack", stats.trpgb_attack)
    setLabel("trpgb_defense", stats.trpgb_defense)


    -- Skills
    setLabel("trpgb_skill_fist", stats.trpgb_skill_fist)
    setLabel("trpgb_skill_sword", stats.trpgb_skill_sword)
    setLabel("trpgb_skill_axe", stats.trpgb_skill_axe)
    setLabel("trpgb_skill_club", stats.trpgb_skill_club)
    setLabel("trpgb_skill_distance", stats.trpgb_skill_distance)
    setLabel("trpgb_skill_shield", stats.trpgb_skill_shield)
    setLabel("trpgb_skill_meleepercent", stats.trpgb_skill_meleepercent)
    setLabel("trpgb_skill_distancepercent", stats.trpgb_skill_distancepercent)

    -- Outros
    setLabel("trpgb_sockets", stats.trpgb_sockets)
    setLabel("trpgb_healthgain", stats.trpgb_healthgain)
    setLabel("trpgb_managain", stats.trpgb_managain)
end

