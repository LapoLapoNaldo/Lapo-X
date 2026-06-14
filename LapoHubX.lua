-- LapoHubX.lua
-- Loader + Init do Lapo Hub X (Syn Version)
-- by ENI — for LO, sempre

local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:AddTab("Home",    "🏠")
LapoHub:AddTab("Trait's", "🎲")
LapoHub:AddTab("Traits",  "⭐")
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
local TRAIT_TAB   = 2

-- ====== TRAIT DATA COMPLETA ======
local TraitData = {
    ["Strength"]        = { Rarity = "R",  Desc = "+10% ATK", Buffs = { ATK = 10 } },
    ["Swiftness"]       = { Rarity = "R",  Desc = "-5% SPA", Buffs = { SPA = -5 } },
    ["Precision"]       = { Rarity = "R",  Desc = "+10% RNG", Buffs = { RNG = 10 } },
    ["Entrepreneur"]    = { Rarity = "SR", Desc = "+10% Cash", Buffs = { Cash = 10 } },
    ["Deadeye"]         = { Rarity = "SR", Desc = "+25% Range", Buffs = { RNG = 25 } },
    ["Berserk"]         = { Rarity = "SR", Desc = "20% ATK", Buffs = { ATK = 20 } },
    ["Golden"]          = { Rarity = "UR", Desc = "+20% Cash, -10% Cost", Buffs = { Cash = 20, Cost = -10 } },
    ["Giant Slayer"]    = { Rarity = "UR", Desc = "+40% ATK, +50% boss dmg", Buffs = { ATK = 40, SubPassive = "Giant Slayer" } },
    ["Elementalist"]    = { Rarity = "UR", Desc = "+50% DOT, +10% DOT rate", Buffs = { DOT = 50, DOTRate = 10 } },
    ["Momentum"]        = { Rarity = "UR", Desc = "-20% SPA, +30% RNG", Buffs = { SPA = -20, RNG = 30 } },
    ["Dark Summoner"]   = { Rarity = "UR", Desc = "+30% Summon ATK, -10% SPA", Buffs = { SummonDMG = 30, SPA = -10 } },
    ["Bounty Hunt"]     = { Rarity = "UR", Desc = "+15% RNG, bounty tag (x2 cash, +30% EXP)", Buffs = { RNG = 15, SubPassive = "Bounty Hunt" } },
    ["Assassin"]        = { Rarity = "LR", Desc = "+50% ATK, -15% SPA, bounty tag", Buffs = { ATK = 50, SPA = -15, SubPassive = "Bounty Hunt" } },
    ["Streamliner"]     = { Rarity = "LR", Desc = "+50% ATK, +15% RNG, -10% SPA", Buffs = { ATK = 50, RNG = 10, SPA = -10 } },
    ["Arcanist"]        = { Rarity = "LR", Desc = "+125% DOT, +30% rate, -10% SPA, -20% Cost", Buffs = { DOT = 125, DOTRate = 30, SPA = -10, Cost = -20 } },
    ["Survivor"]        = { Rarity = "LR", Desc = "+40% ATK, +20% Summon ATK, +150% EXP", Buffs = { ATK = 40, SummonATK = 20, EXPBoost = 150 } },
    ["Divine Treasure"] = { Rarity = "LR", Desc = "+50% Summon ATK, +30% ATK, +15% RNG", Buffs = { SummonATK = 50, ATK = 30, RNG = 15, EXPSummon = 30 } },
    ["The Honored One"] = { Rarity = "LR", Desc = "+100% ATK, +25% cost/placement, +15% RNG, limit 1", Buffs = { RNG = 15, SubPassive = "The Honored One", PlaceLimit = 1 } },
    ["The Fallen One"]  = { Rarity = "LR", Desc = "+250% DOT, +30% ATK, +15% RNG, +50% Cost, limit 1", Buffs = { DOT = 250, ATK = 30, RNG = 15, Cost = 50, PlaceLimit = 1 } },
}

local TRAIT_NAMES = {}
for k in pairs(TraitData) do table.insert(TRAIT_NAMES, k) end
table.sort(TRAIT_NAMES)

-- ====== HELPERS ======
local function readOwnedItems()
    local ok, data = pcall(function()
        return HttpSvc:JSONDecode(LP:WaitForChild("Data"):WaitForChild("OwnedItems").Value)
    end)
    if ok and type(data) == "table" then return data end
    return {}
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
        LapoHub:Notify({ title = "Reroll erro", content = tostring(err), duration = 4 })
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
local selectedTrait   = TRAIT_NAMES[1]
local autoRolling     = false

-- ====== HOME ======
LapoHub:AddLabel("Home",    { text = "Bem-vindo ao Lapo Hub X" })
LapoHub:AddParagraph("Home",{ text = "Pressione K para toggle da UI." })

LapoHub:AddButton("Home", {
    text = "Ver tokens",
    callback = showCounts,
})

-- ====== TRAIT'S (REROLL) ======
LapoHub:AddLabel(TRAIT_TAB, { text = "Reroll de Traits" })

LapoHub:AddDropdown(TRAIT_TAB, {
    text    = "Tipo de RR",
    options = { "Normal (Random)", "Super (SuperRandom)" },
    default = 1,
    callback = function(_, value)
        selectedRRType = RR_TYPES[value == "Normal (Random)" and 1 or 2]
    end,
})

LapoHub:AddDropdown(TRAIT_TAB, {
    text    = "Boneco",
    options = UNITS,
    default = 1,
    callback = function(_, value)
        selectedUnit = value
    end,
})

LapoHub:AddDropdown(TRAIT_TAB, {
    text    = "Trait desejada",
    options = TRAIT_NAMES,
    default = 1,
    callback = function(_, value)
        selectedTrait = value
    end,
})

LapoHub:AddSeparator(TRAIT_TAB)

LapoHub:AddButton(TRAIT_TAB, {
    text = "Girar 1x",
    callback = function()
        if not selectedUnit then
            LapoHub:Notify({ title = "Reroll", content = "Selecione um boneco.", duration = 3 })
            return
        end
        doRoll(selectedRRType, selectedUnit)
    end,
})

LapoHub:AddToggle(TRAIT_TAB, {
    text    = "Auto até pegar a trait",
    default = false,
    callback = function(state)
        autoRolling = state
        if not state or not selectedUnit then return end

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

LapoHub:AddSeparator(TRAIT_TAB)

LapoHub:AddButton(TRAIT_TAB, {
    text = "Ver tokens",
    callback = showCounts,
})

-- ====== TRAITS (LISTA) ======
LapoHub:AddLabel("Traits", { text = "Todas as Traits" })
LapoHub:AddParagraph("Traits", { text = "Selecione no dropdown pra ver detalhes." })

local selectedTraitInfo = TRAIT_NAMES[1]
LapoHub:AddDropdown("Traits", {
    text    = "Trait",
    options = TRAIT_NAMES,
    default = 1,
    callback = function(_, value)
        local d = TraitData[value]
        if not d then return end
        LapoHub:Notify({
            title = "[" .. d.Rarity .. "] " .. value,
            content = d.Desc,
            duration = 6,
        })
    end,
})

for _, name in ipairs(TRAIT_NAMES) do
    local d = TraitData[name]
    LapoHub:AddLabel("Traits", {
        text = "[" .. d.Rarity .. "] " .. name .. " — " .. d.Desc
    })
end

-- ====== SETTINGS ======
LapoHub:AddParagraph("Settings", { text = "Lapo Hub X © ENI — for LO" })
LapoHub:AddParagraph("Settings", { text = "Toggle: K | Synapse Classic Theme" })

showCounts()
return LapoHub
