-- LapoHubX.lua
-- Reescrito por ENI — versão corrigida
-- Fix: leitura de data, tokens, dropdown trait, tudo em 1 tab

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
    ["Strength"]        = { Rarity = "R",  Desc = "+10% ATK" },
    ["Swiftness"]       = { Rarity = "R",  Desc = "-5% SPA" },
    ["Precision"]       = { Rarity = "R",  Desc = "+10% RNG" },
    ["Entrepreneur"]    = { Rarity = "SR", Desc = "+10% Cash" },
    ["Deadeye"]         = { Rarity = "SR", Desc = "+25% Range" },
    ["Berserk"]         = { Rarity = "SR", Desc = "+20% ATK" },
    ["Golden"]          = { Rarity = "UR", Desc = "+20% Cash, -10% Cost" },
    ["Giant Slayer"]    = { Rarity = "UR", Desc = "+40% ATK, +50% boss dmg" },
    ["Elementalist"]    = { Rarity = "UR", Desc = "+50% DOT, +10% DOT rate" },
    ["Momentum"]        = { Rarity = "UR", Desc = "-20% SPA, +30% RNG" },
    ["Dark Summoner"]   = { Rarity = "UR", Desc = "+30% Summon ATK, -10% SPA" },
    ["Bounty Hunt"]     = { Rarity = "UR", Desc = "+15% RNG, bounty tag" },
    ["Assassin"]        = { Rarity = "LR", Desc = "+50% ATK, -15% SPA, bounty" },
    ["Streamliner"]     = { Rarity = "LR", Desc = "+50% ATK, +15% RNG, -10% SPA" },
    ["Arcanist"]        = { Rarity = "LR", Desc = "+125% DOT, +30% rate, -10% SPA, -20% Cost" },
    ["Survivor"]        = { Rarity = "LR", Desc = "+40% ATK, +20% Summon ATK, +150% EXP" },
    ["Divine Treasure"] = { Rarity = "LR", Desc = "+50% Summon ATK, +30% ATK, +15% RNG" },
    ["The Honored One"] = { Rarity = "LR", Desc = "+100% ATK, +25% cost/placement, +15% RNG, limit 1" },
    ["The Fallen One"]  = { Rarity = "LR", Desc = "+250% DOT, +30% ATK, +15% RNG, +50% Cost, limit 1" },
}

local COMMON_TRAITS = {
    "Strength", "Swiftness", "Precision",
    "Entrepreneur", "Deadeye", "Berserk",
    "Golden", "Giant Slayer", "Elementalist",
    "Momentum", "Dark Summoner", "Bounty Hunt",
    "Assassin", "Streamliner", "Arcanist",
    "Survivor", "Divine Treasure", "The Honored One", "The Fallen One",
}

-- ====== HELPERS ======

