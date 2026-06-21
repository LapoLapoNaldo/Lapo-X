const PAGES = {

    "home": {
        category: "Começando",
        title: "Lapo Hub X",
        breadcrumb: "Início",
        content: `
            <div class="hero-section">
                <span class="badge badge-primary">Biblioteca UI Profissional</span>
                <h1 class="page-title" style="margin-top: 10px;">Lapo Hub X</h1>
                <p class="page-description">Uma biblioteca de interface de usuário ultra-rápida de estilo executivo (Rayfield/Synapse vibes) para scripts de Roblox. Construída sobre a API de Drawing nativa dos executores para renderização de sobreposição perfeita e indetectável.</p>

                <div class="action-group">
                    <a href="#getting-started" class="btn btn-primary"><i class="ri-rocket-line"></i> Começar Agora</a>
                    <a href="#showcase" class="btn btn-outline"><i class="ri-gamepad-line"></i> Testar Simulador</a>
                </div>
            </div>

            <h2>Recursos Principais</h2>
            <div class="grid-2">
                <div class="card">
                    <div class="card-title"><i class="ri-cpu-line"></i> Renderização em Drawing API</div>
                    <p class="card-description">Bypassa a árvore do CoreGui padrão renderizando diretamente via tela sobreposta. Muito mais seguro contra detecção de UI do lado do servidor.</p>
                </div>
                <div class="card">
                    <div class="card-title"><i class="ri-smartphone-line"></i> Otimização Mobile</div>
                    <p class="card-description">Adapta automaticamente o layout, tamanho e escala da janela em dispositivos touch. Inclui um botão flutuante para reabrir o painel.</p>
                </div>
                <div class="card">
                    <div class="card-title"><i class="ri-palette-line"></i> Tema Premium Synapse-Vibe</div>
                    <p class="card-description">Interface escura e moderna com acentos em degradê violeta e glow discreto, elevando a experiência do usuário do seu script.</p>
                </div>
                <div class="card">
                    <div class="card-title"><i class="ri-keyboard-line"></i> Input Sinking Avançado</div>
                    <p class="card-description">Utiliza ContextActionService com prioridade máxima para afundar os cliques e impedir que as ações do mouse bleedem para o jogo.</p>
                </div>
            </div>

            <h2>Visualização Rápida</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>-- Carrega a library da nuvem
local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

-- Inicializa a janela principal
LapoHub:Init({
    Title = "Lapo Hub X",
    ToggleKey = "End" -- Tecla para alternar visibilidade (computador)
})

-- Adiciona abas
LapoHub:AddTab("Principal", "🎮")

-- Adiciona widgets
LapoHub:AddButton("Principal", {
    text = "Executar Ação",
    callback = function()
        LapoHub:Notify({
            title = "Ação Executada!",
            content = "O código foi rodado com sucesso no executor.",
            duration = 3
        })
    end
})</code></pre>
            </div>

            <div class="alert alert-tip">
                <div class="alert-icon"><i class="ri-lightbulb-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Dica de Desenvolvimento</div>
                    <p class="alert-text">Use nosso simulador interativo na aba <strong>Showcase</strong> para testar as abas, botões, sliders, dropdowns e textboxes da biblioteca diretamente no seu navegador antes de testá-los no jogo!</p>
                </div>
            </div>
        `
    },

    "getting-started": {
        category: "Começando",
        title: "Primeiros Passos",
        breadcrumb: "Introdução",
        content: `
            <h1 class="page-title">Primeiros Passos</h1>
            <p class="page-description">Entenda os requisitos, carregamento básico e a estrutura para criar seu primeiro script usando Lapo Hub X.</p>

            <h2>Requisitos Prévios</h2>
            <p>Para executar scripts utilizando o <strong>Lapo Hub X</strong>, seu ambiente de execução Roblox deve atender aos seguintes requisitos mínimos:</p>
            <ul class="list-default">
                <li><strong>Executor compativel com Drawing API:</strong> Suporte completo às funções <code>Drawing.new()</code> (ex: Synapse X, Wave, Solara, MacSploit, Sober, etc.).</li>
                <li><strong>Capacidade de escrita:</strong> Acesso à função <code>writefile</code> e <code>readfile</code> caso queira carregar configurações persistentes localmente.</li>
                <li><strong>Acesso HTTP:</strong> O executor deve suportar <code>game:HttpGet</code> para obter os arquivos do repositório remoto.</li>
            </ul>

            <h2>Estrutura Básica de Script</h2>
            <p>O fluxo de trabalho padrão do Lapo Hub X consiste em 5 etapas simples:</p>
            <ol class="list-default">
                <li>Carregar a biblioteca via HTTP ou arquivo local.</li>
                <li>Adicionar as abas necessárias (Tabs).</li>
                <li>Inicializar a janela da interface (Init).</li>
                <li>Configurar perfil e callbacks adicionais do rodapé (opcional).</li>
                <li>Adicionar elementos interativos (botões, toggles, sliders, etc.) associados às abas.</li>
            </ol>

            <h2>Seu Primeiro Script</h2>
            <p>Abaixo está um script de demonstração completo que cria uma aba e adiciona um botão e um interruptor (toggle):</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>-- 1. Carregamento
local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

-- 2. Criação das Abas
LapoHub:AddTab("Principal", "🏠")
LapoHub:AddTab("Configurações", "⚙️")

-- 3. Inicialização do Painel
LapoHub:Init({
    Title = "Meu Script Premium",
    ToggleKey = "K" -- Tecla 'K' esconde/mostra a UI
})

-- 4. Definir rodapé personalizado
LapoHub:SetUser("Jogador123", "Desenvolvedor")

-- 5. Adicionando Widgets na aba "Principal"
LapoHub:AddButton("Principal", {
    text = "Clique Aqui",
    callback = function()
        print("Botão clicado!")
    end
})

local autoFarm = false
LapoHub:AddToggle("Principal", {
    text = "Auto Farm",
    default = false,
    callback = function(value)
        autoFarm = value
        print("Auto Farm definido para:", value)
    end
})</code></pre>
            </div>

            <div class="alert alert-warning">
                <div class="alert-icon"><i class="ri-alert-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Ordem de Chamadas Importante</div>
                    <p class="alert-text">Você deve declarar <strong>todas as abas (AddTab) ANTES de chamar a função <code>LapoHub:Init()</code></strong>. Chamar <code>AddTab</code> depois de inicializar pode quebrar o layout das abas desenhado em tempo de carregamento.</p>
                </div>
            </div>
        `
    },

    "installation": {
        category: "Começando",
        title: "Instalação",
        breadcrumb: "Instalação",
        content: `
            <h1 class="page-title">Como Carregar a Biblioteca</h1>
            <p class="page-description">Aprenda a importar o Lapo Hub X em seu executor, seja importando diretamente do GitHub ou mantendo um ambiente de desenvolvimento local.</p>

            <h2>Método de Produção (GitHub Remoto)</h2>
            <p>Para scripts que você planeja distribuir para outros usuários, o carregamento dinâmico via repositório Git garante que eles sempre usem a versão mais atualizada e livre de bugs:</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()</code></pre>
            </div>

            <h2>Método Híbrido (Desenvolvimento Local)</h2>
            <p>Se você estiver desenvolvendo ou fazendo modificações no código da própria biblioteca, use um pcall para tentar carregar o arquivo localmente do seu executor (da pasta <code>workspace</code>) primeiro, caindo de volta para a nuvem caso o arquivo não exista localmente. É o padrão utilizado em scripts como <strong>LapoHubX.lua</strong> e <strong>LapoSkillsX.lua</strong>:</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local LapoHub
local success, err = pcall(function()
    return loadstring(readfile("Library.lua"))()
end)

if success and err then
    LapoHub = err
else
    LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()
end</code></pre>
            </div>

            <div class="alert alert-tip">
                <div class="alert-icon"><i class="ri-file-list-3-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Nome do Arquivo</div>
                    <p class="alert-text">Para utilizar o método híbrido local, o código da biblioteca deve ser salvo na pasta <code>workspace</code> do seu executor com o nome exato de <code>Library.lua</code>.</p>
                </div>
            </div>
        `
    },

    "api-window": {
        category: "Referência de API",
        title: "Window (Inicialização)",
        breadcrumb: "API Window",
        content: `
            <h1 class="page-title">Inicializando a Janela</h1>
            <p class="page-description">A função <code>Init</code> configura e renderiza a janela principal do menu, aplicando escalas e registrando escutas de entrada no executor.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:Init(config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>Title</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Lapo Hub X"</code></td>
                            <td>O título exibido no canto superior esquerdo da barra de cabeçalho.</td>
                        </tr>
                        <tr>
                            <td><code>ToggleKey</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"End"</code></td>
                            <td>A tecla do teclado que esconde/mostra a interface. Pode ser uma string contendo a tecla (ex: <code>"End"</code>, <code>"K"</code>, <code>"RightShift"</code>).</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retorno</h2>
            <p>Retorna o objeto singleton da biblioteca (<code>LapoHub</code>) para permitir chamadas encadeadas.</p>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:Init({
    Title = "Lapo Hub X - Custom Script",
    ToggleKey = "K"
})</code></pre>
            </div>

            <h2>Observações Importantes</h2>
            <ul class="list-default">
                <li><strong>Instâncias Duplicadas:</strong> Para evitar sobreposição de desenhos antigos, a biblioteca detecta automaticamente se já existe um script ativo do mesmo título (<code>shared["LapoHubInstance_" .. Title]</code>) e chama <code>:Destroy()</code> na janela antiga antes de carregar a nova.</li>
                <li><strong>Dispositivos Móveis:</strong> A biblioteca roda um teste de hardware. Caso seja mobile, reduz a escala global para <code>0.72</code>, redimensiona a janela de forma fluida para encaixar no viewport móvel e adiciona um botão de menu (☰/✕) no lado superior direito da tela.</li>
                <li><strong>Segurança de Entrada:</strong> A janela cria frames invisíveis ativas no Roblox (CoreGui/PlayerGui) chamadas <code>LapoHubX_InputSink</code> contendo uma TextBox oculta para capturar e canalizar entradas de caixas de texto com segurança.</li>
            </ul>
        `
    },

    "cheatsheet": {
        category: "Referência de API",
        title: "Referência Rápida (Cheat Sheet)",
        breadcrumb: "Cheat Sheet",
        content: `
            <h1 class="page-title">Referência Rápida (Cheat Sheet)</h1>
            <p class="page-description">Toda a API pública do Lapo Hub X em uma única página, para consulta rápida. Pressione <code>/</code> para pesquisar qualquer função.</p>

            <h2>Janela & Ciclo de Vida</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead><tr><th>Função</th><th>Retorno</th><th>O que faz</th></tr></thead>
                    <tbody>
                        <tr><td><code>LapoHub:AddTab(name, icon)</code></td><td><span class="type-badge table">self</span></td><td>Registra uma aba. Chame <strong>antes</strong> de <code>Init</code>.</td></tr>
                        <tr><td><code>LapoHub:Init(config)</code></td><td><span class="type-badge table">self</span></td><td>Renderiza a janela. <code>config = { Title, ToggleKey }</code>.</td></tr>
                        <tr><td><code>LapoHub:ToggleVisibility()</code></td><td><span class="type-badge table">self</span></td><td>Mostra/oculta toda a interface (igual à ToggleKey).</td></tr>
                        <tr><td><code>LapoHub:Destroy()</code></td><td><code>nil</code></td><td>Limpa desenhos, conexões e sinks de input.</td></tr>
                        <tr><td><code>LapoHub:SetUser(name, rank)</code></td><td><span class="type-badge table">self</span></td><td>Define nome/rank exibidos no rodapé.</td></tr>
                        <tr><td><code>LapoHub:SetUserCallback(fn)</code></td><td><span class="type-badge table">self</span></td><td>Dispara <code>fn(name, rank)</code> ao clicar no rodapé.</td></tr>
                        <tr><td><code>LapoHub:Notify(config)</code></td><td><span class="type-badge table">self</span></td><td>Balão flutuante. <code>config = { title, content, duration }</code>.</td></tr>
                    </tbody>
                </table>
            </div>

            <h2>Widgets</h2>
            <p>O primeiro argumento (<code>tabIdx</code>) é sempre o <strong>nome</strong> da aba (recomendado) ou o <strong>índice</strong> numérico dela.</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead><tr><th>Função</th><th>Campos de <code>config</code></th><th>Retorno</th></tr></thead>
                    <tbody>
                        <tr><td><code>AddButton(tabIdx, config)</code></td><td><code>text</code>, <code>callback</code></td><td>handle</td></tr>
                        <tr><td><code>AddToggle(tabIdx, config)</code></td><td><code>text</code>, <code>default</code>, <code>callback(state)</code></td><td>handle <code>:Set</code></td></tr>
                        <tr><td><code>AddSlider(tabIdx, config)</code></td><td><code>text</code>, <code>min</code>, <code>max</code>, <code>default</code>, <code>callback(value)</code></td><td>handle <code>:Set</code></td></tr>
                        <tr><td><code>AddDropdown(tabIdx, config)</code></td><td><code>text</code>, <code>options</code>, <code>default</code>, <code>search</code>, <code>callback(index, value)</code></td><td>handle <code>:Set</code></td></tr>
                        <tr><td><code>AddTextBox(tabIdx, config)</code></td><td><code>text</code>, <code>placeholder</code>, <code>callback(value)</code></td><td>handle <code>:Set</code></td></tr>
                        <tr><td><code>AddLabel(tabIdx, config)</code></td><td><code>text</code></td><td>handle <code>:updateText</code> / <code>:Set</code></td></tr>
                        <tr><td><code>AddParagraph(tabIdx, config)</code></td><td><code>text</code></td><td>handle <code>:updateText</code> / <code>:Set</code></td></tr>
                        <tr><td><code>AddSeparator(tabIdx)</code></td><td>—</td><td><span class="type-badge table">self</span></td></tr>
                    </tbody>
                </table>
            </div>

            <h2>Métodos dos Handles (atualização em tempo real)</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead><tr><th>Handle</th><th>Método</th><th>Efeito</th></tr></thead>
                    <tbody>
                        <tr><td>Toggle</td><td><code>handle:Set(bool)</code></td><td>Muda o estado e <strong>dispara</strong> o callback.</td></tr>
                        <tr><td>Slider</td><td><code>handle:Set(number)</code></td><td>Reposiciona a alça e dispara o callback.</td></tr>
                        <tr><td>Dropdown</td><td><code>handle:Set("texto")</code></td><td>Seleciona a opção pelo texto.</td></tr>
                        <tr><td>Dropdown</td><td><code>handle:Set({...})</code></td><td>Substitui toda a lista de opções e reinicia no item 1.</td></tr>
                        <tr><td>TextBox</td><td><code>handle:Set("texto")</code></td><td>Define o valor/placeholder exibido.</td></tr>
                        <tr><td>Label / Paragraph</td><td><code>handle:updateText(s)</code> · <code>handle:Set(s)</code></td><td>Troca o texto exibido (ótimo para status ao vivo).</td></tr>
                    </tbody>
                </table>
            </div>

            <div class="alert tip">
                <div class="alert-icon"><i class="ri-information-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Importante sobre <code>:Set</code> em Dropdowns</div>
                    <p class="alert-text">Trocar as opções com <code>handle:Set({...})</code> <strong>não</strong> dispara o callback do dropdown. Se o seu script guarda a seleção numa variável, atualize-a manualmente para <code>options[1]</code> após o <code>:Set</code>.</p>
                </div>
            </div>

            <h2>Esqueleto Mínimo</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:AddTab("Principal", "🏠")   -- abas SEMPRE antes do Init
LapoHub:Init({ Title = "Meu Hub", ToggleKey = "K" })

LapoHub:AddButton("Principal", { text = "Olá", callback = function()
    LapoHub:Notify({ title = "Hub", content = "Funcionou!", duration = 3 })
end })</code></pre>
            </div>
        `
    },

    "api-tabs": {
        category: "Referência de API",
        title: "Tabs (Abas)",
        breadcrumb: "API Tabs",
        content: `
            <h1 class="page-title">Gerenciando Abas</h1>
            <p class="page-description">As abas (Tabs) fornecem a divisão categórica lateral na barra de menu, permitindo que você organize seus widgets em páginas independentes.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddTab(name, icon)</code></pre>
            </div>

            <h2>Argumentos</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>name</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td>(Obrigatório)</td>
                            <td>O nome identificador da aba que será impresso no texto lateral. Também serve como o ID para vincular widgets.</td>
                        </tr>
                        <tr>
                            <td><code>icon</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>""</code></td>
                            <td>Prefixo de emoji ou ícone texto de string exibido à esquerda do nome da aba (ex: <code>"🏠"</code>, <code>"📊"</code>).</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retorno</h2>
            <p>Retorna o objeto da biblioteca (<code>LapoHub</code>) para chamadas em cascata.</p>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>-- Registrando abas no menu
LapoHub:AddTab("Status", "📊")
LapoHub:AddTab("Combate", "⚔️")
LapoHub:AddTab("Outros", "⚙️")</code></pre>
            </div>

            <h2>Como Vincular Elementos</h2>
            <p>Ao criar qualquer widget posterior (botões, interruptores, sliders, etc.), o primeiro argumento deve ser o <strong>Índice numérico da Aba</strong> (iniciando em <code>1</code>) ou o <strong>Nome exato da aba</strong> criada. A biblioteca resolve o nome da aba automaticamente para maior legibilidade:</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>-- Usando o nome da aba (Recomendado):
LapoHub:AddButton("Status", { text = "Farmar", callback = function() ... end })

-- Usando o índice (1 = Status, 2 = Combate):
LapoHub:AddButton(2, { text = "Kill Aura", callback = function() ... end })</code></pre>
            </div>
        `
    },

    "api-buttons": {
        category: "Referência de API",
        title: "Buttons (Botões)",
        breadcrumb: "API Buttons",
        content: `
            <h1 class="page-title">Botão (Button)</h1>
            <p class="page-description">Os botões acionam uma callback instantânea no clique do mouse ou toque. Possuem acentuação de borda e animação suave de mudança de cor no hover.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddButton(tabIdx, config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>text</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Button"</code></td>
                            <td>O rótulo impresso dentro do botão.</td>
                        </tr>
                        <tr>
                            <td><code>callback</code></td>
                            <td><span class="type-badge function">function</span></td>
                            <td><code>function()end</code></td>
                            <td>Função executada quando o botão for acionado.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retorno</h2>
            <p>Retorna um handle de tabela correspondente ao widget: <code>{ _tabIdx = number }</code>.</p>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddButton("Combate", {
    text = "💥 Reatar Inimigos",
    callback = function()
        print("Atacando inimigos próximos!")
    end
})</code></pre>
            </div>
        `
    },

    "api-toggles": {
        category: "Referência de API",
        title: "Toggles (Interruptores)",
        breadcrumb: "API Toggles",
        content: `
            <h1 class="page-title">Interruptor (Toggle)</h1>
            <p class="page-description">Permite alternar entre dois estados lógicos: verdadeiro (<code>true</code>) e falso (<code>false</code>). O estado visual é composto por um trilho que se ilumina em verde (On) ou se apaga.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddToggle(tabIdx, config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>text</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Toggle"</code></td>
                            <td>O rótulo do interruptor.</td>
                        </tr>
                        <tr>
                            <td><code>default</code></td>
                            <td><span class="type-badge boolean">boolean</span></td>
                            <td><code>false</code></td>
                            <td>O estado lógico inicial da toggle.</td>
                        </tr>
                        <tr>
                            <td><code>callback</code></td>
                            <td><span class="type-badge function">function</span></td>
                            <td><code>function()end</code></td>
                            <td>Função executada a cada alteração, recebendo o novo estado booleano como argumento.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retornos e Métodos do Handle</h2>
            <p>Retorna um handle de tabela com métodos adicionais para controle de estado dinâmico:</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Método</th>
                            <th>Parâmetros</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>handle:Set(value)</code></td>
                            <td><code>value: boolean</code></td>
                            <td>Força a toggle a mudar visualmente e logicamente para o estado fornecido e dispara a callback.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local autoFarmToggle = LapoHub:AddToggle("Farm", {
    text = "Auto Farm de Níveis",
    default = false,
    callback = function(state)
        _G.AutoFarm = state
        if state then
            print("Auto farm iniciado!")
        else
            print("Auto farm parado!")
        end
    end
})

-- Alterando o valor do toggle programaticamente após 10 segundos
task.delay(10, function()
    autoFarmToggle:Set(false)
end)</code></pre>
            </div>
        `
    },

    "api-sliders": {
        category: "Referência de API",
        title: "Sliders (Barras Deslizantes)",
        breadcrumb: "API Sliders",
        content: `
            <h1 class="page-title">Barra Deslizante (Slider)</h1>
            <p class="page-description">Os sliders são usados para ajustar valores numéricos contínuos (como velocidade de caminhada, alcance do kill-aura ou delays) arrastando uma alça circular.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddSlider(tabIdx, config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>text</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Slider"</code></td>
                            <td>O rótulo exibido à esquerda do slider.</td>
                        </tr>
                        <tr>
                            <td><code>min</code></td>
                            <td><span class="type-badge number">number</span></td>
                            <td><code>0</code></td>
                            <td>O valor numérico mínimo que o slider pode atingir.</td>
                        </tr>
                        <tr>
                            <td><code>max</code></td>
                            <td><span class="type-badge number">number</span></td>
                            <td><code>100</code></td>
                            <td>O valor numérico máximo que o slider pode atingir.</td>
                        </tr>
                        <tr>
                            <td><code>default</code></td>
                            <td><span class="type-badge number">number</span></td>
                            <td>Média de min e max</td>
                            <td>O valor numérico inicial do slider.</td>
                        </tr>
                        <tr>
                            <td><code>callback</code></td>
                            <td><span class="type-badge function">function</span></td>
                            <td><code>function()end</code></td>
                            <td>Disparada enquanto o slider é arrastado ou atualizado, recebendo o valor atual como argumento.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retornos e Métodos do Handle</h2>
            <p>Retorna um handle que oferece suporte ao método:</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Método</th>
                            <th>Parâmetros</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>handle:Set(value)</code></td>
                            <td><code>value: number</code></td>
                            <td>Ajusta o valor do slider, reposiciona a alça visual e dispara a callback.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local walkspeedSlider = LapoHub:AddSlider("Jogador", {
    text = "Velocidade do Jogador",
    min = 16,
    max = 250,
    default = 16,
    callback = function(value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

-- Forçar walkspeed para 100
walkspeedSlider:Set(100)</code></pre>
            </div>
        `
    },

    "api-dropdowns": {
        category: "Referência de API",
        title: "Dropdowns (Menu de Opções)",
        breadcrumb: "API Dropdowns",
        content: `
            <h1 class="page-title">Menu de Opções (Dropdown)</h1>
            <p class="page-description">Os dropdowns exibem uma lista recolhível de opções. Oferecem suporte avançado a pesquisas textuais para filtrar rapidamente listas extensas.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddDropdown(tabIdx, config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>text</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Dropdown"</code></td>
                            <td>O rótulo do seletor.</td>
                        </tr>
                        <tr>
                            <td><code>options</code></td>
                            <td><span class="type-badge table">table</span></td>
                            <td><code>{}</code></td>
                            <td>Uma tabela contendo as opções textuais a serem selecionadas (ex: <code>{"A", "B", "C"}</code>).</td>
                        </tr>
                        <tr>
                            <td><code>default</code></td>
                            <td><span class="type-badge number">number</span></td>
                            <td><code>1</code></td>
                            <td>O índice da opção selecionada por padrão ao carregar.</td>
                        </tr>
                        <tr>
                            <td><code>search</code></td>
                            <td><span class="type-badge boolean">boolean</span></td>
                            <td><code>false</code></td>
                            <td>Se <code>true</code>, exibe uma barra de pesquisa dentro do menu suspenso para filtrar itens.</td>
                        </tr>
                        <tr>
                            <td><code>callback</code></td>
                            <td><span class="type-badge function">function</span></td>
                            <td><code>function()end</code></td>
                            <td>Disparada quando o usuário seleciona uma opção. Recebe dois argumentos: <code>(index, value)</code>.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retornos e Métodos do Handle</h2>
            <p>O handle retornado pelo Dropdown possui alta flexibilidade, suportando a atualização dinâmica de opções:</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Método</th>
                            <th>Parâmetros</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>handle:Set(value)</code></td>
                            <td><code>value: string</code></td>
                            <td>Altera a opção atualmente selecionada pelo texto fornecido.</td>
                        </tr>
                        <tr>
                            <td><code>handle:Set(newOptionsTable)</code></td>
                            <td><code>newOptionsTable: table</code></td>
                            <td>Substitui toda a lista de opções do dropdown por uma nova tabela, limpando a pesquisa anterior e reiniciando a seleção no índice 1.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local itensDisponiveis = {"Poção de Vida", "Espada Curta", "Escudo Lendário"}

local itemDropdown = LapoHub:AddDropdown("Mercado", {
    text = "Selecionar Item para Comprar",
    options = itensDisponiveis,
    default = 1,
    search = true, -- Ativa a barra de busca
    callback = function(index, value)
        print("Comprando item:", value, "no índice:", index)
    end
})

-- Atualizando as opções do mercado posteriormente
task.wait(5)
itemDropdown:Set({"Novo Item 1", "Novo Item 2"})</code></pre>
            </div>
        `
    },

    "api-inputs": {
        category: "Referência de API",
        title: "Inputs (TextBoxes)",
        breadcrumb: "API Inputs",
        content: `
            <h1 class="page-title">Caixa de Entrada (TextBox)</h1>
            <p class="page-description">As textboxes capturam dados textuais fornecidos pelos jogadores no Roblox. Possuem efeito de piscar de cursor (|) e canalizam entradas sem propagar keybinds do game.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddTextBox(tabIdx, config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>text</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"TextBox"</code></td>
                            <td>O rótulo identificador do campo de texto.</td>
                        </tr>
                        <tr>
                            <td><code>placeholder</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Type here..."</code></td>
                            <td>Texto de espaço reservado quando o campo estiver vazio.</td>
                        </tr>
                        <tr>
                            <td><code>callback</code></td>
                            <td><span class="type-badge function">function</span></td>
                            <td><code>function()end</code></td>
                            <td>Disparada quando o usuário pressiona Enter ou clica fora desfocando a caixa de texto. Recebe o texto inserido.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retornos e Métodos do Handle</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Método</th>
                            <th>Parâmetros</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>handle:Set(value)</code></td>
                            <td><code>value: string</code></td>
                            <td>Atualiza o texto/placeholder interno do campo.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddTextBox("Webhook", {
    text = "Endereço do Discord Webhook",
    placeholder = "Cole a URL do canal do Discord...",
    callback = function(url)
        _G.DiscordWebhookURL = url
        LapoHub:Notify({
            title = "Webhook Salvo",
            content = "Logs de teleporte serão encaminhados.",
            duration = 3
        })
    end
})</code></pre>
            </div>

            <h2>Mapeamento de Entrada Seguro</h2>
            <p>Diferente de UIs padrão desenhadas pela API do Roblox, a renderização via Drawing do executor não possui focos de mouse ou controles nativos de digitação. Para resolver isso com robustez, o <strong>Lapo Hub X</strong> implementa uma ponte inteligente:</p>
            <ul class="list-default">
                <li>Instancia uma ScreenGui de CoreGui/PlayerGui oculta contendo uma TextBox real de tamanho 0.</li>
                <li>Quando o usuário clica sobre a área desenhada da TextBox da UI, o script foca programaticamente nessa TextBox oculta e captura a digitação.</li>
                <li>Ao pressionar Enter ou perder o foco, a entrada é atribuída ao elemento desenhado na tela, liberando o teclado para o jogo.</li>
            </ul>
        `
    },

    "api-paragraphs": {
        category: "Referência de API",
        title: "Labels & Paragraphs (Rótulos)",
        breadcrumb: "API Labels",
        content: `
            <h1 class="page-title">Rótulos e Parágrafos</h1>
            <p class="page-description">São componentes estáticos usados para exibir informações textuais na aba ativa. Possuem diferentes tamanhos de fonte e estilos de cores.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddLabel(tabIdx, config)
LapoHub:AddParagraph(tabIdx, config)</code></pre>
            </div>

            <h2>Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>text</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>""</code></td>
                            <td>O conteúdo textual a ser exibido.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Diferença entre Label e Paragraph</h2>
            <ul class="list-default">
                <li><strong>Label:</strong> Fonte maior (17px), cor mais clara e brilhante. Ideal para títulos internos ou campos curtos e atualizações rápidas de status.</li>
                <li><strong>Paragraph:</strong> Fonte menor (15px), cor suavizada/esmaecida. Ideal para descrições, notas explicativas ou blocos de instruções longos. Suporta automaticamente redimensionamento de caixa de texto caso o conteúdo ultrapasse 60 caracteres.</li>
            </ul>

            <h2>Retornos e Métodos do Handle</h2>
            <p>Ambos os widgets retornam handles idênticos que permitem a atualização do conteúdo textual em tempo real (como atualizar o número de moedas obtidas por segundo):</p>

            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Método</th>
                            <th>Parâmetros</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>handle:updateText(newText)</code></td>
                            <td><code>newText: string</code></td>
                            <td>Substitui o texto visível pelo novo texto fornecido.</td>
                        </tr>
                        <tr>
                            <td><code>handle:Set(newText)</code></td>
                            <td><code>newText: string</code></td>
                            <td>Atalho flexível que chama o método <code>updateText</code> internamente.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>-- Criando textos
local totalFarmadosLabel = LapoHub:AddLabel("Status", { text = "Espíritos Farmados: 0" })

LapoHub:AddParagraph("Status", {
    text = "Nota: Este recurso depende da conexão de rede do jogo. Delays prolongados podem atrasar a contagem de espíritos."
})

-- Simulando um loop de atualização
task.spawn(function()
    local count = 0
    while task.wait(1) do
        count = count + 1
        totalFarmadosLabel:Set("Espíritos Farmados: " .. tostring(count))
    end
end)</code></pre>
            </div>
        `
    },

    "api-separators": {
        category: "Referência de API",
        title: "Separators (Linhas Divisórias)",
        breadcrumb: "API Separators",
        content: `
            <h1 class="page-title">Linha Divisória (Separator)</h1>
            <p class="page-description">Desenha uma linha horizontal fina e semi-transparente para separar visualmente blocos de componentes em uma mesma aba, melhorando a organização visual.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddSeparator(tabIdx)</code></pre>
            </div>

            <h2>Argumentos</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>tabIdx</code></td>
                            <td><span class="type-badge string">string</span> / <span class="type-badge number">number</span></td>
                            <td>A aba associada (nome ou índice) onde a linha horizontal será desenhada.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retorno</h2>
            <p>Retorna o objeto da biblioteca (<code>LapoHub</code>) para permitir chamadas encadeadas.</p>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:AddLabel("Aba1", { text = "Configurações Principais" })
LapoHub:AddToggle("Aba1", { text = "God Mode", default = false })

-- Adicionando a linha divisória
LapoHub:AddSeparator("Aba1")

LapoHub:AddLabel("Aba1", { text = "Configurações Secundárias" })
LapoHub:AddSlider("Aba1", { text = "Alcance do Pulo", min = 50, max = 200 })</code></pre>
            </div>
        `
    },

    "api-notifications": {
        category: "Referência de API",
        title: "Notifications (Notificações)",
        breadcrumb: "API Notifications",
        content: `
            <h1 class="page-title">Notificação (Notify)</h1>
            <p class="page-description">Cria uma notificação flutuante de tamanho fixo empilhada no canto inferior direito da tela do Roblox. Contém barra de carregamento dinâmica com base no tempo de vida e suporte para quebra de texto longa.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:Notify(config)</code></pre>
            </div>

            <h2>Argumentos da Configuração</h2>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>title</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Lapo Hub X"</code></td>
                            <td>O título do balão de notificação.</td>
                        </tr>
                        <tr>
                            <td><code>content</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>""</code></td>
                            <td>O conteúdo descritivo da mensagem. Textos muito longos serão quebrados automaticamente em múltiplas linhas (limite máximo de 8 linhas exibidas).</td>
                        </tr>
                        <tr>
                            <td><code>duration</code></td>
                            <td><span class="type-badge number">number</span></td>
                            <td><code>4</code></td>
                            <td>Tempo de exibição em segundos antes do balão sumir da tela.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Retorno</h2>
            <p>Retorna o objeto da biblioteca (<code>LapoHub</code>) para permitir chamadas encadeadas.</p>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:Notify({
    title = "Lapo Hub X",
    content = "Auto-Farm carregado com sucesso! Iniciando teleporte...",
    duration = 5
})</code></pre>
            </div>

            <h2>Como Funciona a Fila</h2>
            <ul class="list-default">
                <li>As notificações são adicionadas a um pool global e ordenadas dinamicamente.</li>
                <li>Quando uma notificação expira ou é removida, as notificações acima dela descem suavemente com interpolação linear (lerp) para ocupar os espaços vazios de maneira suave.</li>
                <li>A barra colorida na base da notificação diminui gradualmente com base na proporção do tempo de vida restante.</li>
            </ul>
        `
    },

    "api-userprofile": {
        category: "Referência de API",
        title: "Footer & Perfil de Usuário",
        breadcrumb: "API Footer",
        content: `
            <h1 class="page-title">Perfil do Usuário no Rodapé</h1>
            <p class="page-description">O Lapo Hub X inclui um bloco de perfil no rodapé da barra lateral contendo um indicador luminoso online (verde), nome do usuário e rank. Ideal para personalizar seu script comercialmente ou registrar dados de licença.</p>

            <h2>Sintaxe</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:SetUser(username, rank)
LapoHub:SetUserCallback(callback)</code></pre>
            </div>

            <h2>Funções de Configuração</h2>
            <h3><code>LapoHub:SetUser(username, rank)</code></h3>
            <p>Configura o texto do perfil exibido no rodapé da barra lateral lateral.</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Padrão</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>username</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"LapoLapoNaldo"</code></td>
                            <td>Nome de exibição do usuário.</td>
                        </tr>
                        <tr>
                            <td><code>rank</code></td>
                            <td><span class="type-badge string">string</span></td>
                            <td><code>"Lapo Newba"</code></td>
                            <td>Cargo ou nível de permissão impresso abaixo do nome (em destaque lilás).</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h3><code>LapoHub:SetUserCallback(callback)</code></h3>
            <p>Registra uma callback executada quando o jogador clica na área do perfil do rodapé.</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead>
                        <tr>
                            <th>Parâmetro</th>
                            <th>Tipo</th>
                            <th>Descrição</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>callback</code></td>
                            <td><span class="type-badge function">function</span></td>
                            <td>Função executada a cada clique. Recebe os parâmetros <code>(username, rank)</code>.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h2>Exemplo de Uso</h2>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>LapoHub:SetUser("LucasDeveloper", "Assinatura VIP")

LapoHub:SetUserCallback(function(name, rank)
    LapoHub:Notify({
        title = "Informações do Usuário",
        content = "Logado como: " .. name .. "\\nRank: " .. rank,
        duration = 3
    })
end)</code></pre>
            </div>
        `
    },

    "api-window-controls": {
        category: "Referência de API",
        title: "Controles da Janela & Ciclo de Vida",
        breadcrumb: "Controles da Janela",
        content: `
            <h1 class="page-title">Controles da Janela & Ciclo de Vida</h1>
            <p class="page-description">Tudo que controla a janela depois de criada: mostrar/ocultar, minimizar, arrastar, rolar, a tecla de atalho e a destruição limpa da interface.</p>

            <h2>Mostrar / Ocultar — <code>ToggleVisibility()</code></h2>
            <p>Alterna a visibilidade de <strong>toda</strong> a interface. É exatamente o que a <code>ToggleKey</code> aciona internamente, mas você pode chamá-la pelo seu próprio código (ex.: um botão "Esconder Menu").</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>-- Esconder por código
LapoHub:ToggleVisibility()

-- Botão dentro do próprio menu que o esconde
LapoHub:AddButton("Ajustes", {
    text = "Esconder Menu (use a ToggleKey para reabrir)",
    callback = function() LapoHub:ToggleVisibility() end
})</code></pre>
            </div>
            <div class="alert tip">
                <div class="alert-icon"><i class="ri-shield-check-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Foco é liberado ao ocultar</div>
                    <p class="alert-text">Ao ocultar, a biblioteca libera automaticamente o foco de qualquer TextBox/pesquisa ativa e fecha dropdowns abertos — evitando que o teclado fique "preso" capturando digitação de um widget invisível.</p>
                </div>
            </div>

            <h2>A Tecla de Atalho — <code>ToggleKey</code></h2>
            <p>Definida no <code>Init</code>. Aceita o <strong>nome</strong> de qualquer tecla (string do <code>Enum.KeyCode</code>). Padrão: <code>"End"</code>.</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>LapoHub:Init({ Title = "Hub", ToggleKey = "RightShift" })
-- Exemplos válidos: "End", "K", "Insert", "RightControl", "F4", "Backquote"</code></pre>
            </div>

            <h2>Minimizar, Arrastar e Rolar (ações do usuário)</h2>
            <p>Estas interações são feitas diretamente pelo usuário na janela desenhada — não exigem chamadas de API:</p>
            <div class="table-wrapper">
                <table class="api-table">
                    <thead><tr><th>Ação</th><th>Como</th><th>Comportamento</th></tr></thead>
                    <tbody>
                        <tr><td>Minimizar</td><td>Botão <code>─</code> no cabeçalho</td><td>Recolhe a janela deixando só a barra de título. Clique de novo para restaurar.</td></tr>
                        <tr><td>Fechar</td><td>Botão <code>✕</code> no cabeçalho</td><td>Chama <code>Destroy()</code> — encerra a interface por completo.</td></tr>
                        <tr><td>Arrastar</td><td>Segurar e mover o cabeçalho</td><td>Reposiciona a janela; fica presa dentro da tela (clamp ao viewport).</td></tr>
                        <tr><td>Rolar conteúdo</td><td>Roda do mouse ou arraste por toque</td><td>Faz scroll vertical dos widgets da aba ativa quando ultrapassam a altura visível.</td></tr>
                        <tr><td>Mobile</td><td>Botão flutuante <code>☰ / ✕</code></td><td>Em telas touch, reabre/oculta a janela (a ToggleKey não existe sem teclado).</td></tr>
                    </tbody>
                </table>
            </div>

            <h2>Destruir a Interface — <code>Destroy()</code></h2>
            <p>Encerra o hub por completo: remove todos os desenhos da tela, desconecta os <em>listeners</em> de input, desvincula o sink do <code>ContextActionService</code> e destrói a <code>ScreenGui</code> oculta usada para capturar texto. Use ao trocar de script ou fornecer um botão "Desligar".</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>LapoHub:AddButton("Ajustes", {
    text = "❌ Desligar Hub",
    callback = function()
        LapoHub:Notify({ title = "Hub", content = "Encerrando...", duration = 2 })
        task.delay(1, function() LapoHub:Destroy() end)
    end
})</code></pre>
            </div>
            <div class="alert tip">
                <div class="alert-icon"><i class="ri-recycle-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Anti-duplicação automática</div>
                    <p class="alert-text">Você raramente precisa chamar <code>Destroy()</code> antes de recarregar: o <code>Init</code> detecta uma instância anterior com o mesmo <code>Title</code> (via <code>shared</code>) e a destrói sozinho antes de desenhar a nova — então rodar o script duas vezes não empilha menus.</p>
                </div>
            </div>
        `
    },

    "customization": {
        category: "Guias",
        title: "Temas & Customização",
        breadcrumb: "Customização",
        content: `
            <h1 class="page-title">Personalização de Temas</h1>
            <p class="page-description">O design do Lapo Hub X é estruturado através de uma paleta de cores centralizada (Synapse X vibes) no arquivo de origem. Saiba como alterar as cores e criar seu próprio estilo.</p>

            <h2>A Estrutura do Tema</h2>
            <p>No topo do arquivo <code>Library.lua</code>, a tabela local <code>Theme</code> armazena todos os canais de cores em RGB. Se você hospedar ou customizar o código-fonte, basta editar esses valores:</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local Theme = {
    BgDeep      = Color3.fromRGB(10,  10,  18),  -- Fundo do rodapé e popup dropdown
    BgBase      = Color3.fromRGB(14,  14,  26),  -- Fundo principal do painel
    BgPanel     = Color3.fromRGB(18,  18,  32),  -- Fundo do cabeçalho e barra lateral
    BgWidget    = Color3.fromRGB(22,  22,  38),  -- Fundo dos botões/toggles/sliders
    BgInput     = Color3.fromRGB(12,  12,  22),  -- Fundo do campo de texto/caixa de seleção
    Border      = Color3.fromRGB(40,  40,  70),  -- Cor das bordas normais
    BorderAccent= Color3.fromRGB(80,  60, 180),  -- Cor das bordas em foco
    Separator   = Color3.fromRGB(30,  30,  50),  -- Linhas horizontais de separação
    Accent      = Color3.fromRGB(120,  80, 255), -- Cor primária em destaque (Roxo/Glow)
    AccentDim   = Color3.fromRGB( 70,  45, 160), -- Cor de acento suavizada (barras de progresso)
    AccentGlow  = Color3.fromRGB(140, 100, 255), -- Cor brilhante de foco do acento
    On          = Color3.fromRGB( 50, 220, 120), -- Cor verde ativa (toggle ligado)
    OnDim       = Color3.fromRGB( 20, 100,  55), -- Cor verde desligada ou esmaecida
    Text        = Color3.fromRGB(220, 220, 235), -- Texto primário principal
    TextSub     = Color3.fromRGB(110, 110, 140), -- Texto secundário esmaecido
    TextMuted   = Color3.fromRGB( 60,  60,  90),  -- Texto inativo ou marca d'água
    Danger      = Color3.fromRGB(220,  55,  55), -- Cor vermelha (Botão Fechar/Excluir)
    HoverLight  = Color3.fromRGB(255, 255, 255), -- Brilho de sobreposição no hover
}</code></pre>
            </div>

            <h2>Criando Estilos Customizados</h2>
            <p>Se você deseja mudar o acento Roxo padrão para um tema <strong>Verde Esmeralda (Cyberpunk)</strong>, altere os campos <code>Accent</code> do arquivo original:</p>
            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>-- Customização do tema (Exemplo Verde Cyberpunk)
Theme.Accent      = Color3.fromRGB(16,  185, 129)
Theme.AccentDim   = Color3.fromRGB(4,   120, 87)
Theme.AccentGlow  = Color3.fromRGB(52,  211, 153)
Theme.BorderAccent= Color3.fromRGB(6,   95,  70)</code></pre>
            </div>
        `
    },

    "examples": {
        category: "Guias",
        title: "Exemplos Práticos",
        breadcrumb: "Exemplos",
        content: `
            <h1 class="page-title">Exemplos de Implementação</h1>
            <p class="page-description">Veja casos reais de como aplicar o Lapo Hub X em scripts de automação. Estes exemplos representam práticas recomendadas estruturais.</p>

            <h2>Exemplo 1: Script de Trait Auto-Roller (Simples)</h2>
            <p>Este exemplo cria uma interface para um simulador que rola traits de unidades automaticamente usando loops de delay com verificação segura do estado do botão Toggle:</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:AddTab("Rolador", "🎲")
LapoHub:Init({ Title = "Trait Roller Tool" })

local selectedUnit = "Nenhuma"
local autoRollEnabled = false

LapoHub:AddDropdown("Rolador", {
    text = "Selecionar Unidade",
    options = {"Goku", "Naruto", "Luffy", "Zoro"},
    default = 1,
    callback = function(index, value)
        selectedUnit = value
        print("Unidade selecionada para roll:", value)
    end
})

LapoHub:AddToggle("Rolador", {
    text = "Auto Rolar Traits",
    default = false,
    callback = function(state)
        autoRollEnabled = state
        if state then
            LapoHub:Notify({ title = "Auto-Roll", content = "Rolamento automático iniciado para " .. selectedUnit, duration = 3 })

            task.spawn(function()
                while autoRollEnabled do
                    -- Simula o disparo de um remote de rolagem do jogo
                    game:GetService("ReplicatedStorage").Remote.RollTrait:FireServer(selectedUnit)

                    -- Intervalo seguro para evitar lag ou desconexões
                    task.wait(0.8)
                end
                LapoHub:Notify({ title = "Auto-Roll", content = "Parado", duration = 2 })
            end)
        end
    end
})</code></pre>
            </div>

            <h2>Exemplo 2: Integração de Habilidades (Baseado em LapoSkillsX)</h2>
            <p>Abaixo está um caso avançado demonstrando o escaner dinâmico de instâncias ativas do jogo e alteração de propriedades no workspace:</p>

            <div class="code-block-container">
                <div class="code-block-header">
                    <span class="code-language-tag">Lua</span>
                    <button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button>
                </div>
                <pre class="language-lua"><code>local LapoHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua"))()

LapoHub:AddTab("Skills", "⚡")
LapoHub:Init({ Title = "Skill Trigger" })

local workspaceUnits = workspace:WaitForChild("Units")
local unitList = {}

-- Função de varredura das unidades no jogo
local function getMyUnits()
    local myName = game.Players.LocalPlayer.Name
    local found = {}
    for _, u in ipairs(workspaceUnits:GetChildren()) do
        local info = u:FindFirstChild("Info")
        local owner = info and info:FindFirstChild("Owner")
        if owner and owner.Value == myName then
            table.insert(found, u.Name)
        end
    end
    return #found > 0 and found or {"Nenhuma unidade encontrada"}
end

local unitDropdown = LapoHub:AddDropdown("Skills", {
    text = "Selecione a Unidade",
    options = getMyUnits(),
    default = 1,
    callback = function(idx, val)
        _G.SelectedUnit = val
    end
})

-- Botão para recarregar unidades
LapoHub:AddButton("Skills", {
    text = "🔄 Atualizar Lista",
    callback = function()
        local updated = getMyUnits()
        unitDropdown:Set(updated) -- Atualiza as opções dinamicamente no handle
        LapoHub:Notify({ title = "Recarregado", content = "Encontradas " .. #updated .. " unidades.", duration = 2 })
    end
})</code></pre>
            </div>
        `
    },

    "automation-patterns": {
        category: "Guias",
        title: "Loops de Automação Seguros",
        breadcrumb: "Loops de Automação",
        content: `
            <h1 class="page-title">Loops de Automação Seguros</h1>
            <p class="page-description">A maioria dos scripts (auto-farm, auto-roll, auto-skill) é um loop ligado/desligado por um Toggle. Fazer isso errado cria loops que <strong>nunca param</strong> ou que <strong>duplicam</strong>. Este é o padrão correto.</p>

            <h2>❌ O Erro Clássico</h2>
            <p>O callback do Toggle recebe o estado <code>state</code> como <strong>parâmetro</strong>. Esse valor fica congelado dentro daquela execução. Se o loop checar o parâmetro, ele <strong>nunca</strong> vê o desligamento:</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua — NÃO faça</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>LapoHub:AddToggle("Farm", {
    text = "Auto Farm",
    callback = function(state)
        task.spawn(function()
            while state do          -- ❌ 'state' nunca muda aqui!
                fazerFarm()
                task.wait(1)
            end
        end)
    end
})
-- Resultado: desligar o toggle NÃO para o loop, e ligar de novo cria um 2º loop.</code></pre>
            </div>

            <h2>✅ O Padrão Correto (flag externa)</h2>
            <p>Guarde o estado numa variável <strong>fora</strong> do callback. O callback só atualiza a flag; o loop lê a flag a cada volta:</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>local autoFarm = false   -- flag externa (estado real)

LapoHub:AddToggle("Farm", {
    text = "Auto Farm",
    default = false,
    callback = function(state)
        autoFarm = state
        if not state then return end
        task.spawn(function()
            while autoFarm do        -- ✅ lê a flag viva
                fazerFarm()
                task.wait(1)
            end
        end)
    end
})</code></pre>
            </div>

            <h2>🛡️ Blindagem contra Duplicação (re-toggle rápido)</h2>
            <p>Se o usuário liga/desliga muito rápido, um loop antigo ainda parado em <code>task.wait</code> pode coexistir com o novo. Use uma flag de "rodando" e/ou um <em>token de geração</em>:</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>local autoFarm = false
local running = false

LapoHub:AddToggle("Farm", {
    text = "Auto Farm",
    callback = function(state)
        autoFarm = state
        if not state or running then return end  -- evita 2º loop
        running = true
        task.spawn(function()
            while autoFarm do
                fazerFarm()
                task.wait(1)
            end
            running = false                       -- libera ao sair
        end)
    end
})</code></pre>
            </div>

            <h2>Parar por código</h2>
            <p>Como o loop lê a flag, basta zerá-la de qualquer lugar (um botão "Parar", outro evento, etc.):</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>LapoHub:AddButton("Farm", {
    text = "⏹ Parar Tudo",
    callback = function() autoFarm = false end
})</code></pre>
            </div>

            <div class="alert warning">
                <div class="alert-icon"><i class="ri-pulse-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Sempre dê um <code>task.wait()</code></div>
                    <p class="alert-text">Um <code>while</code> sem <code>task.wait</code> trava o jogo (loop infinito sem ceder). Mesmo em loops rápidos, use no mínimo <code>task.wait()</code> (um frame). Para chamadas de rede (<code>FireServer</code>/<code>InvokeServer</code>), prefira intervalos de <code>0.2s</code> ou mais para não tomar kick por flood.</p>
                </div>
            </div>
        `
    },

    "performance": {
        category: "Guias",
        title: "Performance & Boas Práticas",
        breadcrumb: "Performance",
        content: `
            <h1 class="page-title">Performance & Boas Práticas</h1>
            <p class="page-description">A janela é redesenhada a cada frame e os seus callbacks rodam no meio das interações do usuário. Estas práticas mantêm tudo fluido e evitam travadas.</p>

            <h2>1. Não bloqueie a rede dentro de callbacks visuais</h2>
            <p>Chamar <code>Remote:InvokeServer()</code> em <strong>cada</strong> seleção de dropdown ou atualização de label congela a UI no round-trip do servidor. Busque os dados <strong>uma vez</strong>, guarde em cache e repinte a partir do cache.</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>local cache = {}                       -- dados em memória

local function refreshCache()           -- chamado por um BOTÃO, não a cada clique
    local ok, data = pcall(function() return Remote.ReturnData:InvokeServer() end)
    if ok and type(data) == "table" then cache = data end
end
refreshCache()

LapoHub:AddDropdown("Stats", {
    text = "Unidade",
    options = listaDeUnidades,
    callback = function(_, nome)
        local u = cache[nome]             -- leitura instantânea do cache
        infoLabel:Set(u and ("LB: " .. u.LimitBreak) or "N/A")
    end
})

LapoHub:AddButton("Stats", { text = "🔄 Atualizar", callback = refreshCache })</code></pre>
            </div>

            <h2>2. Atualize widgets em vez de recriá-los</h2>
            <p>Para status ao vivo (moedas/seg, contadores), guarde o <em>handle</em> e use <code>:Set</code> / <code>:updateText</code>. Recriar a aba inteira a cada segundo é caro e desnecessário.</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>local contador = LapoHub:AddLabel("Status", { text = "Coletados: 0" })
task.spawn(function()
    local n = 0
    while task.wait(1) do
        n = n + 1
        contador:Set("Coletados: " .. n)   -- atualiza só o texto
    end
end)</code></pre>
            </div>

            <h2>3. Adie varreduras pesadas do carregamento</h2>
            <p>Operações caras no <em>load</em> (ex.: <code>require</code> em dezenas de módulos para listar skills/itens) atrasam a abertura do menu. Rode-as depois com <code>task.spawn</code> + <code>task.wait()</code> e preencha o dropdown quando terminar.</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>local skillDropdown = LapoHub:AddDropdown("Skills", { text = "Skill", options = {"Carregando..."} })

task.spawn(function()
    task.wait()                          -- deixa a UI montar primeiro
    local lista = escanearSkillsDoJogo() -- trabalho pesado
    skillDropdown:Set(lista)
end)</code></pre>
            </div>

            <h2>4. Debounce em buscas que disparam a cada tecla</h2>
            <p>A barra de pesquisa do Dropdown filtra a lista a cada caractere. Em listas enormes, jogue o trabalho pesado para um <em>debounce</em> simples:</p>
            <div class="code-block-container">
                <div class="code-block-header"><span class="code-language-tag">Lua</span><button class="copy-code-btn"><i class="ri-file-copy-line"></i> Copiar</button></div>
                <pre class="language-lua"><code>local pending = 0
local function debouncedFilter(texto)
    pending = pending + 1
    local id = pending
    task.delay(0.15, function()
        if id ~= pending then return end   -- digitou de novo? ignora o antigo
        aplicarFiltroCaro(texto)
    end)
end</code></pre>
            </div>

            <div class="alert tip">
                <div class="alert-icon"><i class="ri-flashlight-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">A biblioteca já faz a parte dela</div>
                    <p class="alert-text">O render loop interno já memoiza textos truncados, recorta (clip) o que sai da área de conteúdo, lê o mouse uma única vez por frame e limpa todos os objetos de Drawing com <code>:Remove()</code>. Seguindo as práticas acima, o gargalo dificilmente será a UI.</p>
                </div>
            </div>
        `
    },

    "faq": {
        category: "Guias",
        title: "Perguntas Frequentes",
        breadcrumb: "FAQ",
        content: `
            <h1 class="page-title">Perguntas Frequentes</h1>
            <p class="page-description">Respostas rápidas para as dúvidas mais comuns sobre o uso da biblioteca Lapo Hub X.</p>

            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        <span>O Lapo Hub X funciona em dispositivos móveis?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Sim! A biblioteca possui suporte mobile completo. Ela detecta automaticamente telas touch, reduz o tamanho da janela global (escala de 0.72) para caber melhor na tela dos smartphones e cria um botão flutuante para ocultar e mostrar a janela facilmente.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <span>Por que a biblioteca usa a Drawing API em vez de ScreenGuis comuns?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>A Drawing API renderiza diretamente na tela por fora do DOM principal do Roblox, sendo muito mais indetectável para sistemas de segurança anti-cheat dos jogos que varrem o CoreGui buscando por elementos visuais suspeitos.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <span>Como fechar ou destruir completamente o menu?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Você pode clicar no botão de fechar (✕) no cabeçalho ou chamar a função <code>LapoHub:Destroy()</code> de dentro do seu script. Isso limpa todos os desenhos da tela, remove os escutas de teclado e desvincula os sinks de cliques do ContextActionService.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <span>Meu Auto-Farm não para quando desligo o Toggle. Por quê?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Quase sempre o loop está checando o <strong>parâmetro</strong> <code>state</code> do callback (que fica congelado) em vez de uma variável externa. Guarde o estado numa flag fora do callback e faça o <code>while</code> ler essa flag. O passo a passo completo está no guia <a href="#automation-patterns">Loops de Automação Seguros</a>.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <span>Como troco a tecla que abre/fecha o menu?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Passe <code>ToggleKey</code> no <code>Init</code> com o nome da tecla, ex.: <code>LapoHub:Init({ ToggleKey = "RightShift" })</code>. Aceita qualquer nome de <code>Enum.KeyCode</code> ("End", "K", "Insert", "F4"...). Você também pode alternar por código com <code>LapoHub:ToggleVisibility()</code>.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <span>Como atualizo as opções de um Dropdown durante o jogo?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Guarde o handle retornado e chame <code>handle:Set({ ...novasOpções })</code>. Lembre-se: trocar as opções <strong>não</strong> dispara o callback do dropdown, então se você guarda a seleção numa variável, redefina-a para a primeira opção manualmente após o <code>:Set</code>.</p>
                    </div>
                </div>
                <div class="faq-item">
                    <div class="faq-question">
                        <span>O que acontece se eu executar o mesmo script duas vezes?</span>
                        <i class="ri-arrow-down-s-line faq-icon"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Nada de menus empilhados: o <code>Init</code> identifica uma instância anterior com o mesmo <code>Title</code> (via tabela global <code>shared</code>) e chama <code>:Destroy()</code> nela antes de desenhar a nova. Para rodar dois hubs lado a lado de propósito, basta usar <code>Title</code> diferentes.</p>
                    </div>
                </div>
            </div>
        `
    },

    "troubleshooting": {
        category: "Guias",
        title: "Resolução de Problemas",
        breadcrumb: "Solução de Problemas",
        content: `
            <h1 class="page-title">Resolução de Problemas</h1>
            <p class="page-description">Problemas comuns relatados e seus métodos rápidos de correção.</p>

            <h2>Problemas Comuns</h2>

            <h3>1. A interface não carrega e gera o erro 'Drawing.new' is nil</h3>
            <p>Isso ocorre porque seu executor não suporta a biblioteca gráfica nativa de desenho <strong>Drawing API</strong> ou está operando com permissões restritas. Certifique-se de usar um executor compatível de nível avançado.</p>

            <h3>2. Cliques passam através da interface para o jogo (Mouse Bleeding)</h3>
            <p>O Lapo Hub X tenta sequestrar a prioridade de toque registrando uma ação de ContextActionService de nível 2000. Se outras ações do jogo estiverem vinculadas acima desse nível ou se o executor redefinir os manipuladores de entrada, os cliques podem passar.</p>
            <div class="alert alert-warning">
                <div class="alert-icon"><i class="ri-error-warning-line"></i></div>
                <div class="alert-content">
                    <div class="alert-title">Correção</div>
                    <p class="alert-text">Evite rodar múltiplos scripts de menu pesados simultaneamente, pois eles podem competir pelas portas prioritárias do ContextActionService.</p>
                </div>
            </div>

            <h3>3. A caixa de pesquisa do Dropdown não foca em dispositivos móveis</h3>
            <p>Em alguns executores móveis Android/iOS, a chamada de foco via CoreGui (<code>CaptureFocus</code>) é bloqueada ou requer um atraso adicional. A biblioteca já usa <code>task.defer()</code> para evitar isso. Caso a digitação pare de funcionar, clique fora para desfocar a caixa de seleção e clique nela novamente.</p>
        `
    },

    "changelog": {
        category: "Guias",
        title: "Histórico de Versões",
        breadcrumb: "Changelog",
        content: `
            <h1 class="page-title">Histórico de Versões (Changelog)</h1>
            <p class="page-description">Acompanhe as atualizações e melhorias contínuas do Lapo Hub X.</p>

            <div class="changelog-item">
                <h3>Versão v1.1.0 — Estabilidade & Performance <span class="badge badge-accent">Atual</span></h3>
                <p class="changelog-meta">Lançado em 20 de Junho de 2026</p>
                <p><strong>Correções visuais (clipping & foco)</strong></p>
                <ul class="list-default">
                    <li>Corrigido o popup de Dropdown que <strong>sumia (mas continuava clicável)</strong> quando a linha era rolada para fora da área visível — agora a visibilidade do popup é decidida pela área do próprio popup.</li>
                    <li>Corrigido o cursor da TextBox que <strong>flutuava para fora da caixa</strong> (e até da tela) em textos longos.</li>
                    <li>Eliminada a <strong>linha-fantasma</strong> que as bordas desenhavam no limite da área de conteúdo durante o scroll.</li>
                    <li>Corrigido o <strong>double-callback</strong> ao clicar fora de uma TextBox (o callback disparava duas vezes).</li>
                    <li>Foco do teclado agora é <strong>liberado de forma limpa</strong> ao ocultar/destruir a janela — sem mais inputs "presos".</li>
                    <li>Corrigido o mapeamento de letras e números no fallback de digitação por teclado.</li>
                </ul>
                <p><strong>Performance (CPU & memória)</strong></p>
                <ul class="list-default">
                    <li>Leitura do mouse e da câmera <strong>uma única vez por frame</strong> (antes era por botão/por frame).</li>
                    <li>Fim das alocações por frame no render loop: textos truncados agora são <strong>memoizados</strong> e helpers de visibilidade foram movidos para fora do loop.</li>
                    <li>Corrigido <strong>vazamento de memória</strong> de referências de abas que se acumulavam a cada reconstrução.</li>
                    <li>Cálculo do limite de rolagem (<code>maxOffset</code>) unificado em um único ponto, mais preciso e barato.</li>
                </ul>
                <p><strong>Comportamento dos widgets</strong></p>
                <ul class="list-default">
                    <li><code>Dropdown:Set({novasOpções})</code> agora reconstrói corretamente o estado interno (sem mais primeira-abertura com linhas em branco).</li>
                    <li><code>:Destroy()</code> e <code>:ToggleVisibility()</code> agora limpam foco e estado de dropdown aberto.</li>
                </ul>
                <div class="alert tip" style="margin-top: 16px;">
                    <div class="alert-icon"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="alert-content">
                        <div class="alert-title">100% retrocompatível</div>
                        <p class="alert-text">Nenhuma assinatura pública mudou. Scripts feitos para a v1.0.0 funcionam sem alteração — basta recarregar a biblioteca.</p>
                    </div>
                </div>
            </div>

            <div class="changelog-item">
                <h3>Versão v1.0.0 — Lançamento Oficial</h3>
                <p class="changelog-meta">Lançado em 15 de Junho de 2026</p>
                <ul class="list-default">
                    <li>Implementação do suporte completo a dispositivos móveis com escala adaptativa a viewports restritos.</li>
                    <li>Novo botão móvel flutuante inteligente (☰ / ✕) para controle de visibilidade rápida.</li>
                    <li>Melhoria profunda no sistema de entrada TextBox adicionando suporte a <code>CaptureFocus</code> seguro via ScreenGui de sink secundário.</li>
                    <li>Implementação do sistema de pesquisa integrada para Dropdown que suporta filtragem em tempo real de listas imensas de units.</li>
                    <li>Recalculo automático do tamanho total da janela e offsets de rolagem (rebuildContent) evitando cortes de widgets nas abas.</li>
                </ul>
            </div>
        `
    },

    "showcase": {
        category: "Showcase",
        title: "Simulador Interativo",
        breadcrumb: "Simulador",
        content: `
            <h1 class="page-title">Simulador Interativo da UI</h1>
            <p class="page-description">Experimente a interface do Lapo Hub X diretamente no navegador! Este painel simula os cliques, inputs e retornos que acontecem em tempo real no jogo.</p>

            <div class="simulator-outer">
                <!-- Roblox Topbar -->
                <div class="sim-roblox-topbar">
                    <div class="sim-topbar-left">
                        <div class="sim-topbar-icon"><i class="ri-game-line"></i></div>
                        <span>Roblox Player - Lapo Hub X Demo</span>
                    </div>
                    <div class="sim-topbar-right">
                        <span class="sim-topbar-btn">60 FPS</span>
                        <span>Ping: 12ms</span>
                    </div>
                </div>

                <!-- Game Workspace -->
                <div class="sim-game-workspace">
                    <div class="sim-game-grid"></div>

                    <!-- Botão Móvel Flutuante (Aparece se simularmos Mobile ou estiver ativo) -->
                    <div class="sim-mobile-btn" id="simMobileBtn" title="Toggle UI (Mobile Button)">
                        <i class="ri-menu-line"></i>
                    </div>

                    <!-- Notificações Virtuais Empilhadas -->
                    <div class="sim-notification-stack" id="simNotificationStack"></div>

                    <!-- Janela Principal do Lapo Hub X -->
                    <div class="sim-window" id="simWindow">
                        <!-- Header -->
                        <div class="sim-window-header" id="simWindowHeader">
                            <div class="sim-window-title-area">
                                <span class="sim-window-title" id="simWindowTitle">Lapo Hub X</span>
                                <span class="sim-window-subtitle">syn version</span>
                            </div>
                            <div class="sim-window-controls">
                                <div class="sim-ctrl-btn" id="simBtnMin" title="Minimizar">─</div>
                                <div class="sim-ctrl-btn close" id="simBtnClose" title="Fechar">✕</div>
                            </div>
                        </div>

                        <!-- Body -->
                        <div class="sim-window-body" id="simWindowBody">
                            <!-- Sidebar -->
                            <div class="sim-window-sidebar">
                                <div class="sim-window-tabs" id="simWindowTabs">
                                    <!-- Abas serão geradas via JS -->
                                </div>
                                <!-- User Footer -->
                                <div class="sim-window-user" id="simWindowUser">
                                    <div class="sim-user-status"></div>
                                    <div class="sim-user-details">
                                        <span class="sim-user-name" id="simUserName">LapoLapoNaldo</span>
                                        <span class="sim-user-rank" id="simUserRank">Lapo Newba</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Content -->
                            <div class="sim-window-content" id="simWindowContent">
                                <!-- Widgets serão carregados com base na aba ativa -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Painel de Controle e Console -->
            <div class="sim-controls-panel">
                <div class="sim-status-text">
                    <span>Estado do Simulador: <strong id="simStatusState">Ativo (Janela Aberta)</strong></span>
                </div>
                <div class="sim-action-btns">
                    <button class="btn btn-outline btn-sm" id="btnToggleSimScale"><i class="ri-smartphone-line"></i> Simular Celular (Touch)</button>
                    <button class="btn btn-primary btn-sm" id="btnTriggerSimNotification"><i class="ri-notification-badge-line"></i> Simular Notificação</button>
                    <button class="btn btn-outline btn-sm" id="btnResetSimWindow"><i class="ri-refresh-line"></i> Resetar Janela</button>
                </div>
            </div>

            <h3>Console de Retornos da API (Lua Log)</h3>
            <div class="code-block-container" style="margin-bottom: 0;">
                <div class="code-block-header" style="background-color: #05070a;">
                    <span class="code-language-tag" style="color: #6366f1;"><i class="ri-terminal-box-line"></i> Console de Execução</span>
                    <button class="copy-code-btn" id="btnClearConsole" style="font-size: 11px;"><i class="ri-delete-bin-line"></i> Limpar</button>
                </div>
                <pre style="background: #030408 !important; padding: 16px !important; max-height: 180px; overflow-y: auto;" id="simConsoleLog"><code class="language-txt" style="color: #a5b4fc; font-size: 12px; font-family: var(--font-mono);">-- Console pronto para capturar eventos de UI --
-- Clique nas abas e widgets da janela flutuante acima --</code></pre>
            </div>
        `
    }
};

