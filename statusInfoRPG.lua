local REQUESTER_NAME = "ModuleStatusInfoRPG"
local OPCODE_API_INTERFACE = 30

local statusInfoWindow = nil
local statusInfoButton = nil

-- Guarda prefixos originais (ex: "Fist: ")
local labelPrefixes = {}

-- IDs que NÃO devem receber "0"
local ignoreZero = {
    basic_title = true,
    skill_title = true,
    prot_title = true,
    damage_title = true,
    set_status = true,
}

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

    value = tonumber(value) or 0

    -- NÃO altera títulos
    if ignoreZero[id] then
        return
    end

    -- Guardar prefixo uma única vez
    if not labelPrefixes[id] then
        labelPrefixes[id] = label:getText()
    end

    label:setText(labelPrefixes[id] .. value)
end

-- Preenche labels com 0, exceto títulos
local function fillAllStatsWithZero()
    if not statusInfoWindow then return end

    for _, widget in pairs(statusInfoWindow:getChildren()) do
        if widget:getClassName() == "UILabel" then

            local id = widget:getId()

            -- Só coloca 0 em labels com ID que NÃO estão na ignoreZero
            if id and id ~= "" and not ignoreZero[id] then

                if not labelPrefixes[id] then
                    labelPrefixes[id] = widget:getText()
                end

                widget:setText(labelPrefixes[id] .. "0")
            end
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

        -- Coloca 0 em labels normais
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
