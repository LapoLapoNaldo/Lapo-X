-- LapoHubX.lua
-- Reescrito completo — leitura real de OwnedUnits com detecção de mudança
-- Fix: aguarda replicação do servidor após cada roll antes de checar trait

local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

-- ====== ÚNICA TAB ======
LapoHub:AddTab("Lapo Hub", "⚡")

LapoHub:Init({
    Title     = "Lapo Hub X",
    ToggleKey = "K",
})

LapoHub:SetUser("LapoLapoNaldo", "Lapo Newba")
LapoHub:SetUserCallback(function(n, r)
    LapoHub:Notify({ title = "User", content = n .. " • " .. r, duration = 3 })
end)

-- ====== SERVICES ======
local Players  = game:GetService("Players")
local RS       = game:GetService("ReplicatedStorage")
local HttpSvc  = game:GetService("HttpService")
local LP       = Players.LocalPlayer

local traitRemote = RS:WaitForChild("Remote"):WaitForChild("traitRemote")
local RR_TYPES    = { "Random", "SuperRandom" }

-- ====== TRAIT DATA ======
local TraitData = {
    ["Strength"]        = { Rarity = "R",  Color = Color3.fromRGB(120,180,120), Desc = "+10% ATK" },
    ["Swiftness"]       = { Rarity = "R",  Color = Color3.fromRGB(120,180,120), Desc = "-5% SPA" },
    ["Precision"]       = { Rarity = "R",  Color = Color3.fromRGB(120,180,120), Desc = "+10% RNG" },
    ["Entrepreneur"]    = { Rarity = "SR", Color = Color3.fromRGB(80,160,220),  Desc = "+10% Cash" },
    ["Deadeye"]         = { Rarity = "SR", Color = Color3.fromRGB(80,160,220),  Desc = "+25% Range" },
    ["Berserk"]         = { Rarity = "SR", Color = Color3.fromRGB(80,160,220),  Desc = "+20% ATK" },
    ["Golden"]          = { Rarity = "UR", Color = Color3.fromRGB(220,180,50),  Desc = "+20% Cash, -10% Cost" },
    ["Giant Slayer"]    = { Rarity = "UR", Color = Color3.fromRGB(220,180,50),  Desc = "+40% ATK, +50% boss dmg" },
    ["Elementalist"]    = { Rarity = "UR", Color = Color3.fromRGB(220,180,50),  Desc = "+50% DOT, +10% DOT rate" },
    ["Momentum"]        = { Rarity = "UR", Color = Color3.fromRGB(220,180,50),  Desc = "-20% SPA, +30% RNG" },
    ["Dark Summoner"]   = { Rarity = "UR", Color = Color3.fromRGB(220,180,50),  Desc = "+30% Summon ATK, -10% SPA" },
    ["Bounty Hunt"]     = { Rarity = "UR", Color = Color3.fromRGB(220,180,50),  Desc = "+15% RNG, bounty tag" },
    ["Assassin"]        = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+50% ATK, -15% SPA, bounty" },
    ["Streamliner"]     = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+50% ATK, +15% RNG, -10% SPA" },
    ["Arcanist"]        = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+125% DOT, +30% rate, -10% SPA, -20% Cost" },
    ["Survivor"]        = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+40% ATK, +20% Summon ATK, +150% EXP" },
    ["Divine Treasure"] = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+50% Summon ATK, +30% ATK, +15% RNG" },
    ["The Honored One"] = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+100% ATK, +25% cost/placement, +15% RNG, limit 1" },
    ["The Fallen One"]  = { Rarity = "LR", Color = Color3.fromRGB(200,60,60),   Desc = "+250% DOT, +30% ATK, +15% RNG, +50% Cost, limit 1" },
}

local TRAIT_NAMES = {
    "Strength", "Swiftness", "Precision",
    "Entrepreneur", "Deadeye", "Berserk",
    "Golden", "Giant Slayer", "Elementalist",
    "Momentum", "Dark Summoner", "Bounty Hunt",
    "Assassin", "Streamliner", "Arcanist",
    "Survivor", "Divine Treasure", "The Honored One", "The Fallen One",
}