const SIM_TABS = [
    {
        id: "combat",
        name: "Combate",
        icon: "⚔️",
        widgets: [
            { type: "label", text: "🔥 Automações de Ataque" },
            { type: "toggle", text: "Ativar Kill Aura", default: false, id: "killAura" },
            { type: "slider", text: "Distância do Alcance", min: 5, max: 50, default: 15, id: "auraRange" },
            { type: "separator" },
            { type: "dropdown", text: "Modo de Ataque", options: ["Mais Próximo", "Menor Vida", "Mais Forte"], default: 0, search: false, id: "attackMode" },
            { type: "button", text: "Executar Ultimate Instantâneo", id: "ultimateBtn" }
        ]
    },
    {
        id: "teleport",
        name: "Teleporte",
        icon: "🗺️",
        widgets: [
            { type: "label", text: "🗺️ Teleportar para Estágio" },
            { type: "dropdown", text: "Escolher Mapa", options: ["Mapa 1", "Mapa 2", "Mapa 3", "Mapa 4"], default: 0, search: true, id: "mapSelector" },
            { type: "button", text: "Iniciar Teleporte", id: "teleportBtn" },
            { type: "separator" },
            { type: "textbox", text: "Teleportar por Altura (Eixo Y)", placeholder: "Insira a altura...", id: "heightY" }
        ]
    },
    {
        id: "settings",
        name: "Ajustes",
        icon: "⚙️",
        widgets: [
            { type: "label", text: "⚙️ Preferências do Script" },
            { type: "toggle", text: "Bypassar Anti-Cheat", default: true, id: "bypassAnti" },
            { type: "slider", text: "FPS Cap do Menu", min: 30, max: 240, default: 60, id: "fpsCap" },
            { type: "paragraph", text: "Nota explicativa: O limitador de FPS atua reduzindo o frame-rate de renderização da Drawing API para diminuir o impacto no processador em computadores de baixo custo." }
        ]
    }
];

