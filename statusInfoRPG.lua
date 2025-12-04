-- ---------------------------------------------------------------
-- -- VARIÁVEIS DO MÓDULO 
-- ---------------------------------------------------------------
-- local statusInfoWindow = nil
-- local statusInfoButton = nil
-- local totalStats = {}

-- ---------------------------------------------------------------
-- -- INIT (Versão com Verificação)
-- ---------------------------------------------------------------
-- function init()
--     -- Carrega o UI
--     statusInfoWindow = g_ui.displayUI('statusInfoRPG.otui')
--     if not statusInfoWindow then
--         perror("[statusInfoRPG] Falha ao carregar statusInfoRPG.otui")
--         return
--     else
--         print("[statusInfoRPG] statusInfoWindow carregada com sucesso!")
--     end

--     statusInfoWindow:hide()

--     -- Botão no topo para abrir/fechar
--     statusInfoButton = modules.client_topmenu.addRightGameToggleButton(
--         'statusInfoRPGButton',
--         "Status Info RPG",
--         'icon',
--         toggleWindow,
--         true
--     )

--     -- Inicializa os stats diretamente da tabela ret
--     totalStats = parseItemStats()

--     -- Checa se os Labels existem
--     local idsToCheck = {
--         "trpgb_stat_health", "trpgb_stat_healthpercent", "trpgb_mana",
--         "trpgb_skill_fist", "trpgb_skill_sword", "trpgb_sockets"
--     }
--     for _, id in ipairs(idsToCheck) do
--         local lbl = statusInfoWindow:recursiveGetChildById(id)
--         if lbl then
--             print("Label '" .. id .. "' encontrada!")
--         else
--             print("Label '" .. id .. "' NÃO encontrada!")
--         end
--     end

--     -- Atualiza a GUI
--     updateStatusModule(totalStats)
--     print("[statusInfoRPG] Loaded successfully.")
-- end

-- ---------------------------------------------------------------
-- -- FUNÇÕES AUXILIARES
-- ---------------------------------------------------------------
-- function toggleWindow()
--     if not statusInfoWindow then return end
--     if statusInfoWindow:isVisible() then
--         statusInfoWindow:hide()
--     else
--         statusInfoWindow:show()
--         statusInfoWindow:raise()
--         statusInfoWindow:focus()
--     end
-- end

-- function parseItemStats()
--     local stats = {
--         trpgb_stat_health = 0,
--         trpgb_stat_healthpercent = 0,
--         trpgb_healthgain = 0,
--         trpgb_stat_manapercent = 0,
--         trpgb_mana = 0,
--         trpgb_managain = 0,
--         trpgb_armor = 0,
--         trpgb_stat_magiclevel = 0,
--         trpgb_skill_fist = 0,
--         trpgb_skill_sword = 0,
--         trpgb_skill_axe = 0,
--         trpgb_skill_club = 0,
--         trpgb_skill_distance = 0,
--         trpgb_skill_shield = 0,
--         trpgb_sockets = 0,
--         trpgb_skill_meleepercent = 0,
--         trpgb_skill_distancepercent = 0
--     }

--     local ret = {
--         trpgb_stat_health = 180,
--         trpgb_stat_healthpercent = 10,
--         trpgb_stat_manapercent = 15,
--         trpgb_mana = 200,
--         trpgb_healthgain = 50,
--         trpgb_managain = 30,
--         trpgb_armor = 200,
--         trpgb_stat_magiclevel = 20,
--         trpgb_sockets = 40,
--         trpgb_skill_fist = 20,
--         trpgb_skill_sword = 30,
--         trpgb_skill_axe = 40,
--         trpgb_skill_club = 50,
--         trpgb_skill_distance = 60,
--         trpgb_skill_shield = 70,
--         trpgb_skill_meleepercent = 80,
--         trpgb_skill_distancepercent = 90
--     }

--     for k, v in pairs(ret) do
--         stats[k] = v
--     end

--     -- Debug: imprime todos os valores
--     print("[statusInfoRPG] Valores da tabela totalStats:")
--     for k, v in pairs(stats) do
--         print(k, v)
--     end

--     return stats
-- end

-- ---------------------------------------------------------------
-- -- ATUALIZA GUI
-- ---------------------------------------------------------------
-- function updateStatusModule(s)
--     if not statusInfoWindow then
--         print("[statusInfoRPG] statusInfoWindow NIL ao atualizar GUI!")
--         return
--     end

--     local function setValue(id, textPrefix, value, suffix)
--         local lbl = statusInfoWindow:recursiveGetChildById(id)
--         if lbl then
--             suffix = suffix or ""
--             lbl:setText(textPrefix .. tostring(value) .. suffix)
--         else
--             print("[statusInfoRPG] Label '" .. id .. "' não encontrada ao atualizar!")
--         end
--     end

