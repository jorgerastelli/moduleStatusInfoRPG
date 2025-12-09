local REQUESTER_NAME = "ModuleStatusInfoRPG"
local OPCODE_API_INTERFACE = 30

local statusInfoWindow = nil
local statusInfoButton = nil

-- Guarda prefixos originais (ex: "Fist: ")
local labelPrefixes = {}

---------------------------------------------------------------
-- UTIL
---------------------------------------------------------------
local function getLabel(id)
    if not statusInfoWindow then return nil end
    return statusInfoWindow:getChildById(id)
end

-- Define valor na label (valor padrão = 0)
local function setStatValue(id, value)
    local label = getLabel(id)
    if not label then return end

    -- Converter para número → se falhar vira 0
    value = tonumber(value) or 0

    -- Guardar prefixo uma única vez
    if not labelPrefixes[id] then
        labelPrefixes[id] = label:getText()
    end

    -- Atualizar texto
    label:setText(labelPrefixes[id] .. value)
end

-- Preenche todas as labels com valor 0 ao abrir a janela
local function fillAllStatsWithZero()
    if not statusInfoWindow then return end

    for _, widget in pairs(statusInfoWindow:getChildren()) do
        if widget:getClassName() == "UILabel" and widget:getId() ~= "" then
            local id = widget:getId()

            -- Guarda prefixo se ainda não tiver salvo
            if not labelPrefixes[id] then
                labelPrefixes[id] = widget:getText()
            end

            -- Coloca zero
            widget:setText(labelPrefixes[id] .. "0")
        end
    end
end

---------------------------------------------------------------
-- INIT
---------------------------------------------------------------
function init()
    statusInfoWindow = g_ui.displayUI('statusInfoRPG.otui')
    if not statusInfoWindow then
        perror("[statusInfoRPG] Falha ao carregar statusInfoRPG.otui")
        return
    end

    statusInfoWindow:hide()

    statusInfoButton = modules.client_topmenu.addRightGameToggleButton(
        'statusInfoRPGButton',
        "Status Info RPG",
        '/mods/statusInfoRPG/statusModIcon',
        toggleWindow,
        true
    )

    connect(ProtocolGame, { onExtendedOpcode = onExtendedOpcode }, true)
end

function terminate()
    if statusInfoButton then statusInfoButton:destroy() end
    if statusInfoWindow then statusInfoWindow:destroy() end
    disconnect(ProtocolGame, { onExtendedOpcode = onExtendedOpcode })
end

---------------------------------------------------------------
-- TOGGLE WINDOW
---------------------------------------------------------------
function toggleWindow()
    if statusInfoWindow:isVisible() then
        statusInfoWindow:hide()
    else
        statusInfoWindow:show()
        statusInfoWindow:raise()
        statusInfoWindow:focus()

        -- Preenche Status com 0 

        fillAllStatsWithZero()

        -- Solicita valores reais ao servidor
        g_game.getProtocolGame():sendExtendedOpcode(
            OPCODE_API_INTERFACE,
            REQUESTER_NAME .. ";PLAYER-STATS"
        )
    end
end

---------------------------------------------------------------
-- RECEBENDO DO SERVIDOR
---------------------------------------------------------------
function onExtendedOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE_API_INTERFACE then return end

    local parts = string.explode(buffer, ";")
    if parts[1] ~= REQUESTER_NAME then return end

    if parts[2] == "PLAYER-STATS-RESPONSE" then
        local data = loadstring("return " .. table.concat(parts, ";", 3))()
        updateStatusModule(data.refineSystem.attributes, data.equippedItems)
    end
end

---------------------------------------------------------------
-- UPDATE DOS STATUS + IMBUEMENTS
---------------------------------------------------------------
function updateStatusModule(stats, equippedItems)

    -------------------------------------------------------------------
    -- 1. Atualizar STATS NORMAIS
    -------------------------------------------------------------------
    for key, value in pairs(stats) do
        setStatValue(key, value)
    end

    -------------------------------------------------------------------
    -- 2. Ler e somar IMBUEMENTS
    -------------------------------------------------------------------
    local imbueSum = {}

    for slot, item in pairs(equippedItems or {}) do
        if item.imbuements and item.imbuements.slot then
            for _, imb in pairs(item.imbuements.slot) do
                if imb.name and imb.name ~= "" then
                    local id = imb.name:lower():gsub("%s+", "_")
                    local val = tonumber(imb.value) or 0
                    imbueSum[id] = (imbueSum[id] or 0) + val
                end
            end
        end
    end

    -------------------------------------------------------------------
    -- 3. Aplicar IMBUEMENTS nas labels
    -------------------------------------------------------------------
    for id, value in pairs(imbueSum) do
        setStatValue(id, value)
    end
end
