local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local RemoteFolder = ReplicatedStorage:WaitForChild("Remote")
local AbilityRemote = RemoteFolder:WaitForChild("UnitAbility")
local WorkspaceUnits = Workspace:WaitForChild("Units")

-- Carrega a nova biblioteca LapoHub X (tenta ler localmente primeiro para desenvolvimento/correções)
local LapoHub
local success, err = pcall(function()
    return loadstring(readfile("Library.lua"))()
end)
if not success or not LapoHub then
    LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()
end

LapoHub:AddTab("Auto Habilidades", "")
LapoHub:AddTab("Skills Rápidas", "")
LapoHub:AddTab("Funções Starkei", "")

LapoHub:Init({
    Title     = "Lapo Hub X - Habilidades",
    ToggleKey = "K",
})

LapoHub:SetUser("LapoLapoNaldo", "Lapo Newba")

-- Estado
local selectedUnit, selectedSkill
local starkeiTarget
local autoUse = false
local autoStarkei = false
local UnitDropdown, SkillDropdown, StarkeiTargetDropdown

-- Utils
local function IsOwnedUnit(instance)
    local info = instance:FindFirstChild("Info")
    local owner = info and info:FindFirstChild("Owner")
    return owner and owner.Value == LocalPlayer.Name
end

local function GetPlayerUnits()
    local list = {}
    if WorkspaceUnits then
        for _, unit in ipairs(WorkspaceUnits:GetChildren()) do
            if IsOwnedUnit(unit) then 
                table.insert(list, unit.Name) 
            end
        end
    end
    table.sort(list)
    if #list == 0 then
        return {"None"}
    end
    return list
end

local function UniqueList(list)
    local seen, out = {}, {}
    for _, v in ipairs(list) do
        if not seen[v] then
            seen[v] = true
            table.insert(out, v)
        end
    end
    return out
end