--     setValue("trpgb_stat_health", "Health Flat: ", s.trpgb_stat_health)
--     setValue("trpgb_stat_healthpercent", "Health %: ", s.trpgb_stat_healthpercent, "%")
--     setValue("trpgb_stat_manapercent", "Mana %: ", s.trpgb_stat_manapercent, "%")
--     setValue("trpgb_mana", "Mana Flat: ", s.trpgb_mana)
--     setValue("trpgb_armor", "Extra Armor: ", s.trpgb_armor)
--     setValue("trpgb_stat_magiclevel", "Magic Level: ", s.trpgb_stat_magiclevel)

--     setValue("trpgb_skill_fist", "Fist Skill: ", s.trpgb_skill_fist)
--     setValue("trpgb_skill_sword", "Sword Skill: ", s.trpgb_skill_sword)
--     setValue("trpgb_skill_axe", "Axe Skill: ", s.trpgb_skill_axe)
--     setValue("trpgb_skill_club", "Club Skill: ", s.trpgb_skill_club)
--     setValue("trpgb_skill_distance", "Distance Skill: ", s.trpgb_skill_distance)
--     setValue("trpgb_skill_shield", "Shielding Skill: ", s.trpgb_skill_shield)
--     setValue("trpgb_skill_meleepercent", "Melee %: ", s.trpgb_skill_meleepercent)
--     setValue("trpgb_skill_distancepercent", "Distance %: ", s.trpgb_skill_distancepercent)

--     setValue("trpgb_sockets", "Sockets: ", s.trpgb_sockets)
--     setValue("trpgb_healthgain", "Life Regen: ", s.trpgb_healthgain)
--     setValue("trpgb_managain", "Mana Regen: ", s.trpgb_managain)
-- end


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

    -- Inicializa os stats diretamente da tabela ret
    totalStats = parseItemStats()
    updateStatusModule(totalStats)

    print("[statusInfoRPG] Loaded successfully, e Thanatos melhor PET! ")
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
end

---------------------------------------------------------------
-- TOGGLE WINDOW
---------------------------------------------------------------
function toggleWindow()
    if not statusInfoWindow then return end

    if statusInfoWindow:isVisible() then
        statusInfoWindow:hide()
    else
        statusInfoWindow:show()
        statusInfoWindow:raise()
        statusInfoWindow:focus()
    end
end

---------------------------------------------------------------
-- PARSER DOS STATS (tabela ret)
---------------------------------------------------------------
function parseItemStats()
    local stats = {
        trpgb_stat_health = 0,
        trpgb_stat_healthpercent = 0,
        trpgb_healthgain = 0,
        trpgb_stat_manapercent = 0,
        trpgb_mana = 0,
        trpgb_managain = 0,
        trpgb_armor = 0,
        trpgb_stat_magiclevel = 0,
        trpgb_skill_fist = 0,
        trpgb_skill_sword = 0,
        trpgb_skill_axe = 0,
        trpgb_skill_club = 0,
        trpgb_skill_distance = 0,
        trpgb_skill_shield = 0,
        trpgb_sockets = 0,
        trpgb_skill_meleepercent = 0,
        trpgb_skill_distancepercent = 0
    }

    -- Valores da tabela ret que você quer exibir
    local ret = {
        ["trpgb_stat_healthpercent"] = 100,
        ["trpgb_stat_health"] = 500,
        ["trpgb_stat_manapercent"] = 150,
        ["trpgb_mana"] = 200,
        ["trpgb_healthgain"] = 500,
        ["trpgb_managain"] = 300,
        ["trpgb_armor"] = 2000,
        ["trpgb_stat_magiclevel"] = 200,
        ["trpgb_sockets"] = 400,
        ["trpgb_skill_fist"] = 200,
        ["trpgb_skill_sword"] = 300,
        ["trpgb_skill_axe"] = 400,
        ["trpgb_skill_club"] = 500,
        ["trpgb_skill_distance"] = 600,
        ["trpgb_skill_shield"] = 700,
        ["trpgb_skill_meleepercent"] = 800,
        ["trpgb_skill_distancepercent"] = 900,
    }

    -- Copia os valores da tabela ret para stats
    for k, v in pairs(ret) do
        stats[k] = v
    end

    return stats
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
    setLabel("trpgb_mana", stats.trpgb_mana)
    setLabel("trpgb_armor", stats.trpgb_armor)
    setLabel("trpgb_stat_magiclevel", stats.trpgb_stat_magiclevel)

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

