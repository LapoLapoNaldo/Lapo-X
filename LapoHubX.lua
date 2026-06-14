local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:Init({
    Title = "Lapo Hub X",
    ToggleKey = "End"
})

LapoHub:AddTab("Home", "🏠")
LapoHub:AddTab("Scripts", "📜")
LapoHub:AddTab("Settings", "⚙")

LapoHub:SetUser("LapoLapoNaldo", "Lapo Newba")
LapoHub:SetUserCallback(function(name, rank)
    LapoHub:Notify({title = "User", content = name .. " • " .. rank, duration = 3})
end)

-- exemplo de botão
LapoHub:AddButton("Home", {
    text = "Executar Script",
    callback = function()
        LapoHub:Notify({title = "Status", content = "Script executado!", duration = 3})
    end
})

-- exemplo de toggle
LapoHub:AddToggle("Home", {
    text = "Auto Farm",
    default = false,
    callback = function(v)
        print("Auto Farm:", v)
    end
})

-- exemplo de slider
LapoHub:AddSlider("Scripts", {
    text = "Velocidade",
    min = 1,
    max = 100,
    default = 50,
    callback = function(v)
        print("Speed:", v)
    end
})

-- exemplo de dropdown
LapoHub:AddDropdown("Settings", {
    text = "Tema",
    options = {"Dark", "Light", "Synapse Classic"},
    default = 3,
    callback = function(opt)
        print("Tema:", opt)
    end
})

-- exemplo de textbox
LapoHub:AddTextBox("Settings", {
    text = "Script URL",
    placeholder = "https://pastebin.com/raw/...",
    callback = function(val)
        print("URL:", val)
    end
})

-- exemplo de label
LapoHub:AddLabel("Home", {
    text = "Bem-vindo ao Lapo Hub X"
})

-- exemplo de parágrafo
LapoHub:AddParagraph("Home", {
    text = "Use o botão End para mostrar/esconder a UI."
})