let simState = {
    visible: true,
    minimized: false,
    mobile: false,
    currentTabIdx: 0,
    widgetValues: {
        killAura: false,
        auraRange: 15,
        attackMode: "Mais Próximo",
        mapSelector: "Mapa 1",
        heightY: "",
        bypassAnti: true,
        fpsCap: 60
    }
};

document.addEventListener("DOMContentLoaded", () => {
    initApp();
});

function initApp() {
    setupTheme();
    setupRouting();
    setupNavigation();
    setupGlobalSearch();
    setupKeyboardShortcuts();
}

function setupTheme() {
    const themeToggleBtn = document.getElementById("themeToggleBtn");
    const html = document.documentElement;

    const savedTheme = localStorage.getItem("theme") || "light";
    html.setAttribute("data-theme", savedTheme);

    themeToggleBtn.addEventListener("click", () => {
        const currentTheme = html.getAttribute("data-theme");
        const newTheme = currentTheme === "dark" ? "light" : "dark";
        html.setAttribute("data-theme", newTheme);
        localStorage.setItem("theme", newTheme);
    });
}

function setupRouting() {
    window.addEventListener("hashchange", handleRouting);

    if (!window.location.hash) {
        window.location.hash = "#home";
    } else {
        handleRouting();
    }
}

function handleRouting() {
    const rawHash = window.location.hash || "#home";
    const route = rawHash.replace("#", "");

    const pageKey = PAGES[route] ? route : "home";
    const page = PAGES[pageKey];

    renderPage(pageKey, page);
}