-- CARREGADOR DINÂMICO DE SKILLS (Puxa do Abilities_Data ou direto das Units)
local function LoadActiveSkills()
    local loadedSkills = {}
    local seenSkills = {}
    
    -- Fallbacks caso falhe o require do game
    local fallbackSkills = {
        "10 Year","1000 Year","120% Power",
        "Abyssal Worm","Absolute Hypnosis","Absolute Reconstruction","Actualization Revert",
        "Ado Buff","Ado Buff II","Adolla Burst","Affinity Change","Agidy","All Out","All Seeing Eyes",
        "Allas Workshop","Aleph","Amulet Angel","Amulet Clover","Amulet Devil","Amulet Dia",
        "Amulet Fortune","Amulet Heart","Amulet Jewel Heart","Amulet Spade","Angel Rewind","Angel Revive",
        "Arabaki","Arise","Armadura Fairy","Ataraxia Armor","Atelier Logic","Athiel",
        "Attack Position","Attempt Drain","Base Armor","Belial","Berserker Rage","Berserk Shirou",
        "Bet","Bigbang Violet","Black Wing Armor","Blossom Heal","Blood Moon","Bloodcurdle",
        "Bloodlust","Blue Rose","Blue Tech","Cauterization","Calamity Rain","Charisma of Desire",
        "Chocolate Beam","Clear Heart Clothing","Combat Stance","Conqueror","Copy Slot1","Copy Slot2",
        "Copy Slot3","Copy Slot4","Copy Slot5","Copy Slot6","Cotaro","Cotaro & Others",
        "Cotaro & Tochi","Crumble Speech","Crystal Atelier","Dalet","Dark Swordsman","Dark Swordsman & Ruffy",
        "Dark Swordsman & Uchigo","DarkBeardActive","Death Dragon Explosion","Death Line","Death Shot",
        "Defensive Adaptation","Demon","Detonate","Devils Tune","Die Speech","Divine Treasure",
        "Doge Protection","Domination","Doomshriek","Dragon Heart","Dragon Meal","Dragon Shield",
        "Draconic Awaken","Dragonic Force","DragonRewind","DragonTS","Drain","Drain II",
        "Dress","Durandal","Emotional","Enuma Elish","Evil Domain","Evil Domain EX",
        "Explode Speech","Faulty Atomic","Fatal Point Attack","Fetch Failnaught","Final Art","Final Mugetsu",
        "Flame Empress Armor","Flight Armor","Flower Shirou","Flowers on Earth","Friction Plundering","Full Force",
        "Full Incantation Kurohitsugi","Furioso","Gamble Queen All In","Gamble Queen Card","Gamble Queen Food",
        "Gamble Queen Jack","Gamble Queen Pachinko","Gimel","Go Beyond","God Sacrifice","Golden Apple",
        "Golden Recovery","Golden Theater","Great Seal","Hades Door","Hairpin","Hakai",
        "Hakari Domain","Halloween","Heal Bubble","Heal Hado","Heart Speeders","Heavens Wheel Armor",
        "Heavy Sand Storm","Hei","Het","Hogyoku Evolution","Hogyoku Evolution II","Hogyoku Evolution III",
        "Hollow Mask","Holy Armor","Horn Of Rewind","HunterKid End","I am Atomic","I am Atomic Radar",
        "I am Atomic Rain","I am Atomic Sword","I am Recovery Atomic","I am the All Range Atomic","Ice Curse",
        "Ice Hell","IceAge Bankai","Idol Buff","Illusion Ninja Clone","Im ATOMIC","Immortal",
        "Infinite Blade World","Itto Ashura","Itto Shura","Judge Domain","Justice Hall","Kaioken",
        "Kamui Attack","Kannonbiraki Benihime Aratame","Kill","Kill all","King Treasure Dainsleif","King Treasure Enkidu",
        "King Treasure Halberd","King Treasure Ig-Alima","King Treasure Merodach","King Treasure True Nine Lives",
        "Kings Engine","Knife Shirou","Koji","Koji & Kongkun","Koji & Tochi","Konghan SSJ2",
        "Kongkun","Kongkun & Ruffy","Kongkun & Uchigo","Kongkun[GT] SSJ","Kriezer Training","Kroly Rage",
        "Kurama Buff","Kurama Buff II","Kurohitsugi","Kyoka Suigetsu","Lai Rhyme Goodfellow","Lightning Armor",
        "Lightning Empress Armor","Luminosite Eternelle","Magical Sea","Magical Splash Flare","Magic Mark",
        "Magnet Prison","Malevolent Shrine","Mana Buff","Marble Phantasm","Mass Manipulation","Memory of Londinium",
        "Metamorphosis","Meteor Volcano","Minazuki","Mook Workshop","Morning Star Armor","Nakagami Armor",
        "Next Generation","Night Queen","Night Sky","One Meteor","Open Heart Full Volume","Orbital Sacrifice",
        "Orches TS","Orotario","Overdrive","Parody Combo","Perfect Susanoo","Perfect Susanoo [First]",
        "Perfect Susanoo [Last]","Perfect Susanoo First","Perfect Susanoo Last","Persona Alice","Persona Raoul",
        "Persona Seth","Persona Yoshitsune","Phantoms Dance","Phantoms Dance EX","Phantoms Rampage","Phantoms Rampage EX",
        "Phantoms Show","Phantoms Show EX","Phosphor","Plasmatic Robe","Pom pom Pom","Power Wish",
        "Pressure Shun","Protection Barrier","Protection Wish","Pure Armor","Purgatory Armor","Purple Tech",
        "Qemetiel","Quincy Force","Ragnarok","Rain Shards","Ranga Workshop","Ray Horizon",
        "Recovery Angel","Red Eye Sword","Red Rampage","Red Tech","Remake Honey","Remake Honey Special",
        "Return By Death","Return To Zero","Reverse Cursed","Reverse Gravity","Reverted Bankai","Reverted World",
        "Revitalize Soul","Revive","Rewind Punch","Rho Ias","Rich Wish","River Of Death",
        "Road of Stars","Road Roller","Roadless Camelot","Robe of Yuen","Rock and Roll","Round of Avalon",
        "Ruffy","Ruffy & Koji","Rukia Dance","Ruler Blessing","Rumbling","Rupture Sword",
        "Sacrifice Ghost","Sacrifice of Pride","Sakura Field","Sandevistan","Savior of the AWTD","Savior Spear",
        "Second Generation","Serious Punch","Serious Squirt Gun","Shadow Domain","Shadow TS","Shambles",
        "Shoko Power Up","Sis","Solo Act","Spacequake","Star Platinum TS","Stars in Heaven",
        "Stellar Gravity","Summon Beelzebub","Sun Wheel","Super Spirit Bomb","Supernova Trap","Swap Ink",
        "Sweet Applique","Sword Shirou","Tamamo","Tet","The Fascinating Horizon","The Grappler Buff",
        "The Greatest Wall","Third Generation","Third Impact","Tides of Time","Time Lock","Time Rewind",
        "Time Skip","Time Traveler","Tochi","Tochi & Others","Trust","Twinkle Shield",
        "Two Meteors","Uchigo","Uchigo & Tochi","Ultimate Blade Work","Unachievable","Universe Hope Cloak",
        "UQ Revive","Usage 1000 years","Uzumaki","Vav","Veshikun Taunting","Vimana",
        "Virtual Black Hole","Vitality Sacrifice","Void Domain","Void Tech","Void Tech 0_2s","Volcano Domain",
        "War Devil Aquarium Spear","War Devil Room","War Devil Spinal Cord","War Devil Uniform Sword",
        "Weapon Combo","Wheels Industry","World Flower","Youre Next","Yud","Yud Aleph",
        "Yud Bet","Za Warudo","Zayin","Zelkova Workshop"
    }

    for _, fallback in ipairs(fallbackSkills) do
        if not seenSkills[fallback] then
            seenSkills[fallback] = true
            table.insert(loadedSkills, fallback)
        end
    end

    -- 1. Método: Tentar extrair do Abilities_Data via debug.getupvalue (super rápido se disponível)
    local abilitiesDataModule = ReplicatedStorage:FindFirstChild("Modules")
        and ReplicatedStorage.Modules:FindFirstChild("UnitSystems")
        and ReplicatedStorage.Modules.UnitSystems:FindFirstChild("Stats")
        and ReplicatedStorage.Modules.UnitSystems.Stats:FindFirstChild("Abilities_Data")

    if abilitiesDataModule then
        local okData, abilitiesData = pcall(require, abilitiesDataModule)
        if okData and abilitiesData and type(abilitiesData.Get) == "function" and debug.getupvalue then
            local idx = 1
            while true do
                local okCall, name, val = pcall(debug.getupvalue, abilitiesData.Get, idx)
                if not okCall or not name then break end
                if type(val) == "table" then
                    for skillName in pairs(val) do
                        if type(skillName) == "string" and not seenSkills[skillName] then
                            seenSkills[skillName] = true
                            table.insert(loadedSkills, skillName)
                        end
                    end
                end
                idx = idx + 1
            end
        end
    end

    -- 2. Método: Iterar sobre todas as Units no game ReplicatedStorage (Seguro e dinâmico)
    local UnitsFolder = ReplicatedStorage:FindFirstChild("Modules")
        and ReplicatedStorage.Modules:FindFirstChild("UnitSystems")
        and ReplicatedStorage.Modules.UnitSystems:FindFirstChild("Stats")
        and ReplicatedStorage.Modules.UnitSystems.Stats:FindFirstChild("Units")

    if UnitsFolder then
        for _, moduleScript in ipairs(UnitsFolder:GetChildren()) do
            if moduleScript:IsA("ModuleScript") then
                local ok, result = pcall(function()
                    local required = require(moduleScript)
                    if type(required) == "function" then
                        required = required()
                    end
                    return required
                end)
                
                if ok and type(result) == "table" and result.Status then
                    for _, status in ipairs(result.Status) do
                        local passive = status.Passive
                        if passive and (passive.Type == "Manual" and passive.Skills ~= nil) then
                            for _, skillInfo in ipairs(passive.Skills) do
                                local skillName = skillInfo.Skill or passive.Name
                                if skillName and not seenSkills[skillName] then
                                    seenSkills[skillName] = true
                                    table.insert(loadedSkills, skillName)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    table.sort(loadedSkills)
    return loadedSkills
