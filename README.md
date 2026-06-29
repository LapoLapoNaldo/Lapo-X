# Lapo Library X

Uma biblioteca de interface de usuário para Roblox construída sobre a Drawing API dos executores. Renderização por overlay, sem depender de CoreGui/PlayerGui.

Para ver a documentação interativa completa com o simulador de componentes, acesse a pasta `/docs` no navegador.

## Carregamento (Local com Fallback GitHub)

```lua
local LapoX
local success, err = pcall(function()
    return loadstring(readfile("Library.lua"))()
end)
if success and err then
    LapoX = err
else
    LapoX = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()
end
```

## API

### `LapoX:Init(config)`
Inicializa a janela. Deve ser chamada após declarar todas as abas.

| Parâmetro   | Tipo   | Padrão             | Descrição                    |
|-------------|--------|--------------------|------------------------------|
| `Title`     | string | `"Lapo Library X"` | Título no cabeçalho          |
| `ToggleKey` | string | `"End"`            | Tecla para mostrar/esconder  |

### `LapoX:AddTab(name, icon)`
Adiciona uma aba na barra lateral.

| Parâmetro | Tipo   | Descrição                      |
|-----------|--------|--------------------------------|
| `name`    | string | Nome da aba (usado como ID)    |
| `icon`    | string | Prefixo visual (emoji etc.)    |

### `LapoX:AddButton(tab, config)`

| Parâmetro   | Tipo     | Descrição                     |
|-------------|----------|-------------------------------|
| `text`      | string   | Rótulo do botão               |
| `callback`  | function | Função executada no clique    |

### `LapoX:AddToggle(tab, config)`

| Parâmetro   | Tipo     | Descrição                            |
|-------------|----------|--------------------------------------|
| `text`      | string   | Rótulo                              |
| `default`   | boolean  | Estado inicial                       |
| `callback`  | function | Recebe o estado ao alternar          |

**Métodos do handle:** `handle:Set(valor)`

### `LapoX:AddSlider(tab, config)`

| Parâmetro   | Tipo     | Descrição                    |
|-------------|----------|------------------------------|
| `text`      | string   | Rótulo                       |
| `min`       | number   | Valor mínimo                 |
| `max`       | number   | Valor máximo                 |
| `default`   | number   | Valor inicial                |
| `callback`  | function | Recebe o valor ao arrastar   |

**Métodos do handle:** `handle:Set(valor)`

### `LapoX:AddDropdown(tab, config)`

| Parâmetro   | Tipo     | Descrição                         |
|-------------|----------|-----------------------------------|
| `text`      | string   | Rótulo                            |
| `options`   | table    | Lista de opções                   |
| `default`   | number   | Índice inicial                    |
| `search`    | boolean  | Ativa barra de busca              |
| `callback`  | function | Recebe o índice e o valor         |

**Métodos do handle:** `handle:Set(valor)` ou `handle:Set(novaTabela)`

### `LapoX:AddTextBox(tab, config)`

| Parâmetro    | Tipo     | Descrição                    |
|--------------|----------|------------------------------|
| `text`       | string   | Rótulo                       |
| `placeholder`| string   | Texto de fundo               |
| `callback`   | function | Recebe o texto ao confirmar  |

**Métodos do handle:** `handle:Set(texto)`

### `LapoX:AddLabel(tab, config)` / `LapoX:AddParagraph(tab, config)`

| Parâmetro | Tipo   | Descrição      |
|-----------|--------|----------------|
| `text`    | string | Conteúdo textual |

**Métodos do handle:** `handle:updateText(texto)` / `handle:Set(texto)`

### `LapoX:AddSeparator(tab)`
Insere uma linha horizontal divisória.

### `LapoX:Notify(config)`

| Parâmetro   | Tipo   | Descrição                     |
|-------------|--------|-------------------------------|
| `title`     | string | Título da notificação         |
| `content`   | string | Mensagem (quebra automática)  |
| `duration`  | number | Tempo em segundos             |

### `LapoX:SetUser(name, rank)`
Define o nome e cargo exibidos no rodapé.

### `LapoX:SetUserCallback(callback)`
Callback chamada ao clicar no rodapé. Recebe `(name, rank)`.

### `LapoX:ToggleVisibility()`
Alterna a visibilidade da janela.

### `LapoX:Destroy()`
Remove todos os desenhos e conexões.

## Requisitos

- Executor com suporte à **Drawing API** (`Drawing.new`)
- Acesso a `game:HttpGet` para carregamento remoto
- `writefile`/`readfile` (opcional, para persistência de config)

## Exemplo mínimo

```lua
local LapoX
local success, err = pcall(function()
    return loadstring(readfile("Library.lua"))()
end)
if success and err then
    LapoX = err
else
    LapoX = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()
end

LapoX:AddTab("Principal", "🏠")
LapoX:AddTab("Config", "⚙️")

LapoX:Init({ Title = "Meu Script", ToggleKey = "K" })

LapoX:SetUser("Player", "Dev")

LapoX:AddButton("Principal", {
    text = "Clique",
    callback = function()
        LapoX:Notify({ title = "Olá", content = "Funcionou!", duration = 3 })
    end,
})
```