-- =====================================================
-- ====== CORE: LEITURA DE DATA COM CHANGE DETECT ======
-- =====================================================
-- OwnedUnits é um StringValue cujo .Value é JSON gigante
-- Problema: após InvokeServer, o .Value demora pra replicar no client
-- Solução: escutar .Changed e/ou poll até detectar mudança

local dataFolder   = LP:WaitForChild("Data", 10)
local unitsValue   = dataFolder and dataFolder:WaitForChild("OwnedUnits", 10)

-- Cache global — sempre atualizado via listener
local cachedRaw      = ""
local cachedUnitsData = {}
local dataVersion    = 0   -- incrementa toda vez que o Value muda

-- Parse o JSON e atualiza cache
local function parseAndCache(raw)
    if not raw or raw == "" then return {} end
    local ok, data = pcall(function()
        return HttpSvc:JSONDecode(raw)
    end)
    if ok and type(data) == "table" then
        cachedUnitsData = data
        return data
    end
    return cachedUnitsData
end

-- Leitura inicial
if unitsValue then
    cachedRaw = unitsValue.Value or ""
    parseAndCache(cachedRaw)

    -- LISTENER: escuta QUALQUER mudança no Value do OwnedUnits
    -- Isso é o que garante que após um roll, a gente pega a data nova
    unitsValue:GetPropertyChangedSignal("Value"):Connect(function()
        local newRaw = unitsValue.Value
        if newRaw ~= cachedRaw then
            cachedRaw = newRaw
            dataVersion = dataVersion + 1
            parseAndCache(newRaw)
        end
    end)
end

-- Força re-leitura direto do Value (bypass cache pra safety)
local function forceReadUnits()
    if not unitsValue then return cachedUnitsData end
    local raw = unitsValue.Value
    if raw and raw ~= "" and raw ~= cachedRaw then
        cachedRaw = raw
        dataVersion = dataVersion + 1
        parseAndCache(raw)
    end
    return cachedUnitsData
end

-- Leitura normal (usa cache que é mantido pelo listener)
local function readOwnedUnits()
    return cachedUnitsData
end

-- Espera até a data mudar (retorna true se mudou, false se timeout)
-- Usado APÓS um roll pra garantir que o servidor atualizou
local function waitForDataChange(timeoutSec)
    local versionBefore = dataVersion
    local elapsed = 0
    local pollInterval = 0.05  -- checa a cada 50ms

    while elapsed < timeoutSec do
        task.wait(pollInterval)
        elapsed = elapsed + pollInterval

        -- Checa se o listener já pegou a mudança
        if dataVersion > versionBefore then
            return true
        end

        -- Fallback: force-read direto do Value caso o listener não tenha disparado
        forceReadUnits()
        if dataVersion > versionBefore then
            return true
        end
    end

    -- Último fallback: lê direto e aceita mesmo se o version não mudou
    -- (pode ser que a trait não mudou mesmo — rolou a mesma trait)
    forceReadUnits()
    return false
end

-- Pega a trait ativa de uma unit
local function getUnitTrait(unitName)
    local units = readOwnedUnits()
    local unitData = units[unitName]
    if not unitData then return "N/A" end

    local traits = unitData.Traits
    if not traits or type(traits) ~= "table" then return "None" end

    local selectedIdx = unitData.SelectedTrait or 1
    local activeTrait = traits[selectedIdx]

    if activeTrait and activeTrait ~= "None" then
        return activeTrait
    end

    for _, t in ipairs(traits) do
        if t and t ~= "None" then return t end
    end

    return "None"
end

-- Pega TODAS as traits de uma unit (3 slots)
local function getUnitAllTraits(unitName)
    local units = readOwnedUnits()
    local unitData = units[unitName]
    if not unitData then return { "N/A", "N/A", "N/A" } end

    local traits = unitData.Traits
    if not traits or type(traits) ~= "table" then return { "None", "None", "None" } end

    return {
        traits[1] or "None",
        traits[2] or "None",
        traits[3] or "None",
    }