-- Lê OwnedMaterials corretamente
local function readMaterials()
    local ok, data = pcall(function()
        local raw = LP:WaitForChild("Data"):WaitForChild("OwnedMaterials").Value
        return HttpSvc:JSONDecode(raw)
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

-- Lê OwnedItems (Celestial Crystals)
local function readOwnedItems()
    local ok, data = pcall(function()
        local raw = LP:WaitForChild("Data"):WaitForChild("OwnedItems").Value
        return HttpSvc:JSONDecode(raw)
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

-- Mostra tokens: Spirit, Secret Crystal e Celestial Crystals
local function showCounts()
    local mats  = readMaterials()
    local items = readOwnedItems()

    local spirit  = mats["Spirit"]          or 0
    local secret  = mats["Secret Crystal"]  or 0
    local normal  = items["Celestial Crystal"]       or 0
    local superCC = items["Super Celestial Crystal"] or 0

    LapoHub:Notify({
        title   = "💰 Tokens",
        content = ("Spirit: %d  |  Secret Crystal: %d\nCelestial: %d  |  Super: %d")
                    :format(spirit, secret, normal, superCC),
        duration = 6,
    })
end

-- Lê a trait atual de uma unit via OwnedUnits (ValueBase JSON ou filho Trait)
local function getUnitTrait(unitName)
    local ok, val = pcall(function()
        local units = LP:WaitForChild("Data"):WaitForChild("OwnedUnits")
        local u = units:FindFirstChild(unitName)
        if not u then return nil end

        -- Tenta ler como JSON dentro de um StringValue
        if u:IsA("StringValue") or u:IsA("ValueBase") then
            local raw = u.Value
            if raw and raw ~= "" then
                local okj, decoded = pcall(function() return HttpSvc:JSONDecode(raw) end)
                if okj and type(decoded) == "table" then
                    -- Traits é uma array; SelectedTrait é 1-indexed
                    local idx = decoded.SelectedTrait or 1
                    local t   = decoded.Traits and decoded.Traits[idx]
                    if t and t ~= "None" then return t end
                    -- fallback: primeiro slot
                    if decoded.Traits then
                        for _, tr in ipairs(decoded.Traits) do
                            if tr and tr ~= "None" then return tr end
                        end
                    end
                    return decoded.Trait or decoded.trait
                end
            end
        end

        -- Tenta filho "Trait"
        local t = u:FindFirstChild("Trait") or u:FindFirstChild("trait")
        return t and t.Value or nil
    end)
    if ok then return val end
    return nil
end

-- Lista as units do OwnedUnits
local function buildUnitList()
    local list = {}
    local ok = pcall(function()
        local units = LP:WaitForChild("Data"):WaitForChild("OwnedUnits")
        for _, c in ipairs(units:GetChildren()) do
            table.insert(list, c.Name)
        end
    end)
    if not ok or #list == 0 then list = { "Blue Flames" } end
    table.sort(list)
    return list
end

local function doRoll(rrType, unitName)
    local ok, err = pcall(function()
        return traitRemote:InvokeServer(rrType, unitName)
    end)
    if not ok then
        LapoHub:Notify({ title = "Erro", content = tostring(err), duration = 4 })
    end
    return ok
end

-- ====== STATE ======
local selectedRRType = RR_TYPES[1]
local UNITS          = buildUnitList()
local selectedUnit   = UNITS[1] or "Blue Flames"
local selectedTrait  = COMMON_TRAITS[1]
local autoRolling    = false

-- ====== SEÇÃO: TOKENS ======
LapoHub:AddLabel("Lapo Hub", { text = "💰 Materiais" })

LapoHub:AddButton("Lapo Hub", {
    text = "Ver tokens / materiais",
    callback = showCounts,
})

LapoHub:AddSeparator("Lapo Hub")

-- ====== SEÇÃO: REROLL ======
LapoHub:AddLabel("Lapo Hub", { text = "🎲 Reroll de Traits" })

-- Tipo de RR
LapoHub:AddDropdown("Lapo Hub", {
    text    = "Tipo de RR",
    options = { "Normal (Random)", "Super (SuperRandom)" },
    default = 1,
    callback = function(_, value)
        selectedRRType = (value == "Normal (Random)") and RR_TYPES[1] or RR_TYPES[2]
    end,
})

-- Label da trait atual
local traitAtualLabel = LapoHub:AddLabel("Lapo Hub", { text = "Trait atual: —" })

-- Dropdown de boneco
LapoHub:AddDropdown("Lapo Hub", {
    text    = "Boneco",
    options = UNITS,
    default = 1,
    callback = function(_, value)
        selectedUnit = value
        local t = getUnitTrait(value)
        if t and t ~= "" then
            traitAtualLabel:updateText("Trait atual: " .. tostring(t))
        else
            traitAtualLabel:updateText("Trait atual: Nenhuma")
        end
    end,
})

-- Dropdown trait desejada (lista fixa com todas as traits)
LapoHub:AddDropdown("Lapo Hub", {
    text    = "Trait desejada",
    options = COMMON_TRAITS,
    default = 1,
    callback = function(_, value)
        selectedTrait = value
        local d = TraitData[value]
        if d then
            LapoHub:Notify({
                title   = "[" .. d.Rarity .. "] " .. value,
                content = d.Desc,
                duration = 4,
            })
        end
    end,
})

-- Atualiza trait atual do primeiro boneco ao carregar
do
    local firstTrait = getUnitTrait(selectedUnit)
    if firstTrait and firstTrait ~= "" then
        traitAtualLabel:updateText("Trait atual: " .. tostring(firstTrait))
    end
end

LapoHub:AddSeparator("Lapo Hub")

-- Girar 1x
LapoHub:AddButton("Lapo Hub", {
    text = "Girar 1x",
    callback = function()
        if not selectedUnit then
            LapoHub:Notify({ title = "Reroll", content = "Selecione um boneco.", duration = 3 })
            return
        end
        doRoll(selectedRRType, selectedUnit)
        task.wait(0.4)
        local t = getUnitTrait(selectedUnit)
        if t and t ~= "" then
            traitAtualLabel:updateText("Trait atual: " .. tostring(t))
        else
            traitAtualLabel:updateText("Trait atual: Nenhuma")
        end
    end,
})

-- Auto-roll até pegar a trait
LapoHub:AddToggle("Lapo Hub", {
    text    = "Auto até pegar a trait",
    default = false,
    callback = function(state)
        autoRolling = state

        if not state then return end

        if not selectedUnit or not selectedTrait or selectedTrait == "" then
            LapoHub:Notify({ title = "Auto", content = "Selecione boneco e trait.", duration = 3 })
            autoRolling = false
            return
        end

        task.spawn(function()
            local tries = 0
            while autoRolling do
                local current = getUnitTrait(selectedUnit)
                if current and tostring(current) == selectedTrait then
                    autoRolling = false
                    LapoHub:Notify({
                        title   = "✅ Completo!",
                        content = ("'%s' em %d tries"):format(selectedTrait, tries),
                        duration = 6,
                    })
                    break
                end
                local ok = doRoll(selectedRRType, selectedUnit)
                tries += 1
                if not ok then
                    autoRolling = false
                    break
                end
                task.wait(0.6)
                -- atualiza label durante o auto
                local t = getUnitTrait(selectedUnit)
                if t and t ~= "" then
                    traitAtualLabel:updateText("Trait atual: " .. tostring(t) .. " [" .. tries .. "x]")
                end
            end
        end)
    end,
})

LapoHub:AddSeparator("Lapo Hub")

-- ====== RODAPÉ ======
LapoHub:AddParagraph("Lapo Hub", { text = "Lapo Hub X © ENI — Toggle: K" })

-- Mostra tokens ao iniciar
showCounts()

return LapoHub
