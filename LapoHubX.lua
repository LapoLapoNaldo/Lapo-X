-- LapoHubX.lua
-- Loader + Init do Lapo Hub X (Syn Version)
-- by ENI — for LO, sempre

local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:AddTab("Home",    "🏠")
LapoHub:AddTab("Trait's", "🎲")
LapoHub:AddTab("Settings","⚙")

LapoHub:Init({
    Title     = "Lapo Hub X",
    ToggleKey = "K",
})

LapoHub:SetUser("LapoLapoNaldo", "Lapo Newba")
LapoHub:SetUserCallback(function(n, r)
    LapoHub:Notify({title = "User", content = n .. " • " .. r, duration = 3})
end)

-- ====== SERVICES ======
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local HttpSvc = game:GetService("HttpService")
local LP      = Players.LocalPlayer

local traitRemote = RS:WaitForChild("Remote"):WaitForChild("traitRemote")
local RR_TYPES    = { "Random", "SuperRandom" }

-- ====== TRAIT DATA ======
local TraitData = {
    ["Strength"]        = { Rarity = "R",  Desc = "+10% ATK" },
    ["Swiftness"]       = { Rarity = "R",  Desc = "-5% SPA" },
    ["Precision"]       = { Rarity = "R",  Desc = "+10% RNG" },
    ["Entrepreneur"]    = { Rarity = "SR", Desc = "+10% Cash" },
    ["Deadeye"]         = { Rarity = "SR", Desc = "+25% Range" },
    ["Berserk"]         = { Rarity = "SR", Desc = "20% ATK" },
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

-- EXTrail: traits LR específicas por classe de unidade
local EXTrail = {
    Summon  = { "Survivor", "Divine Treasure" },
    DOT     = { "The Honored One", "Arcanist", "The Fallen One" },
    Hunter  = { "Survivor", "Assassin" },
    Regular = { "Streamliner", "The Honored One" },
}

-- Traits comuns que toda unidade pode pegar (R, SR, UR)
local COMMON_TRAITS = { "Strength","Swiftness","Precision","Entrepreneur","Deadeye","Berserk",
    "Golden","Giant Slayer","Elementalist","Momentum","Dark Summoner","Bounty Hunt" }

-- ====== HELPERS ======
local function readOwnedItems()
    local ok, data = pcall(function()
        return HttpSvc:JSONDecode(LP:WaitForChild("Data"):WaitForChild("OwnedItems").Value)
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

local function getUnitClass(unitName)
    local ok, unitClass = pcall(function()
        local u = LP.Data:FindFirstChild("OwnedUnits") and LP.Data.OwnedUnits:FindFirstChild(unitName)
        if not u then return nil end
        -- tenta ler atributo Class
        local cls = u:GetAttribute("Class") or u:GetAttribute("UnitClass")
        if cls then return cls end
        -- tenta módulo do jogo
        local mod = require(RS.Assets.CheckUnitModule.UnitGuiStats)
        if mod and mod.GetUnitClass then
            return mod.GetUnitClass(nil, unitName)
        end
        -- tenta inferir do nome
        for class, _ in pairs(EXTrail) do
            if unitName:find(class, 1, true) then return class end
        end
        return nil
    end)
    return ok and unitClass or nil
end

local function getTraitsForUnit(unitName)
    local class = getUnitClass(unitName)
    local lrList = {}
    if class and EXTrail[class] then
        lrList = EXTrail[class]
    else
        -- fallback: todas LR
        for k, d in pairs(TraitData) do
            if d.Rarity == "LR" then table.insert(lrList, k) end
        end
    end
    local result = {}
    for _, t in ipairs(COMMON_TRAITS) do table.insert(result, t) end
    for _, t in ipairs(lrList) do table.insert(result, t) end
    return result
end

local function getUnitTrait(unitName)
    local ok, val = pcall(function()
        local units = LP.Data:FindFirstChild("OwnedUnits")
        if not units then return nil end
        local u = units:FindFirstChild(unitName)
        if not u then return nil end
        if u:IsA("ValueBase") then
            local raw = u.Value
            local okj, decoded = pcall(function() return HttpSvc:JSONDecode(raw) end)
            if okj and type(decoded) == "table" then
                return decoded.Trait or decoded.trait
            end
            return raw
        end
        local t = u:FindFirstChild("Trait") or u:FindFirstChild("trait")
        return t and t.Value or nil
    end)
    if ok then return val end
    return nil
end

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

local function showCounts()
    local items = readOwnedItems()
    local normal = items["Celestial Crystal"] or 0
    local super  = items["Super Celestial Crystal"] or 0
    LapoHub:Notify({
        title   = "Tokens",
        content = ("Normal: %s  |  Super: %s"):format(tostring(normal), tostring(super)),
        duration = 4,
    })
end

-- ====== STATE ======
local selectedRRType  = RR_TYPES[1]
local UNITS           = buildUnitList()
local selectedUnit    = UNITS[1]
local selectedTrait   = ""
local autoRolling     = false

-- ====== HOME ======
LapoHub:AddLabel("Home",    { text = "Bem-vindo ao Lapo Hub X" })
LapoHub:AddParagraph("Home",{ text = "Pressione K para toggle da UI." })

LapoHub:AddButton("Home", {
    text = "Ver tokens",
    callback = showCounts,
})

-- ====== TRAIT'S ======
LapoHub:AddLabel("Trait's", { text = "Reroll de Traits" })

-- Dropdown tipo de RR
LapoHub:AddDropdown("Trait's", {
    text    = "Tipo de RR",
    options = { "Normal (Random)", "Super (SuperRandom)" },
    default = 1,
    callback = function(_, value)
        selectedRRType = RR_TYPES[value == "Normal (Random)" and 1 or 2]
    end,
})

-- Dropdown boneco + label trait atual
local traitAtualLabel = LapoHub:AddLabel("Trait's", {
    text = "Trait atual: —"
})

LapoHub:AddDropdown("Trait's", {
    text    = "Boneco",
    options = UNITS,
    default = 1,
    callback = function(_, value)
        selectedUnit = value
        -- atualiza trait atual
        local t = getUnitTrait(value)
        if t and t ~= "" then
            traitAtualLabel:updateText("Trait atual: " .. tostring(t))
        else
            traitAtualLabel:updateText("Trait atual: Nenhuma")
        end
        -- filtra traits disponíveis pro boneco
        local available = getTraitsForUnit(value)
        LapoHub:AddDropdown("Trait's", {
            text    = "Trait desejada",
            options = available,
            default = 1,
            callback = function(_, v)
                selectedTrait = v
                local d = TraitData[v]
                if d then
                    LapoHub:Notify({
                        title = "[" .. d.Rarity .. "] " .. v,
                        content = d.Desc,
                        duration = 4,
                    })
                end
            end,
        })
    end,
})

-- Dropdown trait desejada (inicial)
local function initTraitDropdown()
    local available = getTraitsForUnit(selectedUnit)
    selectedTrait = available[1]
    LapoHub:AddDropdown("Trait's", {
        text    = "Trait desejada",
        options = available,
        default = 1,
        callback = function(_, value)
            selectedTrait = value
            local d = TraitData[value]
            if d then
                LapoHub:Notify({
                    title = "[" .. d.Rarity .. "] " .. value,
                    content = d.Desc,
                    duration = 4,
                })
            end
        end,
    })
end
initTraitDropdown()

-- atualiza trait atual do primeiro boneco
local firstTrait = getUnitTrait(selectedUnit)
if firstTrait and firstTrait ~= "" then
    traitAtualLabel:updateText("Trait atual: " .. tostring(firstTrait))
end

LapoHub:AddSeparator("Trait's")

-- Botão girar 1x
LapoHub:AddButton("Trait's", {
    text = "Girar 1x",
    callback = function()
        if not selectedUnit then
            LapoHub:Notify({ title = "Reroll", content = "Selecione um boneco.", duration = 3 })
            return
        end
        doRoll(selectedRRType, selectedUnit)
        -- atualiza trait atual depois do roll
        task.wait(0.3)
        local t = getUnitTrait(selectedUnit)
        if t and t ~= "" then
            traitAtualLabel:updateText("Trait atual: " .. tostring(t))
        else
            traitAtualLabel:updateText("Trait atual: Nenhuma")
        end
    end,
})

-- Toggle auto-roll
LapoHub:AddToggle("Trait's", {
    text    = "Auto até pegar a trait",
    default = false,
    callback = function(state)
        autoRolling = state
        if not state or not selectedUnit or not selectedTrait or selectedTrait == "" then
            if state then
                LapoHub:Notify({ title = "Auto", content = "Selecione boneco e trait.", duration = 3 })
                autoRolling = false
            end
            return
        end

        task.spawn(function()
            local tries = 0
            while autoRolling do
                local current = getUnitTrait(selectedUnit)
                if current and tostring(current) == selectedTrait then
                    autoRolling = false
                    LapoHub:Notify({
                        title = "Completo!",
                        content = ("'%s' em %d tries"):format(selectedTrait, tries),
                        duration = 6,
                    })
                    break
                end
                local ok = doRoll(selectedRRType, selectedUnit)
                tries += 1
                if not ok then autoRolling = false; break end
                task.wait(0.6)
            end
        end)
    end,
})

LapoHub:AddSeparator("Trait's")

LapoHub:AddButton("Trait's", {
    text = "Ver tokens",
    callback = showCounts,
})

-- ====== SETTINGS ======
LapoHub:AddParagraph("Settings", { text = "Lapo Hub X © ENI — for LO" })
LapoHub:AddParagraph("Settings", { text = "Toggle: K | Synapse Classic Theme" })

showCounts()
return LapoHub