end

-- Info completa de uma unit
local function getUnitInfo(unitName)
    local units = readOwnedUnits()
    return units[unitName]
end

-- Lista todas as units ordenadas
local function buildUnitList()
    local units = readOwnedUnits()
    local list = {}
    for name, _ in pairs(units) do
        table.insert(list, name)
    end
    table.sort(list)
    if #list == 0 then
        list = { "Nenhuma unit encontrada" }
    end
    return list
end

-- ====== LEITURA DE MATERIAIS / ITEMS ======
local function readMaterials()
    local ok, data = pcall(function()
        local raw = dataFolder:WaitForChild("OwnedMaterials", 5).Value
        return HttpSvc:JSONDecode(raw)
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

local function readOwnedItems()
    local ok, data = pcall(function()
        local raw = dataFolder:WaitForChild("OwnedItems", 5).Value
        return HttpSvc:JSONDecode(raw)
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

local function getTokenInfo()
    local mats  = readMaterials()
    local items = readOwnedItems()
    return {
        Spirit           = mats["Spirit"] or 0,
        SecretCrystal    = mats["Secret Crystal"] or 0,
        CelestialCrystal = items["Celestial Crystal"] or 0,
        SuperCelestial   = items["Super Celestial Crystal"] or 0,
    }
end

-- ====== ROLL COM ESPERA DE REPLICAÇÃO ======
local function doRoll(rrType, unitName)
    local result = nil
    local ok, err = pcall(function()
        result = traitRemote:InvokeServer(rrType, unitName)
    end)
    if not ok then
        LapoHub:Notify({ title = "❌ Erro Roll", content = tostring(err), duration = 4 })
        return false, nil
    end
    return true, result
end

-- ====== STATE ======
local selectedRRType = RR_TYPES[1]
local UNITS          = buildUnitList()
local selectedUnit   = UNITS[1] or "Nenhuma"
local selectedTrait  = TRAIT_NAMES[1]
local autoRolling    = false
local rollDelay      = 0.8
local rollCount      = 0

-- ========================
-- ======= UI BUILD =======
-- ========================

-- ====== SEÇÃO: INFO DO PLAYER ======
LapoHub:AddLabel("Lapo Hub", { text = "👤 Player Info" })

local tokenLabel = LapoHub:AddLabel("Lapo Hub", { text = "Carregando tokens..." })

local function refreshTokenLabel()
    local tk = getTokenInfo()
    local txt = string.format(
        "🔮 Spirit: %s  |  💎 Secret: %s\n✨ Celestial: %s  |  ⭐ Super: %s",
        tostring(tk.Spirit),
        tostring(tk.SecretCrystal),
        tostring(tk.CelestialCrystal),
        tostring(tk.SuperCelestial)
    )
    tokenLabel:updateText(txt)
end

LapoHub:AddButton("Lapo Hub", {
    text = "🔄 Atualizar Tokens",
    callback = function()
        refreshTokenLabel()
        LapoHub:Notify({ title = "Tokens", content = "Atualizado!", duration = 2 })
    end,
})

LapoHub:AddSeparator("Lapo Hub")

-- ====== SEÇÃO: SELEÇÃO DE UNIT ======
LapoHub:AddLabel("Lapo Hub", { text = "🎮 Seleção de Unit" })

local unitInfoLabel   = LapoHub:AddLabel("Lapo Hub", { text = "Selecione uma unit..." })
local traitAtualLabel = LapoHub:AddLabel("Lapo Hub", { text = "🎯 Trait Atual: —" })
local traitSlotsLabel = LapoHub:AddLabel("Lapo Hub", { text = "📋 Slots: — | — | —" })

local function refreshUnitDisplay(unitName)
    local info = getUnitInfo(unitName)
    if not info then
        unitInfoLabel:updateText("⚠ Unit '" .. tostring(unitName) .. "' não encontrada")
        traitAtualLabel:updateText("🎯 Trait Atual: N/A")
        traitSlotsLabel:updateText("📋 Slots: N/A")
        return
    end

    local upgrade   = info.Upgrade or 0
    local limitB    = info.LimitBreak or 0
    local dupes     = info.DuplicateSummon or 0
    local wins      = info.Win or 0
    local dmg       = info.DealDamage or 0
    local mods      = info.Modifiers or {}
    local atk       = mods.ATK or 1
    local sta       = mods.STA or 1
    local cost      = mods.COST or 1

    unitInfoLabel:updateText(string.format(
        "📊 %s — Upg:%d LB:%d Dupes:%d Wins:%d\n   DMG:%.0f | ATK:%.1fx STA:%.1fx COST:%.1fx",
        unitName, upgrade, limitB, dupes, wins, dmg, atk, sta, cost
    ))

    local activeTrait = getUnitTrait(unitName)
    local traitInfo = TraitData[activeTrait]
    if traitInfo then
        traitAtualLabel:updateText(string.format(
            "🎯 Trait Atual: %s [%s] — %s",
            activeTrait, traitInfo.Rarity, traitInfo.Desc
        ))
    else
        traitAtualLabel:updateText("🎯 Trait Atual: " .. tostring(activeTrait))
    end

    local slots = getUnitAllTraits(unitName)
    local slotTxts = {}
    for i, s in ipairs(slots) do
        local tag = s
        local si = TraitData[s]
        if si then
            tag = s .. "[" .. si.Rarity .. "]"
        end
        table.insert(slotTxts, "S" .. i .. ":" .. tag)
    end
    traitSlotsLabel:updateText("📋 " .. table.concat(slotTxts, " | "))
end

LapoHub:AddDropdown("Lapo Hub", {
    text    = "Boneco",
    options = UNITS,
    default = 1,
    callback = function(_, value)
        selectedUnit = value
        refreshUnitDisplay(value)
    end,
})

LapoHub:AddButton("Lapo Hub", {
    text = "🔄 Recarregar Units",
    callback = function()
        forceReadUnits()
        UNITS = buildUnitList()
        LapoHub:Notify({
            title   = "Units",
            content = "Encontradas: " .. #UNITS .. " units",
            duration = 3,
        })
    end,
})

LapoHub:AddSeparator("Lapo Hub")

-- ====== SEÇÃO: REROLL ======
LapoHub:AddLabel("Lapo Hub", { text = "🎲 Reroll de Traits" })

LapoHub:AddDropdown("Lapo Hub", {
    text    = "Tipo de Roll",
    options = { "Normal (Random)", "Super (SuperRandom)" },
    default = 1,
    callback = function(_, value)
        if value == "Super (SuperRandom)" then
            selectedRRType = RR_TYPES[2]
        else
            selectedRRType = RR_TYPES[1]
        end
        LapoHub:Notify({
            title   = "Roll Type",
            content = "Usando: " .. selectedRRType,
            duration = 2,
        })
    end,
})

LapoHub:AddDropdown("Lapo Hub", {
    text    = "Trait Desejada",
    options = TRAIT_NAMES,
    default = 1,
    callback = function(_, value)
        selectedTrait = value
        local d = TraitData[value]
        if d then
            LapoHub:Notify({
                title   = "🎯 [" .. d.Rarity .. "] " .. value,
                content = d.Desc,
                duration = 4,
            })
        end
    end,
})

LapoHub:AddSlider("Lapo Hub", {
    text    = "Delay entre rolls (seg)",
    min     = 0.4,
    max     = 3.0,
    default = 0.8,
    callback = function(value)
        rollDelay = value
    end,
})

local autoStatusLabel = LapoHub:AddLabel("Lapo Hub", { text = "⏹ Auto-Roll: Parado" })
local debugLabel      = LapoHub:AddLabel("Lapo Hub", { text = "🔧 Debug: —" })

LapoHub:AddSeparator("Lapo Hub")

-- ====== BOTÕES DE AÇÃO ======
LapoHub:AddLabel("Lapo Hub", { text = "⚡ Ações" })

-- Girar 1x
LapoHub:AddButton("Lapo Hub", {
    text = "🎰 Girar 1x",
    callback = function()
        if not selectedUnit or selectedUnit == "Nenhuma unit encontrada" then
            LapoHub:Notify({ title = "Reroll", content = "Selecione um boneco primeiro.", duration = 3 })
            return
        end

        local traitAntes = getUnitTrait(selectedUnit)
        debugLabel:updateText("🔧 Rolando " .. selectedUnit .. "... trait antes: " .. tostring(traitAntes))

        local ok, result = doRoll(selectedRRType, selectedUnit)
        if not ok then return end

        rollCount = rollCount + 1

        -- ESPERA a data mudar no client (até 3 segundos)
        local changed = waitForDataChange(3.0)
        debugLabel:updateText("🔧 Data mudou: " .. tostring(changed) .. " | version: " .. tostring(dataVersion))

        -- Lê trait DEPOIS da replicação
        local traitDepois = getUnitTrait(selectedUnit)

        refreshUnitDisplay(selectedUnit)

        if traitAntes ~= traitDepois then
            local info = TraitData[traitDepois]
            local rarTxt = info and (" [" .. info.Rarity .. "]") or ""
            LapoHub:Notify({
                title   = "🔄 Trait Mudou!",
                content = traitAntes .. " → " .. traitDepois .. rarTxt,
                duration = 4,
            })
        else
            LapoHub:Notify({
                title   = "🎰 Roll #" .. rollCount,
                content = "Trait continua: " .. tostring(traitDepois),
                duration = 2,
            })
        end
    end,
})

-- Auto-roll até pegar a trait desejada
LapoHub:AddToggle("Lapo Hub", {
    text    = "🔁 Auto-Roll até pegar trait",
    default = false,
    callback = function(state)
        autoRolling = state

        if not state then
            autoStatusLabel:updateText("⏹ Auto-Roll: Parado")
            return
        end

        if not selectedUnit or selectedUnit == "Nenhuma unit encontrada" then
            LapoHub:Notify({ title = "Auto", content = "Selecione um boneco!", duration = 3 })
            autoRolling = false
            return
        end

        if not selectedTrait or selectedTrait == "" then
            LapoHub:Notify({ title = "Auto", content = "Selecione a trait desejada!", duration = 3 })
            autoRolling = false
            return
        end

        -- Checa se já tem a trait ANTES de começar
        forceReadUnits()
        local currentBefore = getUnitTrait(selectedUnit)
        if currentBefore == selectedTrait then
            LapoHub:Notify({
                title   = "✅ Já tem!",
                content = selectedUnit .. " já possui " .. selectedTrait,
                duration = 5,
            })
            autoRolling = false
            autoStatusLabel:updateText("✅ Já possui: " .. selectedTrait)
            return
        end

        task.spawn(function()
            local tries = 0
            local startTick = tick()

            autoStatusLabel:updateText("🔄 Rolando... Buscando: " .. selectedTrait)

            LapoHub:Notify({
                title   = "🎲 Auto-Roll Iniciado",
                content = "Unit: " .. selectedUnit .. "\nBuscando: " .. selectedTrait .. "\nDelay: " .. rollDelay .. "s",
                duration = 4,
            })

            while autoRolling do
                -- ========== PASSO 1: SALVAR VERSÃO ATUAL ==========
                local versionBefore = dataVersion
                local traitBefore   = getUnitTrait(selectedUnit)

                -- ========== PASSO 2: ROLAR ==========
                local ok, result = doRoll(selectedRRType, selectedUnit)
                tries = tries + 1
                rollCount = rollCount + 1

                if not ok then
                    autoRolling = false
                    autoStatusLabel:updateText("❌ Erro no roll após " .. tries .. " tentativas")
                    LapoHub:Notify({
                        title   = "❌ Auto-Roll Parou",
                        content = "Erro ao rolar. Tentativas: " .. tries,
                        duration = 5,
                    })
                    break
                end

                -- ========== PASSO 3: ESPERAR REPLICAÇÃO ==========
                -- InvokeServer é síncrono, mas a mudança no StringValue pode demorar
                -- Espera até 2s pra data mudar, checando a cada 50ms
                local dataChanged = waitForDataChange(2.0)

                -- Se o delay do usuário é maior que o tempo de espera, completa com wait
                local extraWait = rollDelay - 2.0
                if extraWait > 0 then
                    task.wait(extraWait)
                end

                -- ========== PASSO 4: LER TRAIT NOVA ==========
                -- Force read mais uma vez pra garantir
                forceReadUnits()
                local currentTrait = getUnitTrait(selectedUnit)

                -- Debug info
                debugLabel:updateText(string.format(
                    "🔧 R#%d v%d→%d | antes:%s | agora:%s | mudou:%s",
                    tries, versionBefore, dataVersion,
                    tostring(traitBefore), tostring(currentTrait),
                    tostring(dataChanged)
                ))

                -- ========== PASSO 5: COMPARAR ==========
                if currentTrait == selectedTrait then
                    autoRolling = false
                    local elapsed = tick() - startTick

                    local traitInfo = TraitData[selectedTrait]
                    local rarTxt = traitInfo and (" [" .. traitInfo.Rarity .. "]") or ""

                    autoStatusLabel:updateText(string.format(
                        "✅ ACHEI! %s%s em %d rolls (%.1fs)",
                        selectedTrait, rarTxt, tries, elapsed
                    ))

                    LapoHub:Notify({
                        title   = "🎉 TRAIT ENCONTRADA!",
                        content = string.format(
                            "%s agora tem: %s%s\nRolls: %d | Tempo: %.1fs",
                            selectedUnit, selectedTrait, rarTxt, tries, elapsed
                        ),
                        duration = 10,
                    })

                    refreshUnitDisplay(selectedUnit)
                    break
                end

                -- ========== PASSO 6: NÃO ACHOU — STATUS ==========
                local elapsed = tick() - startTick
                local traitInfoCur = TraitData[currentTrait]
                local curRar = traitInfoCur and ("[" .. traitInfoCur.Rarity .. "]") or ""

                autoStatusLabel:updateText(string.format(
                    "🔄 Roll #%d | Atual: %s %s | Buscando: %s | %.0fs",
                    tries, currentTrait, curRar, selectedTrait, elapsed
                ))

                if tries % 5 == 0 then
                    refreshUnitDisplay(selectedUnit)
                end

                if tries % 25 == 0 then
                    LapoHub:Notify({
                        title   = "📊 Progresso",
                        content = string.format(
                            "Rolls: %d | Última: %s %s\nBuscando: %s | Tempo: %.0fs",
                            tries, currentTrait, curRar, selectedTrait, elapsed
                        ),
                        duration = 4,
                    })
                end

                if tries >= 500 then
                    autoRolling = false
                    autoStatusLabel:updateText("⚠ Parou em 500 rolls — trait não encontrada")
                    LapoHub:Notify({
                        title   = "⚠ Limite de Segurança",
                        content = "500 rolls sem encontrar " .. selectedTrait .. ". Parando.",
                        duration = 8,
                    })
                    refreshUnitDisplay(selectedUnit)
                    break
                end

                -- ========== PASSO 7: DETECTAR DATA PARADA ==========
                -- Se a data NÃO mudou por 5 rolls seguidos, avisa
                if not dataChanged and tries > 3 then
                    if tries % 5 == 0 then
                        LapoHub:Notify({
                            title   = "⚠ Aviso",
                            content = "Data não está atualizando. Pode ser lag do servidor.\nTentando continuar...",
                            duration = 3,
                        })
                        -- Tenta forçar uma leitura completa
                        task.wait(0.5)
                        forceReadUnits()
                    end
                end
            end

            if not autoRolling and tries > 0 then
                refreshUnitDisplay(selectedUnit)
            end
        end)
    end,
})

-- Botão de parar
LapoHub:AddButton("Lapo Hub", {
    text = "⏹ Parar Auto-Roll",
    callback = function()
        if autoRolling then
            autoRolling = false
            autoStatusLabel:updateText("⏹ Parado manualmente")
            LapoHub:Notify({ title = "Auto-Roll", content = "Parado!", duration = 2 })
        end
    end,
})

LapoHub:AddSeparator("Lapo Hub")

-- ====== SEÇÃO: FERRAMENTAS ======
LapoHub:AddLabel("Lapo Hub", { text = "🛠 Ferramentas" })

LapoHub:AddButton("Lapo Hub", {
    text = "📋 Listar Units com Traits",
    callback = function()
        forceReadUnits()
        local units = readOwnedUnits()
        local withTraits = {}
        local total = 0

        for name, data in pairs(units) do
            total = total + 1
            local traits = data.Traits
            if traits then
                for _, t in ipairs(traits) do
                    if t and t ~= "None" then
                        local ti = TraitData[t]
                        local rar = ti and (" [" .. ti.Rarity .. "]") or ""
                        table.insert(withTraits, name .. ": " .. t .. rar)
                        break
                    end
                end
            end
        end

        table.sort(withTraits)

        local txt = "Total: " .. total .. " units\nCom trait: " .. #withTraits
        if #withTraits > 0 then
            txt = txt .. "\n\n" .. table.concat(withTraits, "\n")
        end

        LapoHub:Notify({
            title    = "📋 Units com Traits",
            content  = txt,
            duration = 12,
        })
    end,
})

LapoHub:AddButton("Lapo Hub", {
    text = "🔍 Units SEM Trait",
    callback = function()
        forceReadUnits()
        local units = readOwnedUnits()
        local noTrait = {}

        for name, data in pairs(units) do
            local hasTrait = false
            local traits = data.Traits
            if traits then
                for _, t in ipairs(traits) do
                    if t and t ~= "None" then
                        hasTrait = true
                        break
                    end
                end
            end
            if not hasTrait then
                table.insert(noTrait, name)
            end
        end

        table.sort(noTrait)

        LapoHub:Notify({
            title    = "🔍 Sem Trait (" .. #noTrait .. ")",
            content  = #noTrait > 0 and table.concat(noTrait, "\n") or "Todas já têm trait!",
            duration = 10,
        })
    end,
})

LapoHub:AddButton("Lapo Hub", {
    text = "📊 Stats da Sessão",
    callback = function()
        LapoHub:Notify({
            title   = "📊 Sessão",
            content = "Total de rolls: " .. rollCount .. "\nData version: " .. dataVersion,
            duration = 4,
        })
    end,
})

-- Debug: checar data value raw
LapoHub:AddButton("Lapo Hub", {
    text = "🔧 Debug: Checar OwnedUnits",
    callback = function()
        if not unitsValue then
            LapoHub:Notify({ title = "Debug", content = "OwnedUnits não encontrado!", duration = 5 })
            return
        end

        local raw = unitsValue.Value
        local len = raw and #raw or 0

        forceReadUnits()
        local traitCheck = getUnitTrait(selectedUnit)

        LapoHub:Notify({
            title   = "🔧 Debug OwnedUnits",
            content = string.format(
                "Value length: %d chars\nData version: %d\nCache size: %d units\nUnit: %s\nTrait lida: %s",
                len, dataVersion, 
                (function() local c=0; for _ in pairs(cachedUnitsData) do c=c+1 end; return c end)(),
                tostring(selectedUnit),
                tostring(traitCheck)
            ),
            duration = 8,
        })
    end,
})

LapoHub:AddSeparator("Lapo Hub")

-- ====== RODAPÉ ======
LapoHub:AddParagraph("Lapo Hub", { text = "Lapo Hub X © ENI — Toggle: K\nData: listener + force read + version tracking" })

-- ====== INIT ======
refreshTokenLabel()
if selectedUnit and selectedUnit ~= "Nenhuma unit encontrada" then
    refreshUnitDisplay(selectedUnit)
end

LapoHub:Notify({
    title   = "⚡ Lapo Hub X",
    content = "Hub carregado! " .. #UNITS .. " units\nData version: " .. dataVersion .. " | Listener ativo",
    duration = 5,
})

return LapoHub