function renderPage(pageKey, page) {
    const viewport = document.getElementById("contentViewport");

    document.documentElement.style.scrollBehavior = 'auto';
    window.scrollTo(0, 0);
    document.documentElement.style.scrollBehavior = '';

    viewport.style.opacity = 0;
    viewport.style.transform = "translateY(8px)";

    setTimeout(() => {

        viewport.innerHTML = page.content;

        updateBreadcrumbs(page.category, page.breadcrumb);

        updateActiveNavLinks(pageKey);

        if (typeof Prism !== "undefined") {
            Prism.highlightAll();
        }

        setupCodeCopyButtons();

        if (pageKey === "faq") {
            setupFaqAccordion();
        }

        if (pageKey === "showcase") {
            initSimulator();
        }

        document.documentElement.style.scrollBehavior = 'auto';
        window.scrollTo(0, 0);
        document.documentElement.style.scrollBehavior = '';

        viewport.style.opacity = 1;
        viewport.style.transform = "translateY(0)";
    }, 150);
}

function updateBreadcrumbs(category, activeItem) {
    const breadcrumb = document.getElementById("breadcrumb");
    breadcrumb.innerHTML = `
        <span class="breadcrumb-item">${category}</span>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-item active">${activeItem}</span>
    `;

    document.title = `Lapo Hub X | ${activeItem}`;
}

