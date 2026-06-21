# Lapo Library X

Uma biblioteca de interface de usuário para Roblox construída sobre a Drawing API dos executores. Renderização por overlay, sem depender de CoreGui/PlayerGui.

Para ver a documentação interativa completa com o simulador de componentes, acesse a pasta `/docs` no navegador.

## Carregamento (Local com Fallback GitHub)

```lua
local LapoHub
local success, err = pcall(function()
    return loadstring(readfile("Library.lua"))()
end)
if success and err then
    LapoHub = err
else
    LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()
end
```

## API

### `LapoHub:Init(config)`
Inicializa a janela. Deve ser chamada após declarar todas as abas.

| Parâmetro   | Tipo   | Padrão        | Descrição                    |
|-------------|--------|---------------|------------------------------|
| `Title`     | string | `"Lapo Hub X"` | Título no cabeçalho          |
| `ToggleKey` | string | `"End"`        | Tecla para mostrar/esconder  |

### `LapoHub:AddTab(name, icon)`
Adiciona uma aba na barra lateral.

| Parâmetro | Tipo   | Descrição                      |
|-----------|--------|--------------------------------|
| `name`    | string | Nome da aba (usado como ID)    |
| `icon`    | string | Prefixo visual (emoji etc.)    |

### `LapoHub:AddButton(tab, config)`

| Parâmetro   | Tipo     | Descrição                     |
|-------------|----------|-------------------------------|
| `text`      | string   | Rótulo do botão               |
| `callback`  | function | Função executada no clique    |

### `LapoHub:AddToggle(tab, config)`

| Parâmetro   | Tipo     | Descrição                            |
|-------------|----------|--------------------------------------|
| `text`      | string   | Rótulo                              |
| `default`   | boolean  | Estado inicial                       |
| `callback`  | function | Recebe o estado ao alternar          |

**Métodos do handle:** `handle:Set(valor)`

### `LapoHub:AddSlider(tab, config)`

| Parâmetro   | Tipo     | Descrição                    |
|-------------|----------|------------------------------|
| `text`      | string   | Rótulo                       |
| `min`       | number   | Valor mínimo                 |
| `max`       | number   | Valor máximo                 |
| `default`   | number   | Valor inicial                |
| `callback`  | function | Recebe o valor ao arrastar   |

**Métodos do handle:** `handle:Set(valor)`

### `LapoHub:AddDropdown(tab, config)`

| Parâmetro   | Tipo     | Descrição                         |
|-------------|----------|-----------------------------------|
| `text`      | string   | Rótulo                            |
| `options`   | table    | Lista de opções                   |
| `default`   | number   | Índice inicial                    |
| `search`    | boolean  | Ativa barra de busca              |
| `callback`  | function | Recebe o índice e o valor         |

**Métodos do handle:** `handle:Set(valor)` ou `handle:Set(novaTabela)`

### `LapoHub:AddTextBox(tab, config)`

| Parâmetro    | Tipo     | Descrição                    |
|--------------|----------|------------------------------|
| `text`       | string   | Rótulo                       |
| `placeholder`| string   | Texto de fundo               |
| `callback`   | function | Recebe o texto ao confirmar  |

**Métodos do handle:** `handle:Set(texto)`

### `LapoHub:AddLabel(tab, config)` / `LapoHub:AddParagraph(tab, config)`

| Parâmetro | Tipo   | Descrição      |
|-----------|--------|----------------|
| `text`    | string | Conteúdo textual |

**Métodos do handle:** `handle:updateText(texto)` / `handle:Set(texto)`

### `LapoHub:AddSeparator(tab)`
Insere uma linha horizontal divisória.

### `LapoHub:Notify(config)`

| Parâmetro   | Tipo   | Descrição                     |
|-------------|--------|-------------------------------|
| `title`     | string | Título da notificação         |
| `content`   | string | Mensagem (quebra automática)  |
| `duration`  | number | Tempo em segundos             |

### `LapoHub:SetUser(name, rank)`
Define o nome e cargo exibidos no rodapé.

### `LapoHub:SetUserCallback(callback)`
Callback chamada ao clicar no rodapé. Recebe `(name, rank)`.

### `LapoHub:ToggleVisibility()`
Alterna a visibilidade da janela.

### `LapoHub:Destroy()`
Remove todos os desenhos e conexões.

## Requisitos

- Executor com suporte à **Drawing API** (`Drawing.new`)
- Acesso a `game:HttpGet` para carregamento remoto
- `writefile`/`readfile` (opcional, para persistência de config)

## Exemplo mínimo

```lua
local LapoHub
local success, err = pcall(function()
    return loadstring(readfile("Library.lua"))()
end)
if success and err then
    LapoHub = err
else
    LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()
end

LapoHub:AddTab("Principal", "🏠")
LapoHub:AddTab("Config", "⚙️")

LapoHub:Init({ Title = "Meu Script", ToggleKey = "K" })

LapoHub:SetUser("Player", "Dev")

LapoHub:AddButton("Principal", {
    text = "Clique",
    callback = function()
        LapoHub:Notify({ title = "Olá", content = "Funcionou!", duration = 3 })
    end,
})
```
