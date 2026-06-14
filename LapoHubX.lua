-- ============================================================
-- ANTI-KICK / ANTI-BAN  (roda primeiro, antes do hub carregar)
-- ============================================================
do
    local BLOCK = "LoadingSceneEnd"   -- remote que dispara o check de ban

    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if not checkcaller()
           and (m == "FireServer" or m == "InvokeServer")
           and self.Name == BLOCK then
            return nil          -- engole: servidor nunca recebe o "carreguei"
        end
        return old(self, ...)
    end))

    print("[anti-kick] " .. BLOCK .. " bloqueado — servidor nunca roda o check de lobby")
end

-- ============================================================
-- HUB
-- ============================================================
local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:AddTab("Home",     "🏠")
LapoHub:AddTab("Trait's",  "🎲")   -- tab nova (index 2)

LapoHub:Init({
    Title     = "Lapo Hub X",
    ToggleKey = "K",
})

LapoHub:SetUser("LapoLapoNaldo", "Lapo Newba")

-- ============================================================
-- TRAIT REROLL
-- ============================================================
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local HttpSvc = game:GetService("HttpService")
local LP      = Players.LocalPlayer

local TRAIT_TAB = 2  -- index da tab "Trait's"

-- remote de trait
local traitRemote = RS:WaitForChild("Remote"):WaitForChild("traitRemote")

-- tipos de RR (texto cru -> valor que o servidor espera)
local RR_TYPES = { "Random", "SuperRandom" }   -- [1] normal, [2] super

-- lista de traits desejadas (ajuste/adicione as que existirem no jogo)
local TRAITS = {
    "Blue Flames",
    "Celestial",
    "Divine",
    "Monarch",
    "Overlord",
    "Ethereal",
    "Cosmic",
}

-- ---------- estado ----------
local selectedRRType = RR_TYPES[1]     -- default: Random
local selectedUnit   = nil             -- boneco selecionado
local selectedTrait  = TRAITS[1]       -- trait alvo
local autoRolling    = false

-- ---------- helpers ----------
local function readOwnedItems()
    local ok, data = pcall(function()
        return HttpSvc:JSONDecode(LP:WaitForChild("Data"):WaitForChild("OwnedItems").Value)
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

-- lê a trait atual do boneco selecionado (pra saber quando parar)
-- OBS: ajuste o caminho conforme onde o jogo guarda a trait da unit.
local function getUnitTrait(unitName)
    local ok, val = pcall(function()
        local units = LP.Data:FindFirstChild("OwnedUnits")
        if not units then return nil end
        local u = units:FindFirstChild(unitName)
        if not u then return nil end
        -- tenta valor direto, senão JSON
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

-- popula a lista de bonecos a partir de OwnedUnits (fallback se vazio)
local function buildUnitList()
    local list = {}
    local ok = pcall(function()
        local units = LP:WaitForChild("Data"):WaitForChild("OwnedUnits")
        for _, c in ipairs(units:GetChildren()) do
            table.insert(list, c.Name)
        end
    end)
    if not ok or #list == 0 then
        list = { "Blue Flames" }  -- fallback do seu exemplo
    end
    table.sort(list)
    return list
end

local UNITS = buildUnitList()
selectedUnit = UNITS[1]

-- dispara UM reroll
local function doRoll()
    if not selectedUnit then
        LapoHub:Notify({ title = "Reroll", content = "Selecione um boneco primeiro.", duration = 3 })
        return
    end
    local args = { selectedRRType, selectedUnit }
    local ok, err = pcall(function()
        return traitRemote:InvokeServer(unpack(args))
    end)
    if not ok then
        LapoHub:Notify({ title = "Reroll erro", content = tostring(err), duration = 4 })
    end
    return ok
end

-- contagem de tokens
local function showCounts()
    local items = readOwnedItems()
    local normal = items["Celestial Crystal"] or 0
    local super  = items["Super Celestial Crystal"] or 0
    LapoHub:Notify({
        title   = "Reroll Tokens",
        content = ("Trait RR: %d  |  Super RR: %d"):format(normal, super),
        duration = 5,
    })
end

-- ============================================================
-- WIDGETS
-- ============================================================
LapoHub:AddDropdown(TRAIT_TAB, {
    text    = "Tipo de RR",
    options = { "Normal (Random)", "Super (SuperRandom)" },
    default = 1,
    callback = function(idx)
        selectedRRType = RR_TYPES[idx] or RR_TYPES[1]
    end,
})

LapoHub:AddDropdown(TRAIT_TAB, {
    text    = "Boneco",
    options = UNITS,
    default = 1,
    search  = true,
    callback = function(idx, value)
        selectedUnit = value or UNITS[idx]
    end,
})

LapoHub:AddDropdown(TRAIT_TAB, {
    text    = "Trait desejada",
    options = TRAITS,
    default = 1,
    search  = true,
    callback = function(idx, value)
        selectedTrait = value or TRAITS[idx]
    end,
})

LapoHub:AddSeparator(TRAIT_TAB)

LapoHub:AddButton(TRAIT_TAB, {
    text = "Girar 1x (single)",
    callback = function()
        doRoll()
    end,
})

LapoHub:AddToggle(TRAIT_TAB, {
    text    = "Auto-roll até pegar a trait",
    default = false,
    callback = function(state)
        autoRolling = state
        if not state then return end

        task.spawn(function()
            local tries = 0
            while autoRolling do
                -- já está com a trait? para.
                local current = getUnitTrait(selectedUnit)
                if current and tostring(current) == selectedTrait then
                    autoRolling = false
                    LapoHub:Notify({
                        title = "Reroll completo",
                        content = ("Peguei '%s' em %d rolls."):format(selectedTrait, tries),
                        duration = 6,
                    })
                    break
                end

                local ok = doRoll()
                tries += 1
                if not ok then
                    autoRolling = false
                    break
                end
                task.wait(0.6)  -- respiro pro servidor processar (ajuste se tomar throttle)
            end
        end)
    end,
})

LapoHub:AddSeparator(TRAIT_TAB)

LapoHub:AddButton(TRAIT_TAB, {
    text = "Ver contagem de tokens",
    callback = function()
        showCounts()
    end,
})

-- aviso inicial com a contagem
showCounts()

return LapoHub