function updateActiveNavLinks(pageKey) {
    const navLinks = document.querySelectorAll(".nav-link");
    navLinks.forEach(link => {
        if (link.getAttribute("data-route") === pageKey) {
            link.classList.add("active");
        } else {
            link.classList.remove("active");
        }
    });
}

function setupNavigation() {
    const menuToggleBtn = document.getElementById("menuToggleBtn");
    const closeSidebarBtn = document.getElementById("closeSidebarBtn");
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("sidebarOverlay");

    function openSidebar() {
        sidebar.classList.add("active");
        overlay.classList.add("active");
    }

    function closeSidebar() {
        sidebar.classList.remove("active");
        overlay.classList.remove("active");
    }

    menuToggleBtn.addEventListener("click", openSidebar);
    closeSidebarBtn.addEventListener("click", closeSidebar);
    overlay.addEventListener("click", closeSidebar);

    const navLinks = document.querySelectorAll(".nav-link");
    navLinks.forEach(link => {
        link.addEventListener("click", () => {
            if (window.innerWidth <= 768) {
                closeSidebar();
            }
        });
    });
}

function setupGlobalSearch() {
    const searchInput = document.getElementById("searchInput");
    const searchResults = document.getElementById("searchResults");

    const searchDatabase = [];
    for (const [key, val] of Object.entries(PAGES)) {

        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = val.content;
        const text = tempDiv.textContent || tempDiv.innerText || "";

        searchDatabase.push({
            key: key,
            title: val.title,
            category: val.category,
            content: text,
            breadcrumb: val.breadcrumb
        });
    }

    searchInput.addEventListener("input", (e) => {
        const query = e.target.value.toLowerCase().trim();

        if (query === "") {
            searchResults.classList.remove("active");
            searchResults.innerHTML = "";
            return;
        }

        const matches = searchDatabase.filter(item => {
            return item.title.toLowerCase().includes(query) ||
                   item.content.toLowerCase().includes(query) ||
                   item.category.toLowerCase().includes(query);
        });

        renderSearchResults(matches, query);
    });

    document.addEventListener("click", (e) => {
        if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
            searchResults.classList.remove("active");
        }
    });

    document.addEventListener("keydown", (e) => {
        if (e.key === "/" && document.activeElement !== searchInput) {
            e.preventDefault();
            searchInput.focus();
        }
    });
}