end

-- Inicializa lista de skills
local AllSkills = LoadActiveSkills()
local allUnits = GetPlayerUnits()

if #allUnits > 0 then
    selectedUnit = allUnits[1]
    starkeiTarget = allUnits[1]
end

if #AllSkills > 0 then
    selectedSkill = AllSkills[1]
end

local function RefreshAllDropdowns()
    allUnits = GetPlayerUnits()
    local uniqueUnits = UniqueList(allUnits)
    
    if UnitDropdown then
        UnitDropdown:Set(uniqueUnits)
    end
    if StarkeiTargetDropdown then
        StarkeiTargetDropdown:Set(uniqueUnits)
    end
    
    LapoHub:Notify({ title = "Atualizar Unidades", content = "Encontradas " .. #uniqueUnits .. " unidades!", duration = 2 })
end

local function RefreshGameSkills()
    AllSkills = LoadActiveSkills()
    if SkillDropdown then
        SkillDropdown:Set(AllSkills)
    end
    LapoHub:Notify({ title = "Skills Carregadas", content = "Puxadas " .. #AllSkills .. " skills ativas do jogo!", duration = 3 })
end

local function FireAbility(unitName, skillName)
    if not unitName or unitName == "" or unitName == "None" then return false, "Selecione uma unidade" end
    if not skillName or skillName == "" or skillName == "None" or skillName == "(no match)" then
        return false, "Selecione uma skill"
    end
    local unit = WorkspaceUnits:FindFirstChild(unitName)
    if not unit then return false, "Unidade não encontrada no mapa" end
    local owner = unit:FindFirstChild("Info") and unit.Info:FindFirstChild("Owner")
    if not (owner and owner.Value == LocalPlayer.Name) then return false, "Esta unidade não te pertence" end
    
    local ok, err = pcall(function()
        AbilityRemote:FireServer(skillName, unit)
    end)
    if not ok then return false, tostring(err) end
    return true
end

-- ====== CONSTRUÇÃO DA INTERFACE ======

LapoHub:AddButton("Auto Habilidades", {
    text = "🔄 Atualizar Unidades",
    callback = function()
        RefreshAllDropdowns()
    end
})

LapoHub:AddButton("Auto Habilidades", {
    text = "🌐 Escanear Habilidades Ativas",
    callback = function()
        RefreshGameSkills()
    end
})

UnitDropdown = LapoHub:AddDropdown("Auto Habilidades", {
    text = "Selecionar Unidade",
    options = allUnits,
    default = 1,
    callback = function(_, value)
        selectedUnit = value
    end
})

LapoHub:AddTextBox("Auto Habilidades", {
    text = "🔍 Buscar Habilidades",
    placeholder = "Digite para filtrar...",
    callback = function(text)
        local q = string.lower(text or "")
        if q == "" then
            if SkillDropdown then SkillDropdown:Set(AllSkills) end
            return
        end
        local filtered = {}
        for _, skillName in ipairs(AllSkills) do
            if string.find(string.lower(skillName), q, 1, true) then
                table.insert(filtered, skillName)
            end
        end
        if #filtered == 0 then
            filtered = {"(sem correspondência)"}
        end
        if SkillDropdown then SkillDropdown:Set(filtered) end
    end
})

SkillDropdown = LapoHub:AddDropdown("Auto Habilidades", {
    text = "Selecionar Habilidade",
    options = AllSkills,
    default = 1,
    callback = function(_, value)
        selectedSkill = value
    end
})

LapoHub:AddToggle("Auto Habilidades", {
    text = "Auto Usar Habilidade Selecionada",
    default = false,
    callback = function(state)
        autoUse = state
        if state then
            LapoHub:Notify({ title = "Auto Skill", content = "Iniciado (loop a cada 1s)", duration = 3 })
            task.spawn(function()
                while autoUse do
                    if selectedUnit and selectedSkill and selectedSkill ~= "None" and selectedSkill ~= "(sem correspondência)" and selectedSkill ~= "(no match)" then
                        local ok, err = FireAbility(selectedUnit, selectedSkill)
                        if not ok and err then
                            LapoHub:Notify({ title = "Erro Auto Skill", content = err, duration = 2 })
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            LapoHub:Notify({ title = "Auto Skill", content = "Parado", duration = 2 })
        end
    end
})

LapoHub:AddButton("Auto Habilidades", {
    text = "⚡ Usar Habilidade Manualmente",
    callback = function()
        if not selectedUnit or selectedUnit == "None" then
            LapoHub:Notify({ title = "Erro", content = "Selecione uma unidade primeiro", duration = 2 })
            return
        end
        if not selectedSkill or selectedSkill == "None" or selectedSkill == "(sem correspondência)" or selectedSkill == "(no match)" then
            LapoHub:Notify({ title = "Erro", content = "Selecione uma skill primeiro", duration = 2 })
            return
        end
        local ok, err = FireAbility(selectedUnit, selectedSkill)
        if ok then
            LapoHub:Notify({ title = "Sucesso", content = "Skill " .. selectedSkill .. " usada!", duration = 2 })
        else
            LapoHub:Notify({ title = "Erro", content = err or "Falha ao usar skill", duration = 3 })
        end
    end
})

LapoHub:AddSeparator("Skills Rápidas")
LapoHub:AddLabel("Skills Rápidas", { text = "⭐ Seleção Rápida de Melhores Buffs" })

local BuffButtons = {"Road of Stars", "War Devil Uniform Sword", "Overdrive", "Kaioken", "Flight Armor", "Hakari Domain"}
for _, skill in ipairs(BuffButtons) do
    LapoHub:AddButton("Skills Rápidas", {
        text = "Usar " .. skill,
        callback = function()
            if not selectedUnit or selectedUnit == "None" then
                LapoHub:Notify({ title = "Erro", content = "Selecione uma unidade primeiro", duration = 2 })
                return
            end
            local ok, err = FireAbility(selectedUnit, skill)
            if ok then
                LapoHub:Notify({ title = "Sucesso", content = "Skill " .. skill .. " usada!", duration = 2 })
            else
                LapoHub:Notify({ title = "Erro", content = err or "Falha ao usar " .. skill, duration = 3 })
            end
        end
    })
end

LapoHub:AddSeparator("Funções Starkei")
LapoHub:AddLabel("Funções Starkei", { text = "💫 Funções de Suporte Starkei" })

LapoHub:AddButton("Funções Starkei", {
    text = "🔄 Atualizar Unidades (Starkei)",
    callback = function()
        RefreshAllDropdowns()
    end
})

StarkeiTargetDropdown = LapoHub:AddDropdown("Funções Starkei", {
    text = "Selecionar Unidade para Starkei",
    options = allUnits,
    default = 1,
    callback = function(_, value)
        starkeiTarget = value
    end
})

LapoHub:AddToggle("Funções Starkei", {
    text = "Auto Usar Habilidade Starkei no Alvo",
    default = false,
    callback = function(state)
        autoStarkei = state
        if state then
            LapoHub:Notify({ title = "Auto Starkei", content = "Iniciado (loop a cada 1s)", duration = 3 })
            task.spawn(function()
                while autoStarkei do
                    if starkeiTarget and starkeiTarget ~= "None" then
                        local ok, err = FireAbility(starkeiTarget, "Savior of the AWTD")
                        if not ok and err then
                            LapoHub:Notify({ title = "Erro Auto Starkei", content = err, duration = 2 })
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            LapoHub:Notify({ title = "Auto Starkei", content = "Parado", duration = 2 })
        end
    end
})

LapoHub:AddButton("Funções Starkei", {
    text = "Converter Unidade Selecionada para Starkei",
    callback = function()
        if not selectedUnit or selectedUnit == "None" then
            LapoHub:Notify({ title = "Erro", content = "Selecione uma unidade primeiro", duration = 2 })
            return
        end
        local unit = WorkspaceUnits:FindFirstChild(selectedUnit)
        if not unit then
            LapoHub:Notify({ title = "Erro", content = "Unidade não encontrada no mapa", duration = 2 })
            return
        end
        local owner = unit:FindFirstChild("Info") and unit.Info:FindFirstChild("Owner")
        if not (owner and owner.Value == LocalPlayer.Name) then
            LapoHub:Notify({ title = "Erro", content = "Esta unidade não te pertence", duration = 2 })
            return
        end

        local oldName = unit.Name
        unit.Name = "Starkei"
        LapoHub:Notify({ title = "Convertido", content = oldName .. " → Starkei", duration = 3 })

        task.wait(0.5)
        RefreshAllDropdowns()

        if WorkspaceUnits:FindFirstChild("Starkei") then
            selectedUnit = "Starkei"
            starkeiTarget = "Starkei"
            if UnitDropdown then UnitDropdown:Set("Starkei") end
            if StarkeiTargetDropdown then StarkeiTargetDropdown:Set("Starkei") end
        end
    end
})

-- Notificação inicial
LapoHub:Notify({ title = "Lapo Hub X - Habilidades", content = "Script inicializado! Carregadas " .. #AllSkills .. " skills.", duration = 4 })