function renderSearchResults(matches, query) {
    const searchResults = document.getElementById("searchResults");
    searchResults.innerHTML = "";

    if (matches.length === 0) {
        searchResults.innerHTML = `<div class="search-result-empty">Nenhum resultado encontrado para "${query}"</div>`;
        searchResults.classList.add("active");
        return;
    }

    matches.slice(0, 5).forEach(item => {
        const itemElement = document.createElement("div");
        itemElement.className = "search-result-item";

        const idx = item.content.toLowerCase().indexOf(query);
        let snippet = "";
        if (idx !== -1) {
            const start = Math.max(0, idx - 20);
            const end = Math.min(item.content.length, idx + query.length + 30);
            snippet = (start > 0 ? "..." : "") + item.content.substring(start, end).trim() + "...";
        } else {
            snippet = item.content.substring(0, 50).trim() + "...";
        }

        itemElement.innerHTML = `
            <span class="search-result-category">${item.category} / ${item.breadcrumb}</span>
            <span class="search-result-title">${item.title}</span>
            <span class="search-result-snippet">${escapeHtml(snippet)}</span>
        `;

        itemElement.addEventListener("click", () => {
            window.location.hash = `#${item.key}`;
            searchResults.classList.remove("active");
            document.getElementById("searchInput").value = "";
        });

        searchResults.appendChild(itemElement);
    });

    searchResults.classList.add("active");
}

function escapeHtml(text) {
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

// ----------------------------------------------------------------------
// CODE BLOCK COPY HANDLERS
// ----------------------------------------------------------------------
function setupCodeCopyButtons() {
    const copyBtns = document.querySelectorAll(".copy-code-btn");

    copyBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            const container = btn.closest(".code-block-container");
            const codeEl = container.querySelector("pre code");
            const rawText = codeEl.textContent;

            navigator.clipboard.writeText(rawText).then(() => {
                btn.innerHTML = `<i class="ri-check-line" style="color: var(--success)"></i> Copiado!`;
                setTimeout(() => {
                    btn.innerHTML = `<i class="ri-file-copy-line"></i> Copiar`;
                }, 2000);
            }).catch(err => {
                console.error("Falha ao copiar código: ", err);
            });
        });
    });
}

// ----------------------------------------------------------------------
// KEYBOARD SHORTCUTS
// ----------------------------------------------------------------------
function setupKeyboardShortcuts() {
    const searchInput = document.getElementById("searchInput");

    document.addEventListener("keydown", (e) => {
        // Escape clear input
        if (e.key === "Escape" && document.activeElement === searchInput) {
            searchInput.value = "";
            searchInput.blur();
            document.getElementById("searchResults").classList.remove("active");
        }
    });
}

// ----------------------------------------------------------------------
// FAQ ACCORDION HANDLERS
// ----------------------------------------------------------------------
function setupFaqAccordion() {
    const questions = document.querySelectorAll(".faq-question");

    questions.forEach(q => {
        q.addEventListener("click", () => {
            const item = q.closest(".faq-item");
            const isActive = item.classList.contains("active");

            // Close all
            document.querySelectorAll(".faq-item").forEach(i => i.classList.remove("active"));

            // Toggle current
            if (!isActive) {
                item.classList.add("active");
            }
        });
    });
}

// ==========================================================================
// VIRTUAL INTERACTIVE SIMULATOR (SHOWCASE) ENGINE
// ==========================================================================

function initSimulator() {
    simState = {
        visible: true,
        minimized: false,
        mobile: false,
        currentTabIdx: 0,
        widgetValues: {
            killAura: false,
            auraRange: 15,
            attackMode: "Mais Próximo",
            mapSelector: "Mapa 1",
            heightY: "",
            bypassAnti: true,
            fpsCap: 60
        }
    };

    simLog("LapoHub:Init() executado via console virtual.");
    simLog("Aguardando interações na janela do Roblox...");

    // Attach Simulator control events
    document.getElementById("btnTriggerSimNotification").addEventListener("click", triggerSimNotify);
    document.getElementById("btnToggleSimScale").addEventListener("click", toggleSimScale);
    document.getElementById("btnResetSimWindow").addEventListener("click", resetSimWindow);
    document.getElementById("btnClearConsole").addEventListener("click", clearSimConsole);

    // Attach window headers control events
    document.getElementById("simBtnMin").addEventListener("click", toggleSimMinimize);
    document.getElementById("simBtnClose").addEventListener("click", toggleSimClose);
    document.getElementById("simMobileBtn").addEventListener("click", toggleSimClose);
    document.getElementById("simWindowUser").addEventListener("click", triggerUserCallback);

    renderSimTabs();
    renderSimWidgets();
}

function simLog(msg) {
    const logBox = document.getElementById("simConsoleLog");
    if (!logBox) return;

    const timestamp = new Date().toLocaleTimeString();

    // Check if default info text is present
    if (logBox.textContent.includes("-- Console pronto")) {
        logBox.textContent = "";
    }

    logBox.textContent += `[${timestamp}] ${msg}\n`;
    logBox.scrollTop = logBox.scrollHeight;
}

function clearSimConsole() {
    const logBox = document.getElementById("simConsoleLog");
    if (logBox) {
        logBox.textContent = "-- Logs limpos pelo usuário --\n";
    }
}

function triggerSimNotify() {
    createSimNotification("Notificação Externa", "Esta é uma notificação simulada de teste!", 4);
}

function createSimNotification(title, content, duration) {
    const stack = document.getElementById("simNotificationStack");
    if (!stack) return;

    const notif = document.createElement("div");
    notif.className = "sim-notification";
    notif.innerHTML = `
        <span class="sim-notif-title">${title}</span>
        <span class="sim-notif-content">${content}</span>
        <div class="sim-notif-bar"></div>
    `;

    stack.appendChild(notif);
    simLog(`[LapoHub Callback] Notify disparado: "${title}" - ${content}`);

    // Remove notification after 4s (sync with animation)
    setTimeout(() => {
        notif.style.opacity = 0;
        notif.style.transform = "translateX(50px)";
        setTimeout(() => {
            notif.remove();
        }, 300);
    }, (duration || 4) * 1000);

    // Allow clicking to close notification early
    notif.addEventListener("click", () => {
        notif.remove();
        simLog(`[LapoHub Callback] Notificação fechada prematuramente pelo usuário.`);
    });
}

function toggleSimScale() {
    const windowEl = document.getElementById("simWindow");
    const mobileBtn = document.getElementById("simMobileBtn");
    const statusState = document.getElementById("simStatusState");
    const toggleScaleBtn = document.getElementById("btnToggleSimScale");

    simState.mobile = !simState.mobile;

    if (simState.mobile) {
        windowEl.style.transform = "scale(0.8) translate(-10%, -10%)";
        windowEl.style.width = "400px";
        windowEl.style.height = "260px";
        mobileBtn.style.display = "flex";
        toggleScaleBtn.innerHTML = `<i class="ri-computer-line"></i> Simular Computador (Desktop)`;
        simLog("[LapoHub Config] Escala alterada para Mobile (escala global: 0.72x).");
    } else {
        windowEl.style.transform = "scale(1)";
        windowEl.style.width = "";
        windowEl.style.height = "";
        mobileBtn.style.display = "none";
        toggleScaleBtn.innerHTML = `<i class="ri-smartphone-line"></i> Simular Celular (Touch)`;
        simLog("[LapoHub Config] Escala redefinida para Computador (escala global: 1.0x).");
    }
}

function resetSimWindow() {
    const windowEl = document.getElementById("simWindow");
    const mobileBtn = document.getElementById("simMobileBtn");
    const statusState = document.getElementById("simStatusState");
    const toggleScaleBtn = document.getElementById("btnToggleSimScale");

    simState.visible = true;
    simState.minimized = false;
    simState.mobile = false;
    simState.currentTabIdx = 0;

    windowEl.classList.remove("minimized");
    windowEl.classList.remove("hidden");
    windowEl.style.transform = "scale(1)";
    windowEl.style.width = "";
    windowEl.style.height = "";
    mobileBtn.style.display = "none";
    toggleScaleBtn.innerHTML = `<i class="ri-smartphone-line"></i> Simular Celular (Touch)`;
    statusState.innerHTML = "Ativo (Janela Aberta)";

    renderSimTabs();
    renderSimWidgets();
    clearSimConsole();
    simLog("LapoHub resetado com sucesso.");
}

function toggleSimMinimize() {
    const windowEl = document.getElementById("simWindow");
    simState.minimized = !simState.minimized;

    if (simState.minimized) {
        windowEl.classList.add("minimized");
        document.getElementById("simBtnMin").innerText = "❐";
        document.getElementById("simStatusState").innerHTML = "Minimizado";
        simLog("[LapoHub Window] Interface minimizada.");
    } else {
        windowEl.classList.remove("minimized");
        document.getElementById("simBtnMin").innerText = "─";
        document.getElementById("simStatusState").innerHTML = "Ativo (Janela Aberta)";
        simLog("[LapoHub Window] Interface restaurada.");
    }
}

function toggleSimClose() {
    const windowEl = document.getElementById("simWindow");
    simState.visible = !simState.visible;

    if (simState.visible) {
        windowEl.classList.remove("hidden");
        document.getElementById("simStatusState").innerHTML = "Ativo (Janela Aberta)";
        simLog("[LapoHub Window] Interface exibida.");
    } else {
        windowEl.classList.add("hidden");
        document.getElementById("simStatusState").innerHTML = "Oculto (Use o botão Mobile ou tecla de atalho)";
        simLog("[LapoHub Window] Interface ocultada.");
        if (simState.mobile) {
            createSimNotification("Dica", "Clique no botão flutuante para reabrir a janela principal.", 3);
        }
    }
}

function triggerUserCallback() {
    simLog(`[LapoHub Callback] Perfil clicado! userName: "LapoLapoNaldo", userRank: "Lapo Newba"`);
    createSimNotification("Perfil", "Usuário: LapoLapoNaldo | Rank: Lapo Newba", 3);
}

// ----------------------------------------------------------------------
// RENDER TAB LIST IN SIMULATOR
// ----------------------------------------------------------------------
function renderSimTabs() {
    const tabContainer = document.getElementById("simWindowTabs");
    if (!tabContainer) return;

    tabContainer.innerHTML = "";

    SIM_TABS.forEach((tab, index) => {
        const item = document.createElement("div");
        item.className = `sim-tab-item ${index === simState.currentTabIdx ? 'active' : ''}`;
        item.innerHTML = `<span>${tab.icon}</span> ${tab.name}`;

        item.addEventListener("click", () => {
            if (simState.currentTabIdx === index) return;
            simState.currentTabIdx = index;
            renderSimTabs();
            renderSimWidgets();
            simLog(`[LapoHub Tab] Mudança de aba: "${tab.name}" (Index: ${index + 1})`);
        });

        tabContainer.appendChild(item);
    });
}

// ----------------------------------------------------------------------
// RENDER WIDGETS IN SELECTED TAB
// ----------------------------------------------------------------------
function renderSimWidgets() {
    const contentContainer = document.getElementById("simWindowContent");
    if (!contentContainer) return;

    contentContainer.innerHTML = "";
    const currentTab = SIM_TABS[simState.currentTabIdx];

    currentTab.widgets.forEach(w => {
        let el = document.createElement("div");

        if (w.type === "label") {
            el.className = "sim-widget-label";
            el.innerText = w.text;
        }

        else if (w.type === "paragraph") {
            el.className = "sim-widget-paragraph";
            el.innerText = w.text;
        }

        else if (w.type === "separator") {
            el.className = "sim-widget-separator";
        }

        else if (w.type === "button") {
            el.className = "sim-widget button";
            el.innerHTML = `<span class="sim-widget-title">${w.text}</span>`;

            el.addEventListener("click", () => {
                simLog(`[LapoHub Callback] Botão acionado: "${w.text}"`);
            });
        }

        else if (w.type === "toggle") {
            el.className = `sim-widget toggle ${simState.widgetValues[w.id] ? 'active' : ''}`;
            el.innerHTML = `
                <span class="sim-widget-title">${w.text}</span>
                <div class="sim-toggle-track">
                    <div class="sim-toggle-knob"></div>
                </div>
            `;

            el.addEventListener("click", () => {
                simState.widgetValues[w.id] = !simState.widgetValues[w.id];
                el.classList.toggle("active");
                simLog(`[LapoHub Callback] Toggle "${w.text}": ${simState.widgetValues[w.id]}`);
            });
        }

        else if (w.type === "slider") {
            const val = simState.widgetValues[w.id];
            const pct = ((val - w.min) / (w.max - w.min)) * 100;

            el.className = "sim-widget slider";
            el.innerHTML = `
                <div class="sim-widget-header">
                    <span class="sim-widget-title">${w.text}</span>
                    <span class="sim-slider-value" id="simVal_${w.id}">${val}</span>
                </div>
                <div class="sim-slider-track" id="simTrack_${w.id}">
                    <div class="sim-slider-fill" style="width: ${pct}%"></div>
                    <div class="sim-slider-thumb" style="left: ${pct}%"></div>
                </div>
            `;

            // Make slider draggable
            setTimeout(() => {
                const track = document.getElementById(`simTrack_${w.id}`);
                if (!track) return;

                function updateSliderPosition(clientX) {
                    const rect = track.getBoundingClientRect();
                    const valPct = Math.min(Math.max(0, (clientX - rect.left) / rect.width), 1);
                    const rawVal = w.min + valPct * (w.max - w.min);
                    const finalVal = Math.floor(rawVal);

                    simState.widgetValues[w.id] = finalVal;

                    track.querySelector(".sim-slider-fill").style.width = `${valPct * 100}%`;
                    track.querySelector(".sim-slider-thumb").style.left = `${valPct * 100}%`;
                    document.getElementById(`simVal_${w.id}`).innerText = finalVal;
                }

                track.addEventListener("mousedown", (e) => {
                    updateSliderPosition(e.clientX);
                    simLog(`[LapoHub Callback] Slider "${w.text}" iniciado: ${simState.widgetValues[w.id]}`);

                    function mouseMoveHandler(evt) {
                        updateSliderPosition(evt.clientX);
                    }

                    function mouseUpHandler() {
                        simLog(`[LapoHub Callback] Slider "${w.text}" finalizado em: ${simState.widgetValues[w.id]}`);
                        window.removeEventListener("mousemove", mouseMoveHandler);
                        window.removeEventListener("mouseup", mouseUpHandler);
                    }

                    window.addEventListener("mousemove", mouseMoveHandler);
                    window.addEventListener("mouseup", mouseUpHandler);
                });

                // Add touch support
                track.addEventListener("touchstart", (e) => {
                    updateSliderPosition(e.touches[0].clientX);
                    simLog(`[LapoHub Callback] Slider "${w.text}" iniciado (touch): ${simState.widgetValues[w.id]}`);

                    function touchMoveHandler(evt) {
                        updateSliderPosition(evt.touches[0].clientX);
                    }

                    function touchEndHandler() {
                        simLog(`[LapoHub Callback] Slider "${w.text}" finalizado (touch) em: ${simState.widgetValues[w.id]}`);
                        window.removeEventListener("touchmove", touchMoveHandler);
                        window.removeEventListener("touchend", touchEndHandler);
                    }

                    window.addEventListener("touchmove", touchMoveHandler);
                    window.addEventListener("touchend", touchEndHandler);
                });
            }, 0);
        }

        else if (w.type === "dropdown") {
            const currentSel = simState.widgetValues[w.id];

            el.className = "sim-widget dropdown";
            el.innerHTML = `
                <span class="sim-widget-title">${w.text}</span>
                <div class="sim-dropdown-display">
                    <span id="simDisplay_${w.id}">${currentSel}</span>
                    <i class="ri-arrow-down-s-fill sim-dropdown-arrow"></i>
                </div>
                <div class="sim-dropdown-popup" id="simPopup_${w.id}">
                    ${w.options.map(opt => `
                        <div class="sim-dropdown-item ${opt === currentSel ? 'selected' : ''}" data-value="${opt}">${opt}</div>
                    `).join('')}
                </div>
            `;

            // Toggle Popup display
            setTimeout(() => {
                const display = el.querySelector(".sim-dropdown-display");
                const popup = document.getElementById(`simPopup_${w.id}`);

                display.addEventListener("click", (e) => {
                    e.stopPropagation();

                    // Close other dropdowns first
                    document.querySelectorAll(".sim-dropdown-popup").forEach(p => {
                        if (p !== popup) p.classList.remove("active");
                    });

                    popup.classList.toggle("active");
                });

                // Select option click
                const items = popup.querySelectorAll(".sim-dropdown-item");
                items.forEach((item, index) => {
                    item.addEventListener("click", (e) => {
                        e.stopPropagation();
                        const val = item.getAttribute("data-value");
                        simState.widgetValues[w.id] = val;

                        document.getElementById(`simDisplay_${w.id}`).innerText = val;
                        popup.classList.remove("active");

                        // Update selected class
                        items.forEach(i => i.classList.remove("selected"));
                        item.classList.add("selected");

                        simLog(`[LapoHub Callback] Dropdown "${w.text}" item selecionado: "${val}" (Index: ${index + 1})`);
                    });
                });

                // Hide popup when clicking workspace
                document.addEventListener("click", () => {
                    popup.classList.remove("active");
                });
            }, 0);
        }

        else if (w.type === "textbox") {
            const currentVal = simState.widgetValues[w.id];
            el.className = "sim-widget textbox";
            el.innerHTML = `
                <span class="sim-widget-title">${w.text}</span>
                <div class="sim-textbox-input">
                    <span id="simVal_${w.id}">${currentVal || w.placeholder}</span>
                    <div class="sim-textbox-cursor"></div>
                </div>
            `;

            setTimeout(() => {
                const inputArea = el.querySelector(".sim-textbox-input");

                inputArea.addEventListener("click", (e) => {
                    e.stopPropagation();

                    // Defocus all other textboxes first
                    document.querySelectorAll(".sim-widget.textbox").forEach(box => {
                        box.classList.remove("active");
                    });

                    el.classList.add("active");
                    simLog(`[LapoHub Input] TextBox "${w.text}" em foco.`);

                    // Create a prompt to simulate Roblox input typing in the browser
                    setTimeout(() => {
                        const userText = prompt(`[Simulador Roblox] Digite o valor para a TextBox "${w.text}":`, simState.widgetValues[w.id]);
                        el.classList.remove("active");

                        if (userText !== null) {
                            simState.widgetValues[w.id] = userText;
                            document.getElementById(`simVal_${w.id}`).innerText = userText || w.placeholder;
                            document.getElementById(`simVal_${w.id}`).style.color = userText ? "var(--sim-text)" : "var(--sim-text-muted)";
                            simLog(`[LapoHub Callback] TextBox "${w.text}" valor alterado: "${userText}"`);
                        } else {
                            simLog(`[LapoHub Input] Digitação cancelada.`);
                        }
                    }, 100);
                });

                // Remove focus clicking elsewhere
                document.addEventListener("click", () => {
                    el.classList.remove("active");
                });
            }, 0);
        }

        contentContainer.appendChild(el);
    });
}
