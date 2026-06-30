const PROJECT = {
    title: "Lapo Library X",
    subtitle: "Made By Luvwas",
    defaultRoute: "home",
    pageContent: true,
    switchEnabled: false
};

const PAGES = {
    "home": {
        category: "Começando",
        title: "Lapo Library X",
        breadcrumb: "Sobre",
        faq: false,
        search: "v1.0.0 — Drawing API Lapo Library X Biblioteca de interface para Roblox renderizada 100% via Drawing API (overlay), sem depender de CoreGui/PlayerGui. Loading animado, micro-interações suaves, dropdown com busca, notificações e suporte a mobile — tudo numa API fluida. Começar agora GitHub Por que usar Overlay puro Tudo desenhado com Drawing.new . Funciona onde GUI tradicional é bloqueada — sem CoreGui/PlayerGui. Loading cinematográfico Abertura com fade-in, scale-pop, spinner *comet* e barra de progresso com brilho. Micro-interações Hover/press suaves em todos os widgets, knob e thumb animados, e indicador de aba que desliza. Mobile-ready Detecta toque, ajusta escala e mostra um botão flutuante para abrir/fechar. Índice de Métodos Tudo que a LapoX expõe. Os detalhes de cada um estão nas páginas seguintes. Categoria Método O que faz Setup Init(config) Inicializa e exibe a janela. Setup AddTab(name, icon) Cria uma aba na sidebar. Widget AddButton(tab, cfg) Botão clicável. Widget AddToggle(tab, cfg) Interruptor on/off. Widget AddSlider(tab, cfg) Barra de valor. Widget AddDropdown(tab, cfg) Seleção com busca opcional. Widget AddTextBox(tab, cfg) Campo de texto. Widget AddLabel(tab, cfg) Rótulo de texto. Widget AddParagraph(tab, cfg) Parágrafo (texto longo). Widget AddSeparator(tab) Linha divisória. Feedback Notify(cfg) Notificação no canto da tela. Rodapé SetUser(name, rank) Nome/cargo no rodapé. Rodapé SetUserCallback(cb) Clique no rodapé. Janela ToggleVisibility() Mostra/esconde a UI. Janela Destroy() Remove tudo e desconecta eventos. Loading ShowLoading(cfg) Abre a tela de carregamento. Loading SetLoadingProgress(pct, msg) Progresso manual (0–1). Loading SetLoadingMessage(msg) Troca a mensagem. Loading QueueLoad(label, fn) Enfileira uma tarefa. Loading RunLoadQueue(onDone) Roda a fila e fecha. Loading FinishLoading(onDone) Fecha o loading manualmente. Perf BeginBatch() / EndBatch() Adiciona muitos widgets sem rebuild. Encadeamento Métodos de setup ( Init , SetUser , AddTab , AddSeparator , loading) retornam self , então dá pra encadear. Já os Add* de widget retornam um handle (veja Handles & :Set() ).",
        content: "\n            <div class=\"hero-section\">\n                <span class=\"badge badge-primary\">v1.0.0 — Drawing API</span>\n                <h1 class=\"page-title\" id=\"lapo-library-x\" style=\"margin-top: 10px;\">Lapo Library X</h1>\n                <p class=\"page-description\">Biblioteca de interface para Roblox renderizada 100% via Drawing API (overlay), sem depender de CoreGui/PlayerGui. Loading animado, micro-interações suaves, dropdown com busca, notificações e suporte a mobile — tudo numa API fluida.</p>\n                <div class=\"action-group\"><a href=\"#inicio-rapido\" class=\"btn btn-primary\"><i class=\"ri-rocket-line\"></i> Começar agora</a>\n                    <a href=\"https://github.com/LapoLapoNaldo/Lapo-X\" class=\"btn btn-outline\" target=\"_blank\"><i class=\"ri-external-link-line\"></i> GitHub</a></div>\n            </div>\n\n            <h2 id=\"por-que-usar\">Por que usar</h2>\n\n            <div class=\"grid-2\">\n\n                <div class=\"card\">\n                    <div class=\"card-title\"><i class=\"ri-stack-line\"></i> Overlay puro</div>\n                    <p class=\"card-description\">Tudo desenhado com <code>Drawing.new</code>. Funciona onde GUI tradicional é bloqueada — sem CoreGui/PlayerGui.</p>\n                </div>\n\n                <div class=\"card\">\n                    <div class=\"card-title\"><i class=\"ri-loader-4-line\"></i> Loading cinematográfico</div>\n                    <p class=\"card-description\">Abertura com fade-in, scale-pop, spinner *comet* e barra de progresso com brilho.</p>\n                </div>\n\n                <div class=\"card\">\n                    <div class=\"card-title\"><i class=\"ri-cursor-line\"></i> Micro-interações</div>\n                    <p class=\"card-description\">Hover/press suaves em todos os widgets, knob e thumb animados, e indicador de aba que desliza.</p>\n                </div>\n\n                <div class=\"card\">\n                    <div class=\"card-title\"><i class=\"ri-smartphone-line\"></i> Mobile-ready</div>\n                    <p class=\"card-description\">Detecta toque, ajusta escala e mostra um botão flutuante para abrir/fechar.</p>\n                </div>\n            </div>\n\n            <h2 id=\"indice-de-metodos\">Índice de Métodos</h2>\n\n            <p>Tudo que a <code>LapoX</code> expõe. Os detalhes de cada um estão nas páginas seguintes.</p>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Categoria</th>\n                            <th>Método</th>\n                            <th>O que faz</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td>Setup</td>\n                            <td><code>Init(config)</code></td>\n                            <td>Inicializa e exibe a janela.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Setup</td>\n                            <td><code>AddTab(name, icon)</code></td>\n                            <td>Cria uma aba na sidebar.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddButton(tab, cfg)</code></td>\n                            <td>Botão clicável.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddToggle(tab, cfg)</code></td>\n                            <td>Interruptor on/off.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddSlider(tab, cfg)</code></td>\n                            <td>Barra de valor.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddDropdown(tab, cfg)</code></td>\n                            <td>Seleção com busca opcional.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddTextBox(tab, cfg)</code></td>\n                            <td>Campo de texto.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddLabel(tab, cfg)</code></td>\n                            <td>Rótulo de texto.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddParagraph(tab, cfg)</code></td>\n                            <td>Parágrafo (texto longo).</td>\n                        </tr>\n\n                        <tr>\n                            <td>Widget</td>\n                            <td><code>AddSeparator(tab)</code></td>\n                            <td>Linha divisória.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Feedback</td>\n                            <td><code>Notify(cfg)</code></td>\n                            <td>Notificação no canto da tela.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Rodapé</td>\n                            <td><code>SetUser(name, rank)</code></td>\n                            <td>Nome/cargo no rodapé.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Rodapé</td>\n                            <td><code>SetUserCallback(cb)</code></td>\n                            <td>Clique no rodapé.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Janela</td>\n                            <td><code>ToggleVisibility()</code></td>\n                            <td>Mostra/esconde a UI.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Janela</td>\n                            <td><code>Destroy()</code></td>\n                            <td>Remove tudo e desconecta eventos.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Loading</td>\n                            <td><code>ShowLoading(cfg)</code></td>\n                            <td>Abre a tela de carregamento.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Loading</td>\n                            <td><code>SetLoadingProgress(pct, msg)</code></td>\n                            <td>Progresso manual (0–1).</td>\n                        </tr>\n\n                        <tr>\n                            <td>Loading</td>\n                            <td><code>SetLoadingMessage(msg)</code></td>\n                            <td>Troca a mensagem.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Loading</td>\n                            <td><code>QueueLoad(label, fn)</code></td>\n                            <td>Enfileira uma tarefa.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Loading</td>\n                            <td><code>RunLoadQueue(onDone)</code></td>\n                            <td>Roda a fila e fecha.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Loading</td>\n                            <td><code>FinishLoading(onDone)</code></td>\n                            <td>Fecha o loading manualmente.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Perf</td>\n                            <td><code>BeginBatch()</code> / <code>EndBatch()</code></td>\n                            <td>Adiciona muitos widgets sem rebuild.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert tip\">\n                <div class=\"alert-icon\"><i class=\"ri-lightbulb-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Encadeamento</div>\n                    <p class=\"alert-text\">Métodos de setup (<code>Init</code>, <code>SetUser</code>, <code>AddTab</code>, <code>AddSeparator</code>, loading) retornam <code>self</code>, então dá pra encadear. Já os <code>Add*</code> de widget retornam um <strong>handle</strong> (veja <strong>Handles &amp; :Set()</strong>).</p>\n                </div>\n            </div>"
    },
    "carregamento": {
        category: "Começando",
        title: "Carregar a Library",
        breadcrumb: "Carregamento",
        faq: false,
        search: "Carregar a Library A lib retorna a tabela LapoX . Use o arquivo local quando existir e caia para o GitHub como fallback. Local + Fallback Só GitHub Lua Copiar local LapoX local ok, lib = pcall(function() return loadstring(readfile(\"Library.lua\"))() end) if ok and lib then LapoX = lib else LapoX = loadstring(game:HttpGet( \"https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua\" ))() end Lua Copiar local LapoX = loadstring(game:HttpGet( \"https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua\" ))() Reexecução sem duplicar Sempre destrua a instância anterior ao rodar o script de novo. A própria lib já faz isso por título (veja a nota), mas guardar num global é mais seguro: Lua Copiar if _G._Lapo then pcall(function() _G._Lapo:Destroy() end) end -- ... carregar e montar a UI ... _G._Lapo = LapoX Singleton por título No Init , a lib guarda a instância em shared[\"LapoLibraryInstance_\" .. Title] e destrói automaticamente uma instância anterior com o mesmo título . Títulos diferentes geram janelas independentes.",
        content: "\n            <h1 class=\"page-title\" id=\"carregar-a-library\">Carregar a Library</h1>\n\n            <p>A lib retorna a tabela <code>LapoX</code>. Use o arquivo local quando existir e caia para o GitHub como fallback.</p>\n\n            <div class=\"tabs-container\">\n                <div class=\"tabs-header\">\n                    <button class=\"tab-btn active\" data-tab=\"0\"><i class=\"ri-git-repository-line\"></i> Local + Fallback</button>\n<button class=\"tab-btn\" data-tab=\"1\"><i class=\"ri-cloud-line\"></i> Só GitHub</button>\n                </div>\n                <div class=\"tabs-body\">\n                    <div class=\"tab-content active\" data-tab=\"0\">\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local LapoX\nlocal ok, lib = pcall(function()\n    return loadstring(readfile(\"Library.lua\"))()\nend)\nif ok and lib then\n    LapoX = lib\nelse\n    LapoX = loadstring(game:HttpGet(\n        \"https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua\"\n    ))()\nend</code></pre>\n            </div>\n            </div>\n<div class=\"tab-content\" data-tab=\"1\">\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local LapoX = loadstring(game:HttpGet(\n    \"https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua\"\n))()</code></pre>\n            </div>\n            </div>\n                </div>\n            </div>\n\n            <h2 id=\"reexecucao-sem-duplicar\">Reexecução sem duplicar</h2>\n\n            <p>Sempre destrua a instância anterior ao rodar o script de novo. A própria lib já faz isso por título (veja a nota), mas guardar num global é mais seguro:</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>if _G._Lapo then pcall(function() _G._Lapo:Destroy() end) end\n-- ... carregar e montar a UI ...\n_G._Lapo = LapoX</code></pre>\n            </div>\n\n            <div class=\"alert info\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Singleton por título</div>\n                    <p class=\"alert-text\">No <code>Init</code>, a lib guarda a instância em <code>shared[&quot;LapoLibraryInstance_&quot; .. Title]</code> e <strong>destrói automaticamente</strong> uma instância anterior com o <strong>mesmo título</strong>. Títulos diferentes geram janelas independentes.</p>\n                </div>\n            </div>"
    },
    "inicio-rapido": {
        category: "Começando",
        title: "Início Rápido",
        breadcrumb: "Início Rápido",
        faq: false,
        search: "Início Rápido Exemplo completo: abas, widgets variados, notificação e rodapé. Lua Copiar local LapoX = loadstring(game:HttpGet( \"https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua\" ))() -- 1) Abas ANTES do Init LapoX:AddTab(\"Principal\", \"🏠\") LapoX:AddTab(\"Config\", \"⚙️\") -- 2) Inicializa LapoX:Init({ Title = \"Meu Script\", ToggleKey = \"K\" }) LapoX:SetUser(\"Player\", \"Premium\") -- 3) Widgets (podem vir depois do Init) LapoX:AddButton(\"Principal\", { text = \"Executar\", callback = function() LapoX:Notify({ title = \"OK\", content = \"Rodou!\", duration = 3 }) end, }) local speed = LapoX:AddSlider(\"Config\", { text = \"Velocidade\", min = 0, max = 100, default = 50, callback = function(v) print(\"speed:\", v) end, }) speed:Set(80) -- altera por código Ordem recomendada ShowLoading (opcional) → AddTab (todas) → Init → Add* widgets. Abas adicionadas depois do Init também funcionam, mas declarar antes deixa o fluxo mais limpo.",
        content: "\n            <h1 class=\"page-title\" id=\"inicio-rapido\">Início Rápido</h1>\n\n            <p>Exemplo completo: abas, widgets variados, notificação e rodapé.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local LapoX = loadstring(game:HttpGet(\n    \"https://raw.githubusercontent.com/LapoLapoNaldo/Lapo-X/refs/heads/main/Library.lua\"\n))()\n\n-- 1) Abas ANTES do Init\nLapoX:AddTab(\"Principal\", \"🏠\")\nLapoX:AddTab(\"Config\", \"⚙️\")\n\n-- 2) Inicializa\nLapoX:Init({ Title = \"Meu Script\", ToggleKey = \"K\" })\nLapoX:SetUser(\"Player\", \"Premium\")\n\n-- 3) Widgets (podem vir depois do Init)\nLapoX:AddButton(\"Principal\", {\n    text = \"Executar\",\n    callback = function()\n        LapoX:Notify({ title = \"OK\", content = \"Rodou!\", duration = 3 })\n    end,\n})\n\nlocal speed = LapoX:AddSlider(\"Config\", {\n    text = \"Velocidade\", min = 0, max = 100, default = 50,\n    callback = function(v) print(\"speed:\", v) end,\n})\n\nspeed:Set(80) -- altera por código</code></pre>\n            </div>\n\n            <div class=\"alert important\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Ordem recomendada</div>\n                    <p class=\"alert-text\"><code>ShowLoading</code> (opcional) → <code>AddTab</code> (todas) → <code>Init</code> → <code>Add*</code> widgets. Abas adicionadas <strong>depois</strong> do <code>Init</code> também funcionam, mas declarar antes deixa o fluxo mais limpo.</p>\n                </div>\n            </div>"
    },
    "ciclo-de-vida": {
        category: "Começando",
        title: "Ciclo de Vida",
        breadcrumb: "Ciclo de Vida",
        faq: false,
        search: "Ciclo de Vida O caminho completo de uma sessão, do load ao destroy. Carregar a lib ( loadstring ). (Opcional) ShowLoading — abre a tela animada e ativa o modo batch internamente. AddTab — registre as abas. Init — cria a janela, detecta mobile, monta input e começa a renderizar. Add* — adicione widgets nas abas. (Opcional) QueueLoad + RunLoadQueue — roda tarefas e fecha o loading com fade-out. Runtime — :Set() nos handles, Notify , ToggleVisibility ... Destroy — ao encerrar, limpa desenhos e conexões. Loading suprime rebuilds Enquanto o loading está ativo, a UI entra em modo batch automaticamente — todos os widgets adicionados nesse período só são montados de uma vez quando o loading termina. Isso deixa a abertura bem mais rápida.",
        content: "\n            <h1 class=\"page-title\" id=\"ciclo-de-vida\">Ciclo de Vida</h1>\n\n            <p>O caminho completo de uma sessão, do load ao destroy.</p>\n\n            <ol class=\"list-default\">\n                <li><strong>Carregar</strong> a lib (<code>loadstring</code>).</li>\n                <li><strong>(Opcional) <code>ShowLoading</code></strong> — abre a tela animada e ativa o modo batch internamente.</li>\n                <li><strong><code>AddTab</code></strong> — registre as abas.</li>\n                <li><strong><code>Init</code></strong> — cria a janela, detecta mobile, monta input e começa a renderizar.</li>\n                <li><strong><code>Add*</code></strong> — adicione widgets nas abas.</li>\n                <li><strong>(Opcional) <code>QueueLoad</code> + <code>RunLoadQueue</code></strong> — roda tarefas e fecha o loading com fade-out.</li>\n                <li><strong>Runtime</strong> — <code>:Set()</code> nos handles, <code>Notify</code>, <code>ToggleVisibility</code>...</li>\n                <li><strong><code>Destroy</code></strong> — ao encerrar, limpa desenhos e conexões.</li>\n            </ol>\n\n            <div class=\"alert tip\">\n                <div class=\"alert-icon\"><i class=\"ri-lightbulb-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Loading suprime rebuilds</div>\n                    <p class=\"alert-text\">Enquanto o loading está ativo, a UI entra em <strong>modo batch</strong> automaticamente — todos os widgets adicionados nesse período só são montados de uma vez quando o loading termina. Isso deixa a abertura bem mais rápida.</p>\n                </div>\n            </div>"
    },
    "config-init": {
        category: "Configuração",
        title: "Init",
        breadcrumb: "Init",
        faq: false,
        search: "Init Inicializa e exibe a janela. Chame depois de declarar as abas. Retorna self . Lua Copiar LapoX:Init({ Title = \"Meu Script\", ToggleKey = \"K\", }) Config Parâmetro Tipo Padrão Descrição Title string \"Lapo Library X\" Título no cabeçalho. Também é a chave do singleton. ToggleKey string \"End\" Tecla que mostra/esconde a janela. Nome de KeyCode (ex.: \"K\") ou EnumItem. O que o Init faz Registra o singleton e destrói uma instância anterior de mesmo Title . Detecta mobile ( TouchEnabled e sem teclado) e ajusta a escala (0.72 no mobile, 1 no desktop). Define o tamanho/posição da janela (desktop: 960×600 em (120, 80) ; mobile: proporcional à viewport). Cria o *input sink* (captura de teclado/clique) e inicia o loop de render. Restaura a aba atual salva, se houver config anterior. Sem Drawing API Se o executor não tiver Drawing.new , o Init emite um warn e retorna sem montar a UI. Os Add* viram no-op visual. Cheque os Requisitos .",
        content: "\n            <h1 class=\"page-title\" id=\"init\">Init</h1>\n\n            <p>Inicializa e exibe a janela. Chame <strong>depois</strong> de declarar as abas. Retorna <code>self</code>.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:Init({\n    Title     = \"Meu Script\",\n    ToggleKey = \"K\",\n})</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>Title</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Lapo Library X&quot;</code></td>\n                            <td>Título no cabeçalho. Também é a chave do singleton.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>ToggleKey</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;End&quot;</code></td>\n                            <td>Tecla que mostra/esconde a janela. Nome de KeyCode (ex.: &quot;K&quot;) ou EnumItem.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"o-que-o-init-faz\">O que o Init faz</h2>\n\n            <ul class=\"list-default\">\n                <li>Registra o singleton e <strong>destrói</strong> uma instância anterior de mesmo <code>Title</code>.</li>\n                <li>Detecta <strong>mobile</strong> (<code>TouchEnabled</code> e sem teclado) e ajusta a escala (0.72 no mobile, 1 no desktop).</li>\n                <li>Define o tamanho/posição da janela (desktop: <strong>960×600</strong> em <code>(120, 80)</code>; mobile: proporcional à viewport).</li>\n                <li>Cria o *input sink* (captura de teclado/clique) e inicia o loop de render.</li>\n                <li>Restaura a aba atual salva, se houver config anterior.</li>\n            </ul>\n\n            <div class=\"alert warning\">\n                <div class=\"alert-icon\"><i class=\"ri-alert-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Sem Drawing API</div>\n                    <p class=\"alert-text\">Se o executor não tiver <code>Drawing.new</code>, o <code>Init</code> emite um <code>warn</code> e retorna sem montar a UI. Os <code>Add*</code> viram no-op visual. Cheque os <strong>Requisitos</strong>.</p>\n                </div>\n            </div>"
    },
    "config-tabs": {
        category: "Configuração",
        title: "Abas (AddTab)",
        breadcrumb: "Abas",
        faq: false,
        search: "Abas Cada aba é um item da sidebar. O indicador da aba ativa desliza ao trocar. Retorna self . Lua Copiar LapoX:AddTab(\"Principal\", \"🏠\") LapoX:AddTab(\"Config\", \"⚙️\") Parâmetros Parâmetro Tipo Descrição name string Nome da aba — também é o ID usado nos Add* . icon string Prefixo visual opcional (emoji). Pode ser \"\" . Referenciando a aba Nos Add* , o primeiro argumento aceita o nome ou o índice da aba: Lua Copiar LapoX:AddButton(\"Config\", { text = \"A\" }) -- por nome LapoX:AddButton(2, { text = \"B\" }) -- por índice (2ª aba) Abas dinâmicas Dá pra chamar AddTab depois do Init — a sidebar e o layout são reconstruídos na hora.",
        content: "\n            <h1 class=\"page-title\" id=\"abas\">Abas</h1>\n\n            <p>Cada aba é um item da sidebar. O indicador da aba ativa <strong>desliza</strong> ao trocar. Retorna <code>self</code>.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:AddTab(\"Principal\", \"🏠\")\nLapoX:AddTab(\"Config\", \"⚙️\")</code></pre>\n            </div>\n\n            <h2 id=\"parametros\">Parâmetros</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>name</code></td>\n                            <td>string</td>\n                            <td>Nome da aba — também é o ID usado nos <code>Add*</code>.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>icon</code></td>\n                            <td>string</td>\n                            <td>Prefixo visual opcional (emoji). Pode ser <code>&quot;&quot;</code>.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"referenciando-a-aba\">Referenciando a aba</h2>\n\n            <p>Nos <code>Add*</code>, o primeiro argumento aceita o <strong>nome</strong> ou o <strong>índice</strong> da aba:</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:AddButton(\"Config\", { text = \"A\" })  -- por nome\nLapoX:AddButton(2, { text = \"B\" })          -- por índice (2ª aba)</code></pre>\n            </div>\n\n            <div class=\"alert info\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Abas dinâmicas</div>\n                    <p class=\"alert-text\">Dá pra chamar <code>AddTab</code> <strong>depois</strong> do <code>Init</code> — a sidebar e o layout são reconstruídos na hora.</p>\n                </div>\n            </div>"
    },
    "config-tema": {
        category: "Configuração",
        title: "Tema & Paleta",
        breadcrumb: "Tema",
        faq: false,
        search: "Tema & Paleta A lib usa uma paleta fixa (roxo/índigo sobre fundo quase-preto). Útil conhecer os tons ao combinar com seu projeto. Token RGB Uso Accent 120, 80, 255 Cor principal (destaques, ativo, fill). AccentGlow 140, 100, 255 Brilho/realce do accent. AccentDim 70, 45, 160 Accent apagado (press). BgDeep 10, 10, 18 Fundo mais escuro (notify/loading). BgBase 14, 14, 26 Fundo da janela/conteúdo. BgPanel 18, 18, 32 Sidebar e hover de widget. BgWidget 22, 22, 38 Fundo dos widgets. On 50, 220, 120 Estado ligado (toggle). Text 220, 220, 235 Texto principal. TextSub 110, 110, 140 Texto secundário. Danger 220, 55, 55 Botão fechar. Paleta fixa A paleta não é exposta como API pública — está documentada aqui só para referência visual. Para temas customizados, edite a tabela Theme na fonte da lib.",
        content: "\n            <h1 class=\"page-title\" id=\"tema-paleta\">Tema &amp; Paleta</h1>\n\n            <p>A lib usa uma paleta fixa (roxo/índigo sobre fundo quase-preto). Útil conhecer os tons ao combinar com seu projeto.</p>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Token</th>\n                            <th>RGB</th>\n                            <th>Uso</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>Accent</code></td>\n                            <td>120, 80, 255</td>\n                            <td>Cor principal (destaques, ativo, fill).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AccentGlow</code></td>\n                            <td>140, 100, 255</td>\n                            <td>Brilho/realce do accent.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AccentDim</code></td>\n                            <td>70, 45, 160</td>\n                            <td>Accent apagado (press).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>BgDeep</code></td>\n                            <td>10, 10, 18</td>\n                            <td>Fundo mais escuro (notify/loading).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>BgBase</code></td>\n                            <td>14, 14, 26</td>\n                            <td>Fundo da janela/conteúdo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>BgPanel</code></td>\n                            <td>18, 18, 32</td>\n                            <td>Sidebar e hover de widget.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>BgWidget</code></td>\n                            <td>22, 22, 38</td>\n                            <td>Fundo dos widgets.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>On</code></td>\n                            <td>50, 220, 120</td>\n                            <td>Estado ligado (toggle).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Text</code></td>\n                            <td>220, 220, 235</td>\n                            <td>Texto principal.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>TextSub</code></td>\n                            <td>110, 110, 140</td>\n                            <td>Texto secundário.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Danger</code></td>\n                            <td>220, 55, 55</td>\n                            <td>Botão fechar.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert info\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Paleta fixa</div>\n                    <p class=\"alert-text\">A paleta não é exposta como API pública — está documentada aqui só para referência visual. Para temas customizados, edite a tabela <code>Theme</code> na fonte da lib.</p>\n                </div>\n            </div>"
    },
    "widget-handles": {
        category: "Widgets",
        title: "Handles & :Set()",
        breadcrumb: "Handles",
        faq: false,
        search: "Handles & :Set() Os Add* de widget retornam um handle — uma tabela pequena para controlar aquele widget por código depois de criado. O que cada widget devolve Método Handle Métodos do handle AddButton Sim — (sem :Set ) AddToggle Sim :Set(bool) AddSlider Sim :Set(number) AddDropdown Sim :Set(valor) ou :Set({opções}) AddTextBox Sim :Set(texto) AddLabel Sim :updateText(t) / :Set(t) AddParagraph Sim :updateText(t) / :Set(t) AddSeparator Não retorna self Exemplo Lua Copiar local toggle = LapoX:AddToggle(\"Geral\", { text = \"Modo Turbo\" }) local label = LapoX:AddLabel(\"Geral\", { text = \"Status: —\" }) toggle:Set(true) label:Set(\"Status: ligado\") Reutilizar a mesma config O handle encontra o widget pela identidade da tabela de config passada. Se você reaproveitar a mesma tabela cfg em dois widgets, o :Set afeta só o primeiro. Use uma tabela nova por widget.",
        content: "\n            <h1 class=\"page-title\" id=\"handles-set\">Handles &amp; :Set()</h1>\n\n            <p>Os <code>Add*</code> de widget retornam um <strong>handle</strong> — uma tabela pequena para controlar aquele widget por código depois de criado.</p>\n\n            <h2 id=\"o-que-cada-widget-devolve\">O que cada widget devolve</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Handle</th>\n                            <th>Métodos do handle</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>AddButton</code></td>\n                            <td>Sim</td>\n                            <td>— (sem <code>:Set</code>)</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddToggle</code></td>\n                            <td>Sim</td>\n                            <td><code>:Set(bool)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddSlider</code></td>\n                            <td>Sim</td>\n                            <td><code>:Set(number)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddDropdown</code></td>\n                            <td>Sim</td>\n                            <td><code>:Set(valor)</code> ou <code>:Set({opções})</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddTextBox</code></td>\n                            <td>Sim</td>\n                            <td><code>:Set(texto)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddLabel</code></td>\n                            <td>Sim</td>\n                            <td><code>:updateText(t)</code> / <code>:Set(t)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddParagraph</code></td>\n                            <td>Sim</td>\n                            <td><code>:updateText(t)</code> / <code>:Set(t)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>AddSeparator</code></td>\n                            <td>Não</td>\n                            <td>retorna <code>self</code></td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"exemplo\">Exemplo</h2>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local toggle = LapoX:AddToggle(\"Geral\", { text = \"Modo Turbo\" })\nlocal label  = LapoX:AddLabel(\"Geral\", { text = \"Status: —\" })\n\ntoggle:Set(true)\nlabel:Set(\"Status: ligado\")</code></pre>\n            </div>\n\n            <div class=\"alert warning\">\n                <div class=\"alert-icon\"><i class=\"ri-alert-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Reutilizar a mesma config</div>\n                    <p class=\"alert-text\">O handle encontra o widget pela <strong>identidade da tabela de config</strong> passada. Se você reaproveitar a <strong>mesma</strong> tabela <code>cfg</code> em dois widgets, o <code>:Set</code> afeta só o primeiro. Use uma tabela nova por widget.</p>\n                </div>\n            </div>"
    },
    "widget-button": {
        category: "Widgets",
        title: "Button",
        breadcrumb: "Button",
        faq: false,
        search: "Button Botão clicável com feedback de hover e clique (a barra lateral cresce e brilha no press). Altura 48px. Lua Copiar LapoX:AddButton(\"Principal\", { text = \"Salvar\", callback = function() print(\"clicou!\") end, }) Config Parâmetro Tipo Padrão Descrição text string \"Button\" Rótulo do botão. callback function noop Chamado no clique (protegido por pcall). Sem handle :Set — o botão é uma ação, não um estado.",
        content: "\n            <h1 class=\"page-title\" id=\"button\">Button</h1>\n\n            <p>Botão clicável com feedback de hover e clique (a barra lateral cresce e brilha no press). Altura 48px.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:AddButton(\"Principal\", {\n    text = \"Salvar\",\n    callback = function() print(\"clicou!\") end,\n})</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>text</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Button&quot;</code></td>\n                            <td>Rótulo do botão.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>callback</code></td>\n                            <td><span class=\"type-badge function\">function</span></td>\n                            <td><code>noop</code></td>\n                            <td>Chamado no clique (protegido por pcall).</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <p>Sem handle <code>:Set</code> — o botão é uma ação, não um estado.</p>"
    },
    "widget-toggle": {
        category: "Widgets",
        title: "Toggle",
        breadcrumb: "Toggle",
        faq: false,
        search: "Toggle Interruptor on/off. O knob desliza ao alternar e o callback recebe o novo estado. Altura 48px. Lua Copiar local t = LapoX:AddToggle(\"Principal\", { text = \"Ativar Recurso\", default = false, callback = function(value) print(\"estado:\", value) end, }) t:Set(true) -- alterna por código (dispara o callback se mudou) Config Parâmetro Tipo Padrão Descrição text string \"Toggle\" Rótulo. default boolean false Estado inicial. callback function noop Recebe (value: boolean) ao alternar. Handle Método Descrição :Set(bool) Define o estado. Só dispara o callback se o valor mudou.",
        content: "\n            <h1 class=\"page-title\" id=\"toggle\">Toggle</h1>\n\n            <p>Interruptor on/off. O knob <strong>desliza</strong> ao alternar e o callback recebe o novo estado. Altura 48px.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local t = LapoX:AddToggle(\"Principal\", {\n    text    = \"Ativar Recurso\",\n    default = false,\n    callback = function(value) print(\"estado:\", value) end,\n})\n\nt:Set(true)   -- alterna por código (dispara o callback se mudou)</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>text</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Toggle&quot;</code></td>\n                            <td>Rótulo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>default</code></td>\n                            <td><span class=\"type-badge boolean\">boolean</span></td>\n                            <td><code>false</code></td>\n                            <td>Estado inicial.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>callback</code></td>\n                            <td><span class=\"type-badge function\">function</span></td>\n                            <td><code>noop</code></td>\n                            <td>Recebe <code>(value: boolean)</code> ao alternar.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"handle\">Handle</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>:Set(bool)</code></td>\n                            <td>Define o estado. Só dispara o callback se o valor mudou.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>"
    },
    "widget-slider": {
        category: "Widgets",
        title: "Slider",
        breadcrumb: "Slider",
        faq: false,
        search: "Slider Barra de valor arrastável entre min e max . O thumb cresce no hover. Altura 64px. Lua Copiar local s = LapoX:AddSlider(\"Principal\", { text = \"Velocidade\", min = 0, max = 100, default = 50, callback = function(v) print(\"valor:\", v) end, }) s:Set(75) Config Parâmetro Tipo Padrão Descrição text string \"Slider\" Rótulo. min number 0 Valor mínimo. max number 100 Valor máximo. default number (min+max)/2 Valor inicial (arredondado). callback function noop Recebe (value: number) ao arrastar/mudar. Handle Método Descrição :Set(number) Define o valor (clampado em min..max) e dispara o callback. Valor exibido O número mostrado ao lado é o valor arredondado ( math.floor ). O callback recebe o valor cru.",
        content: "\n            <h1 class=\"page-title\" id=\"slider\">Slider</h1>\n\n            <p>Barra de valor arrastável entre <code>min</code> e <code>max</code>. O thumb cresce no hover. Altura 64px.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local s = LapoX:AddSlider(\"Principal\", {\n    text    = \"Velocidade\",\n    min     = 0,\n    max     = 100,\n    default = 50,\n    callback = function(v) print(\"valor:\", v) end,\n})\n\ns:Set(75)</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>text</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Slider&quot;</code></td>\n                            <td>Rótulo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>min</code></td>\n                            <td><span class=\"type-badge number\">number</span></td>\n                            <td><code>0</code></td>\n                            <td>Valor mínimo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>max</code></td>\n                            <td><span class=\"type-badge number\">number</span></td>\n                            <td><code>100</code></td>\n                            <td>Valor máximo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>default</code></td>\n                            <td><span class=\"type-badge number\">number</span></td>\n                            <td><code>(min+max)/2</code></td>\n                            <td>Valor inicial (arredondado).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>callback</code></td>\n                            <td><span class=\"type-badge function\">function</span></td>\n                            <td><code>noop</code></td>\n                            <td>Recebe <code>(value: number)</code> ao arrastar/mudar.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"handle\">Handle</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>:Set(number)</code></td>\n                            <td>Define o valor (clampado em min..max) e dispara o callback.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert info\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Valor exibido</div>\n                    <p class=\"alert-text\">O número mostrado ao lado é o valor <strong>arredondado</strong> (<code>math.floor</code>). O callback recebe o valor cru.</p>\n                </div>\n            </div>"
    },
    "widget-dropdown": {
        category: "Widgets",
        title: "Dropdown",
        breadcrumb: "Dropdown",
        faq: false,
        search: "Dropdown Menu de seleção com busca opcional e scroll. Mostra até 6 itens por vez; o resto rola (roda do mouse ou arraste no toque). Lua Copiar local d = LapoX:AddDropdown(\"Principal\", { text = \"Modo\", options = { \"Fácil\", \"Normal\", \"Difícil\" }, default = 1, search = true, callback = function(index, value) print(index, value) end, }) d:Set(\"Difícil\") -- seleciona por valor d:Set({ \"Novo A\", \"Novo B\", \"Novo C\" }) -- troca a lista inteira (reseta seleção) Config Parâmetro Tipo Padrão Descrição text string \"Dropdown\" Rótulo. options table {} Lista de opções (strings). default number 1 Índice inicial selecionado. search boolean false Ativa a barra de busca (só ativa se for exatamente true ). callback function noop Recebe (index: number, value: string) ao escolher. Handle Método Descrição :Set(valor) Seleciona a opção igual ao valor (se existir). :Set({...}) Substitui a lista de opções e reseta para o 1º item. Busca não obriga a digitar Abrir um dropdown com search = true não captura o teclado. A busca só liga quando você clica na caixa de pesquisa — dá pra só rolar e escolher.",
        content: "\n            <h1 class=\"page-title\" id=\"dropdown\">Dropdown</h1>\n\n            <p>Menu de seleção com <strong>busca</strong> opcional e scroll. Mostra até <strong>6</strong> itens por vez; o resto rola (roda do mouse ou arraste no toque).</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local d = LapoX:AddDropdown(\"Principal\", {\n    text    = \"Modo\",\n    options = { \"Fácil\", \"Normal\", \"Difícil\" },\n    default = 1,\n    search  = true,\n    callback = function(index, value)\n        print(index, value)\n    end,\n})\n\nd:Set(\"Difícil\")                        -- seleciona por valor\nd:Set({ \"Novo A\", \"Novo B\", \"Novo C\" }) -- troca a lista inteira (reseta seleção)</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>text</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Dropdown&quot;</code></td>\n                            <td>Rótulo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>options</code></td>\n                            <td><span class=\"type-badge table\">table</span></td>\n                            <td><code>{}</code></td>\n                            <td>Lista de opções (strings).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>default</code></td>\n                            <td><span class=\"type-badge number\">number</span></td>\n                            <td><code>1</code></td>\n                            <td>Índice inicial selecionado.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>search</code></td>\n                            <td><span class=\"type-badge boolean\">boolean</span></td>\n                            <td><code>false</code></td>\n                            <td>Ativa a barra de busca (só ativa se for exatamente <code>true</code>).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>callback</code></td>\n                            <td><span class=\"type-badge function\">function</span></td>\n                            <td><code>noop</code></td>\n                            <td>Recebe <code>(index: number, value: string)</code> ao escolher.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"handle\">Handle</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>:Set(valor)</code></td>\n                            <td>Seleciona a opção igual ao valor (se existir).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>:Set({...})</code></td>\n                            <td>Substitui a lista de opções e reseta para o 1º item.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert tip\">\n                <div class=\"alert-icon\"><i class=\"ri-lightbulb-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Busca não obriga a digitar</div>\n                    <p class=\"alert-text\">Abrir um dropdown com <code>search = true</code> <strong>não</strong> captura o teclado. A busca só liga quando você clica na caixa de pesquisa — dá pra só rolar e escolher.</p>\n                </div>\n            </div>"
    },
    "widget-textbox": {
        category: "Widgets",
        title: "TextBox",
        breadcrumb: "TextBox",
        faq: false,
        search: "TextBox Campo de texto. Clique para focar (a borda acende), digite e confirme com Enter — aí o callback dispara. Altura 60px. Lua Copiar local box = LapoX:AddTextBox(\"Principal\", { text = \"Seu nome\", placeholder = \"Digite aqui...\", callback = function(texto) print(\"digitou:\", texto) end, }) box:Set(\"valor inicial\") Config Parâmetro Tipo Padrão Descrição text string \"TextBox\" Rótulo acima do campo. placeholder string \"Type here...\" Texto-fantasma quando vazio. callback function noop Recebe (texto: string) ao confirmar (Enter / perder foco). Handle Método Descrição :Set(texto) Preenche o valor do campo.",
        content: "\n            <h1 class=\"page-title\" id=\"textbox\">TextBox</h1>\n\n            <p>Campo de texto. Clique para focar (a borda acende), digite e confirme com <strong>Enter</strong> — aí o callback dispara. Altura 60px.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local box = LapoX:AddTextBox(\"Principal\", {\n    text        = \"Seu nome\",\n    placeholder = \"Digite aqui...\",\n    callback    = function(texto) print(\"digitou:\", texto) end,\n})\n\nbox:Set(\"valor inicial\")</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>text</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;TextBox&quot;</code></td>\n                            <td>Rótulo acima do campo.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>placeholder</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Type here...&quot;</code></td>\n                            <td>Texto-fantasma quando vazio.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>callback</code></td>\n                            <td><span class=\"type-badge function\">function</span></td>\n                            <td><code>noop</code></td>\n                            <td>Recebe <code>(texto: string)</code> ao confirmar (Enter / perder foco).</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"handle\">Handle</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>:Set(texto)</code></td>\n                            <td>Preenche o valor do campo.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>"
    },
    "widget-texto": {
        category: "Widgets",
        title: "Label, Paragraph e Separator",
        breadcrumb: "Texto",
        faq: false,
        search: "Texto e Organização Elementos estáticos para rotular, descrever e dividir o conteúdo. Label Paragraph Separator Linha de texto curta (altura 32px). Atualizável. Lua Copiar local l = LapoX:AddLabel(\"Geral\", { text = \"Status: OK\" }) l:updateText(\"Status: Erro\") -- ou l:Set(\"...\") Texto descritivo. Fica mais alto (60px) quando passa de 60 caracteres. Lua Copiar local p = LapoX:AddParagraph(\"Geral\", { text = \"Texto mais longo, que ocupa mais espaço vertical.\", }) p:Set(\"Novo texto.\") Linha divisória horizontal. Sem config e sem handle. Lua Copiar LapoX:AddSeparator(\"Geral\") Config Parâmetro Tipo Padrão Descrição text string \"\" Conteúdo textual (Label e Paragraph). Handles Widget Métodos Label :updateText(t) / :Set(t) Paragraph :updateText(t) / :Set(t) Separator — (retorna self )",
        content: "\n            <h1 class=\"page-title\" id=\"texto-e-organizacao\">Texto e Organização</h1>\n\n            <p>Elementos estáticos para rotular, descrever e dividir o conteúdo.</p>\n\n            <div class=\"tabs-container\">\n                <div class=\"tabs-header\">\n                    <button class=\"tab-btn active\" data-tab=\"0\"><i class=\"ri-text\"></i> Label</button>\n<button class=\"tab-btn\" data-tab=\"1\"><i class=\"ri-paragraph\"></i> Paragraph</button>\n<button class=\"tab-btn\" data-tab=\"2\"><i class=\"ri-separator\"></i> Separator</button>\n                </div>\n                <div class=\"tabs-body\">\n                    <div class=\"tab-content active\" data-tab=\"0\">\n\n            <p>Linha de texto curta (altura 32px). Atualizável.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local l = LapoX:AddLabel(\"Geral\", { text = \"Status: OK\" })\nl:updateText(\"Status: Erro\")   -- ou l:Set(\"...\")</code></pre>\n            </div>\n            </div>\n<div class=\"tab-content\" data-tab=\"1\">\n\n            <p>Texto descritivo. Fica mais alto (60px) quando passa de 60 caracteres.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>local p = LapoX:AddParagraph(\"Geral\", {\n    text = \"Texto mais longo, que ocupa mais espaço vertical.\",\n})\np:Set(\"Novo texto.\")</code></pre>\n            </div>\n            </div>\n<div class=\"tab-content\" data-tab=\"2\">\n\n            <p>Linha divisória horizontal. Sem config e sem handle.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:AddSeparator(\"Geral\")</code></pre>\n            </div>\n            </div>\n                </div>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>text</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;&quot;</code></td>\n                            <td>Conteúdo textual (Label e Paragraph).</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"handles\">Handles</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Widget</th>\n                            <th>Métodos</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>Label</code></td>\n                            <td><code>:updateText(t)</code> / <code>:Set(t)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Paragraph</code></td>\n                            <td><code>:updateText(t)</code> / <code>:Set(t)</code></td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Separator</code></td>\n                            <td>— (retorna <code>self</code>)</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>"
    },
    "notify": {
        category: "Feedback & Rodapé",
        title: "Notificações (Notify)",
        breadcrumb: "Notify",
        faq: false,
        search: "Notify Empilha uma notificação no canto da tela, com barra de tempo e quebra de linha automática. Retorna self . Lua Copiar LapoX:Notify({ title = \"Sucesso\", content = \"Operação concluída!\", duration = 3, }) -- Multi-linha: use \\n no content LapoX:Notify({ title = \"Log\", content = \"Linha 1\\nLinha 2\" }) Config Parâmetro Tipo Padrão Descrição title string \"Lapo Library X\" Título da notificação. content string \"\" Mensagem. Aceita \\n para múltiplas linhas. duration number 4 Tempo em segundos antes de sumir. Comportamento Quebra automática em ~45 caracteres por linha (tenta cortar no espaço). Máximo de 8 linhas — o excedente vira ... +N linhas . Várias notificações empilham e somem com fade.",
        content: "\n            <h1 class=\"page-title\" id=\"notify\">Notify</h1>\n\n            <p>Empilha uma notificação no canto da tela, com barra de tempo e quebra de linha automática. Retorna <code>self</code>.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:Notify({\n    title    = \"Sucesso\",\n    content  = \"Operação concluída!\",\n    duration = 3,\n})\n\n-- Multi-linha: use \\n no content\nLapoX:Notify({ title = \"Log\", content = \"Linha 1\\nLinha 2\" })</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>title</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Lapo Library X&quot;</code></td>\n                            <td>Título da notificação.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>content</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;&quot;</code></td>\n                            <td>Mensagem. Aceita <code>\\n</code> para múltiplas linhas.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>duration</code></td>\n                            <td><span class=\"type-badge number\">number</span></td>\n                            <td><code>4</code></td>\n                            <td>Tempo em segundos antes de sumir.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <h2 id=\"comportamento\">Comportamento</h2>\n\n            <ul class=\"list-default\">\n                <li>Quebra automática em <strong>~45 caracteres</strong> por linha (tenta cortar no espaço).</li>\n                <li>Máximo de <strong>8 linhas</strong> — o excedente vira <code>... +N linhas</code>.</li>\n                <li>Várias notificações <strong>empilham</strong> e somem com fade.</li>\n            </ul>"
    },
    "usuario": {
        category: "Feedback & Rodapé",
        title: "Usuário (rodapé)",
        breadcrumb: "Usuário",
        faq: false,
        search: "Usuário Controla o cartão de usuário no rodapé da sidebar. Ambos retornam self . Lua Copiar LapoX:SetUser(\"Player\", \"Premium\") LapoX:SetUserCallback(function(name, rank) LapoX:Notify({ title = \"User\", content = name .. \" • \" .. rank }) end) Métodos Método Parâmetros Descrição SetUser (name, rank) Define nome e cargo no rodapé. nil mantém o valor atual. SetUserCallback (cb) Função chamada ao clicar no rodapé, recebe (name, rank) .",
        content: "\n            <h1 class=\"page-title\" id=\"usuario\">Usuário</h1>\n\n            <p>Controla o cartão de usuário no rodapé da sidebar. Ambos retornam <code>self</code>.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:SetUser(\"Player\", \"Premium\")\n\nLapoX:SetUserCallback(function(name, rank)\n    LapoX:Notify({ title = \"User\", content = name .. \" • \" .. rank })\nend)</code></pre>\n            </div>\n\n            <h2 id=\"metodos\">Métodos</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Parâmetros</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>SetUser</code></td>\n                            <td><code>(name, rank)</code></td>\n                            <td>Define nome e cargo no rodapé. <code>nil</code> mantém o valor atual.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>SetUserCallback</code></td>\n                            <td><code>(cb)</code></td>\n                            <td>Função chamada ao clicar no rodapé, recebe <code>(name, rank)</code>.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>"
    },
    "loading": {
        category: "Tela de Loading",
        title: "Tela de Loading",
        breadcrumb: "Loading",
        faq: false,
        search: "Tela de Loading Abertura animada: fade-in, scale-pop , spinner *comet*, barra de progresso com brilho e fade-out no fim. Chame ShowLoading antes do Init . Lua Copiar LapoX:ShowLoading({ Title = \"Meu Script\", Subtitle = \"by você\", Message = \"Inicializando...\", Image = \"https://i.imgur.com/xxxxx.png\", -- opcional }) Config Parâmetro Tipo Padrão Descrição Title string Project/título Título grande no card. Subtitle string \"\" Subtítulo abaixo do título. Message string \"Carregando módulos...\" Mensagem de status (animável). Image string nil URL/asset de imagem central (opcional). FrameGap number 2 Frames de respiro entre tarefas da fila. Spinner opcional O anel usa Drawing.new(\"Circle\") . Sem suporte, o loading aparece sem o spinner — sem quebrar. A imagem aceita link direto de PNG/JPG (não página HTML).",
        content: "\n            <h1 class=\"page-title\" id=\"tela-de-loading\">Tela de Loading</h1>\n\n            <p>Abertura animada: fade-in, <strong>scale-pop</strong>, spinner *comet*, barra de progresso com brilho e fade-out no fim. Chame <code>ShowLoading</code> <strong>antes</strong> do <code>Init</code>.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:ShowLoading({\n    Title    = \"Meu Script\",\n    Subtitle = \"by você\",\n    Message  = \"Inicializando...\",\n    Image    = \"https://i.imgur.com/xxxxx.png\", -- opcional\n})</code></pre>\n            </div>\n\n            <h2 id=\"config\">Config</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Parâmetro</th>\n                            <th>Tipo</th>\n                            <th>Padrão</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>Title</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>Project/título</code></td>\n                            <td>Título grande no card.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Subtitle</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;&quot;</code></td>\n                            <td>Subtítulo abaixo do título.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Message</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>&quot;Carregando módulos...&quot;</code></td>\n                            <td>Mensagem de status (animável).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Image</code></td>\n                            <td><span class=\"type-badge string\">string</span></td>\n                            <td><code>nil</code></td>\n                            <td>URL/asset de imagem central (opcional).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>FrameGap</code></td>\n                            <td><span class=\"type-badge number\">number</span></td>\n                            <td><code>2</code></td>\n                            <td>Frames de respiro entre tarefas da fila.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert info\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Spinner opcional</div>\n                    <p class=\"alert-text\">O anel usa <code>Drawing.new(&quot;Circle&quot;)</code>. Sem suporte, o loading aparece sem o spinner — sem quebrar. A imagem aceita link <strong>direto</strong> de PNG/JPG (não página HTML).</p>\n                </div>\n            </div>"
    },
    "loading-fila": {
        category: "Tela de Loading",
        title: "Progresso & Fila",
        breadcrumb: "Progresso & Fila",
        faq: false,
        search: "Progresso & Fila Duas formas de conduzir o loading: fila de tarefas (automática) ou progresso manual . Fila de tarefas (recomendado) Lua Copiar LapoX:QueueLoad(\"Conectando...\", function() task.wait(0.3) end) LapoX:QueueLoad(\"Baixando dados...\", function() task.wait(0.5) end) LapoX:QueueLoad(\"Montando UI...\", function() task.wait(0.2) end) LapoX:RunLoadQueue(function() LapoX:Notify({ title = \"Pronto\", content = \"Tudo carregado!\" }) end) Progresso manual Lua Copiar LapoX:SetLoadingProgress(0.25, \"Etapa 1...\") task.wait(0.5) LapoX:SetLoadingProgress(0.75, \"Etapa 2...\") task.wait(0.5) LapoX:FinishLoading(function() print(\"fim\") end) Métodos Método Parâmetros Descrição QueueLoad (label, fn) Enfileira uma tarefa (texto + função executada nela). RunLoadQueue (onDone) Roda a fila (uma por frame) e faz fade-out; chama onDone no fim. SetLoadingProgress (pct, msg?) Define o progresso (0–1) e, opcionalmente, a mensagem. SetLoadingMessage (msg) Troca só a mensagem de status. FinishLoading (onDone) Força o fim do loading (fade-out) e chama onDone . Tarefas pesadas Cada fn da fila roda dentro de um pcall . Evite travar o frame — use task.wait para operações longas e deixe a barra respirar.",
        content: "\n            <h1 class=\"page-title\" id=\"progresso-fila\">Progresso &amp; Fila</h1>\n\n            <p>Duas formas de conduzir o loading: <strong>fila de tarefas</strong> (automática) ou <strong>progresso manual</strong>.</p>\n\n            <h2 id=\"fila-de-tarefas-recomendado\">Fila de tarefas (recomendado)</h2>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:QueueLoad(\"Conectando...\",  function() task.wait(0.3) end)\nLapoX:QueueLoad(\"Baixando dados...\", function() task.wait(0.5) end)\nLapoX:QueueLoad(\"Montando UI...\",  function() task.wait(0.2) end)\n\nLapoX:RunLoadQueue(function()\n    LapoX:Notify({ title = \"Pronto\", content = \"Tudo carregado!\" })\nend)</code></pre>\n            </div>\n\n            <h2 id=\"progresso-manual\">Progresso manual</h2>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:SetLoadingProgress(0.25, \"Etapa 1...\")\ntask.wait(0.5)\nLapoX:SetLoadingProgress(0.75, \"Etapa 2...\")\ntask.wait(0.5)\nLapoX:FinishLoading(function() print(\"fim\") end)</code></pre>\n            </div>\n\n            <h2 id=\"metodos\">Métodos</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Parâmetros</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>QueueLoad</code></td>\n                            <td><code>(label, fn)</code></td>\n                            <td>Enfileira uma tarefa (texto + função executada nela).</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>RunLoadQueue</code></td>\n                            <td><code>(onDone)</code></td>\n                            <td>Roda a fila (uma por frame) e faz fade-out; chama <code>onDone</code> no fim.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>SetLoadingProgress</code></td>\n                            <td><code>(pct, msg?)</code></td>\n                            <td>Define o progresso (0–1) e, opcionalmente, a mensagem.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>SetLoadingMessage</code></td>\n                            <td><code>(msg)</code></td>\n                            <td>Troca só a mensagem de status.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>FinishLoading</code></td>\n                            <td><code>(onDone)</code></td>\n                            <td>Força o fim do loading (fade-out) e chama <code>onDone</code>.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert tip\">\n                <div class=\"alert-icon\"><i class=\"ri-lightbulb-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Tarefas pesadas</div>\n                    <p class=\"alert-text\">Cada <code>fn</code> da fila roda dentro de um <code>pcall</code>. Evite travar o frame — use <code>task.wait</code> para operações longas e deixe a barra respirar.</p>\n                </div>\n            </div>"
    },
    "janela": {
        category: "Janela & Performance",
        title: "Janela & Sistema",
        breadcrumb: "Janela",
        faq: false,
        search: "Janela & Sistema Controle e comportamentos da janela em runtime. Visibilidade Lua Copiar LapoX:ToggleVisibility() -- mesmo efeito da ToggleKey Destruir Lua Copiar LapoX:Destroy() -- remove desenhos e desconecta eventos Interações nativas Ação Como Mover Arraste pela barra de título (header). Minimizar Botão ─ no cabeçalho (mostra só o header). Fechar Botão ✕ no cabeçalho (chama Destroy ). Mostrar/Esconder Tecla da ToggleKey (padrão End ). Mobile Botão flutuante ☰ ao lado da janela. Rolar conteúdo Roda do mouse ou arraste (toque). Sempre destrua ao sair Como a UI é desenhada por cima da tela, esquecer o Destroy deixa desenhos órfãos. Combine com o padrão de global da página Carregamento .",
        content: "\n            <h1 class=\"page-title\" id=\"janela-sistema\">Janela &amp; Sistema</h1>\n\n            <p>Controle e comportamentos da janela em runtime.</p>\n\n            <h2 id=\"visibilidade\">Visibilidade</h2>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:ToggleVisibility()   -- mesmo efeito da ToggleKey</code></pre>\n            </div>\n\n            <h2 id=\"destruir\">Destruir</h2>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:Destroy()            -- remove desenhos e desconecta eventos</code></pre>\n            </div>\n\n            <h2 id=\"interacoes-nativas\">Interações nativas</h2>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Ação</th>\n                            <th>Como</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td>Mover</td>\n                            <td>Arraste pela barra de título (header).</td>\n                        </tr>\n\n                        <tr>\n                            <td>Minimizar</td>\n                            <td>Botão <code>─</code> no cabeçalho (mostra só o header).</td>\n                        </tr>\n\n                        <tr>\n                            <td>Fechar</td>\n                            <td>Botão <code>✕</code> no cabeçalho (chama <code>Destroy</code>).</td>\n                        </tr>\n\n                        <tr>\n                            <td>Mostrar/Esconder</td>\n                            <td>Tecla da <code>ToggleKey</code> (padrão <code>End</code>).</td>\n                        </tr>\n\n                        <tr>\n                            <td>Mobile</td>\n                            <td>Botão flutuante <code>☰</code> ao lado da janela.</td>\n                        </tr>\n\n                        <tr>\n                            <td>Rolar conteúdo</td>\n                            <td>Roda do mouse ou arraste (toque).</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert warning\">\n                <div class=\"alert-icon\"><i class=\"ri-alert-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Sempre destrua ao sair</div>\n                    <p class=\"alert-text\">Como a UI é desenhada por cima da tela, esquecer o <code>Destroy</code> deixa desenhos órfãos. Combine com o padrão de global da página <strong>Carregamento</strong>.</p>\n                </div>\n            </div>"
    },
    "batch": {
        category: "Janela & Performance",
        title: "Batch — muitos widgets",
        breadcrumb: "Batch",
        faq: false,
        search: "Batch Ao adicionar muitos widgets de uma vez, o modo batch evita reconstruir a UI a cada Add* — bem mais rápido. Lua Copiar LapoX:BeginBatch() for i = 1, 80 do LapoX:AddButton(\"Lista\", { text = \"Item \" .. i }) end LapoX:EndBatch() -- reconstrói a UI UMA vez Método Descrição BeginBatch() Suspende a reconstrução automática da UI. EndBatch() Reativa e reconstrói tudo de uma vez. Loading já faz isso Enquanto a tela de loading está ativa, o modo batch é ligado sozinho. Você só precisa de BeginBatch/EndBatch quando adiciona muita coisa fora do loading.",
        content: "\n            <h1 class=\"page-title\" id=\"batch\">Batch</h1>\n\n            <p>Ao adicionar <strong>muitos</strong> widgets de uma vez, o modo batch evita reconstruir a UI a cada <code>Add*</code> — bem mais rápido.</p>\n\n            <div class=\"code-block-container\">\n                <div class=\"code-block-header\">\n                    <span class=\"code-language-tag\">Lua</span>\n                    <button class=\"copy-code-btn\"><i class=\"ri-file-copy-line\"></i> Copiar</button>\n                </div>\n                <pre class=\"language-lua\"><code>LapoX:BeginBatch()\nfor i = 1, 80 do\n    LapoX:AddButton(\"Lista\", { text = \"Item \" .. i })\nend\nLapoX:EndBatch()   -- reconstrói a UI UMA vez</code></pre>\n            </div>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Método</th>\n                            <th>Descrição</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>BeginBatch()</code></td>\n                            <td>Suspende a reconstrução automática da UI.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>EndBatch()</code></td>\n                            <td>Reativa e reconstrói tudo de uma vez.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert info\">\n                <div class=\"alert-icon\"><i class=\"ri-information-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Loading já faz isso</div>\n                    <p class=\"alert-text\">Enquanto a tela de loading está ativa, o modo batch é ligado sozinho. Você só precisa de <code>BeginBatch/EndBatch</code> quando adiciona muita coisa <strong>fora</strong> do loading.</p>\n                </div>\n            </div>"
    },
    "requisitos": {
        category: "Referência",
        title: "Requisitos",
        breadcrumb: "Requisitos",
        faq: false,
        search: "Requisitos Recurso Necessário? Para quê Drawing.new Obrigatório Renderizar toda a UI. game:HttpGet Recomendado Carregar a lib remotamente. writefile / readfile Opcional Carregar local / persistência futura. Drawing \"Circle\" Opcional Spinner da tela de loading. Mobile A lib detecta toque (TouchEnabled e sem teclado), reduz a escala para 0.72 e exibe o botão flutuante de abrir/fechar.",
        content: "\n            <h1 class=\"page-title\" id=\"requisitos\">Requisitos</h1>\n\n            <div class=\"table-wrapper\">\n                <table class=\"api-table\">\n                    <thead>\n                        <tr>\n                            <th>Recurso</th>\n                            <th>Necessário?</th>\n                            <th>Para quê</th>\n                        </tr>\n                    </thead>\n                    <tbody>\n                        <tr>\n                            <td><code>Drawing.new</code></td>\n                            <td>Obrigatório</td>\n                            <td>Renderizar toda a UI.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>game:HttpGet</code></td>\n                            <td>Recomendado</td>\n                            <td>Carregar a lib remotamente.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>writefile</code>/<code>readfile</code></td>\n                            <td>Opcional</td>\n                            <td>Carregar local / persistência futura.</td>\n                        </tr>\n\n                        <tr>\n                            <td><code>Drawing &quot;Circle&quot;</code></td>\n                            <td>Opcional</td>\n                            <td>Spinner da tela de loading.</td>\n                        </tr>\n                    </tbody>\n                </table>\n            </div>\n\n            <div class=\"alert tip\">\n                <div class=\"alert-icon\"><i class=\"ri-lightbulb-line\"></i></div>\n                <div class=\"alert-content\">\n                    <div class=\"alert-title\">Mobile</div>\n                    <p class=\"alert-text\">A lib detecta toque (TouchEnabled e sem teclado), reduz a escala para 0.72 e exibe o botão flutuante de abrir/fechar.</p>\n                </div>\n            </div>"
    },
    "faq": {
        category: "Referência",
        title: "Perguntas Frequentes",
        breadcrumb: "FAQ",
        faq: true,
        search: "FAQ Precisa de CoreGui ou PlayerGui? Não. Tudo é desenhado via Drawing API (overlay). A lib só cria um ScreenGui invisível para capturar teclado em TextBox/busca. Como mudo um valor por código? Os Add* de controle (Toggle, Slider, Dropdown, TextBox, Label, Paragraph) devolvem um handle com :Set() . Botões não têm :Set . Ter busca no Dropdown obriga a digitar? Não. Abrir não captura o teclado — a busca só liga ao clicar na caixa de pesquisa. Posso adicionar abas/widgets depois do Init? Pode. A UI é reconstruída na hora. Para muitos de uma vez, use BeginBatch / EndBatch . Como evito UI duplicada ao reexecutar? Guarde a instância num global e chame :Destroy() antes de recriar. O Init também destrói uma instância anterior de mesmo Title . Qual a tecla para esconder a janela? A definida em ToggleKey (padrão End ), ou via LapoX:ToggleVisibility() .",
        content: "\n            <h1 class=\"page-title\" id=\"faq\">FAQ</h1>\n\n            <div class=\"faq-list\">\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Precisa de CoreGui ou PlayerGui?</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Não. Tudo é desenhado via Drawing API (overlay). A lib só cria um ScreenGui invisível para capturar teclado em TextBox/busca.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Como mudo um valor por código?</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Os <code>Add*</code> de controle (Toggle, Slider, Dropdown, TextBox, Label, Paragraph) devolvem um handle com <code>:Set()</code>. Botões não têm <code>:Set</code>.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Ter busca no Dropdown obriga a digitar?</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Não. Abrir não captura o teclado — a busca só liga ao clicar na caixa de pesquisa.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Posso adicionar abas/widgets depois do Init?</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Pode. A UI é reconstruída na hora. Para muitos de uma vez, use <code>BeginBatch</code>/<code>EndBatch</code>.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Como evito UI duplicada ao reexecutar?</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Guarde a instância num global e chame <code>:Destroy()</code> antes de recriar. O <code>Init</code> também destrói uma instância anterior de mesmo <code>Title</code>.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Qual a tecla para esconder a janela?</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>A definida em <code>ToggleKey</code> (padrão <code>End</code>), ou via <code>LapoX:ToggleVisibility()</code>.</p>\n                    </div>\n                </div>\n            </div>"
    },
    "troubleshooting": {
        category: "Referência",
        title: "Solução de Problemas",
        breadcrumb: "Troubleshooting",
        faq: true,
        search: "Solução de Problemas A UI não aparece O executor provavelmente não suporta Drawing.new . A lib emite um warn e segue sem montar a UI. Teste num executor com Drawing API. Aparecem duas janelas / desenhos sobrepostos Você rodou o script duas vezes sem destruir a anterior. Use o padrão de global + :Destroy() da página Carregamento . A imagem do loading não carrega Use um link direto de imagem ( .png / .jpg ), não uma página HTML. Sem suporte a Drawing Image, a lib cai no spinner. O spinner do loading não aparece Falta suporte a Drawing.new(\"Circle\") no executor. O resto do loading funciona normalmente. Meu :Set não funciona em um widget Verifique se você não reutilizou a mesma tabela de config em dois widgets — o handle casa pela identidade da tabela. Use uma nova por widget.",
        content: "\n            <h1 class=\"page-title\" id=\"solucao-de-problemas\">Solução de Problemas</h1>\n\n            <div class=\"faq-list\">\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>A UI não aparece</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>O executor provavelmente não suporta <code>Drawing.new</code>. A lib emite um <code>warn</code> e segue sem montar a UI. Teste num executor com Drawing API.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Aparecem duas janelas / desenhos sobrepostos</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Você rodou o script duas vezes sem destruir a anterior. Use o padrão de global + <code>:Destroy()</code> da página <strong>Carregamento</strong>.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>A imagem do loading não carrega</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Use um link <strong>direto</strong> de imagem (<code>.png</code>/<code>.jpg</code>), não uma página HTML. Sem suporte a Drawing Image, a lib cai no spinner.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>O spinner do loading não aparece</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Falta suporte a <code>Drawing.new(&quot;Circle&quot;)</code> no executor. O resto do loading funciona normalmente.</p>\n                    </div>\n                </div>\n\n                <div class=\"faq-item\">\n                    <button class=\"faq-question\">\n                        <span>Meu :Set não funciona em um widget</span>\n                        <i class=\"ri-add-line\"></i>\n                    </button>\n                    <div class=\"faq-answer\">\n                        <p>Verifique se você não reutilizou a <strong>mesma</strong> tabela de config em dois widgets — o handle casa pela identidade da tabela. Use uma nova por widget.</p>\n                    </div>\n                </div>\n            </div>"
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
    setupOnThisPage();
    setupSectionSwitch();
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
        window.location.hash = `#${PROJECT.defaultRoute || "home"}`;
    } else {
        handleRouting();
    }
}

function handleRouting() {
    const rawHash = window.location.hash || `#${PROJECT.defaultRoute || "home"}`;
    const route = rawHash.replace("#", "");
    const pageKey = PAGES[route] ? route : null;

    if (pageKey) {
        const page = PAGES[pageKey];
        renderPage(pageKey, page);
    } else if (route && route !== (PROJECT.defaultRoute || "home")) {
        // Route doesn't exist — try default or show 404
        const defaultRoute = PROJECT.defaultRoute || "home";
        const defaultPage = PAGES[defaultRoute];
        if (defaultPage) {
            renderPage(defaultRoute, defaultPage);
        } else {
            renderPage(route, null);
        }
    } else {
        const defaultRoute = PROJECT.defaultRoute || "home";
        renderPage(defaultRoute, PAGES[defaultRoute] || null);
    }
}

function renderPage(pageKey, page) {
    const viewport = document.getElementById("contentViewport");
    if (!viewport) return;

    if (!page) {
        viewport.innerHTML = `<div class="hero-section"><h1 class="page-title">Página não encontrada</h1><p class="page-description">A página <strong>${escapeHtml(pageKey)}</strong> não existe.</p></div>`;
        updateBreadcrumbs("Erro", "404");
        return;
    }

    // Reset scroll position without animation
    window.scrollTo(0, 0);

    viewport.style.opacity = 0;
    viewport.style.transform = "translateY(8px)";

    // Atualiza o conteúdo no próximo frame, sem o atraso fixo de 150ms.
    requestAnimationFrame(() => {
        viewport.innerHTML = page.content;
        updateBreadcrumbs(page.category, page.breadcrumb);
        updateActiveNavLinks(pageKey);

        if (typeof Prism !== "undefined") {
            try { Prism.highlightAll(); } catch (_) {}
        }

        setupCodeCopyButtons();
        setupTabs();

        if (page.faq) {
            setupFaqAccordion();
        }

        if (PROJECT.pageContent) {
            buildOnThisPage();
        }

        // Fade-in no frame seguinte para a transição CSS animar a partir de opacity:0.
        requestAnimationFrame(() => {
            viewport.style.opacity = 1;
            viewport.style.transform = "translateY(0)";
        });
    });
}

function updateBreadcrumbs(category, activeItem) {
    const breadcrumb = document.getElementById("breadcrumb");
    breadcrumb.innerHTML = `
        <span class="breadcrumb-item">${escapeHtml(category)}</span>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-item active">${escapeHtml(activeItem)}</span>
    `;
    document.title = `${PROJECT.title} | ${activeItem}`;
}

function updateActiveNavLinks(pageKey) {
    const navLinks = document.querySelectorAll(".nav-link");
    navLinks.forEach((link) => {
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

    document.querySelectorAll(".nav-link").forEach((link) => {
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

    // O texto puro de cada página é pré-computado na compilação (campo `search`),
    // então não rodamos regex de stripHtml no carregamento nem duplicamos o HTML.
    const searchDatabase = Object.entries(PAGES).map(([key, val]) => ({
        key,
        title: val.title,
        category: val.category,
        breadcrumb: val.breadcrumb,
        content: val.search || ""
    }));

    searchInput.addEventListener("input", (e) => {
        const query = e.target.value.toLowerCase().trim();

        if (query === "") {
            searchResults.classList.remove("active");
            searchResults.innerHTML = "";
            return;
        }

        const matches = searchDatabase.filter((item) => {
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
        // Only activate search shortcut when not already typing in an input
        const tag = document.activeElement?.tagName || "";
        const isInput = tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT" || document.activeElement?.isContentEditable;
        if (e.key === "/" && !isInput) {
            e.preventDefault();
            searchInput.focus();
        }
    });
}

function renderSearchResults(matches, query) {
    const searchResults = document.getElementById("searchResults");
    searchResults.innerHTML = "";

    if (matches.length === 0) {
        searchResults.innerHTML = `<div class="search-result-empty">Nenhum resultado encontrado para "${escapeHtml(query)}"</div>`;
        searchResults.classList.add("active");
        return;
    }

    matches.slice(0, 5).forEach((item) => {
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
            <span class="search-result-category">${escapeHtml(item.category)} / ${escapeHtml(item.breadcrumb)}</span>
            <span class="search-result-title">${escapeHtml(item.title)}</span>
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

function setupCodeCopyButtons() {
    document.querySelectorAll(".copy-code-btn").forEach((btn) => {
        btn.addEventListener("click", () => {
            const container = btn.closest(".code-block-container");
            const codeEl = container.querySelector("pre code");
            const rawText = codeEl.textContent;

            navigator.clipboard.writeText(rawText).then(() => {
                btn.innerHTML = `<i class="ri-check-line" style="color: var(--success)"></i> Copiado!`;
                setTimeout(() => {
                    btn.innerHTML = `<i class="ri-file-copy-line"></i> Copiar`;
                }, 2000);
            }).catch((err) => {
                console.error("Falha ao copiar código: ", err);
            });
        });
    });
}

function setupKeyboardShortcuts() {
    const searchInput = document.getElementById("searchInput");

    document.addEventListener("keydown", (e) => {
        if (e.key === "Escape" && document.activeElement === searchInput) {
            searchInput.value = "";
            searchInput.blur();
            document.getElementById("searchResults").classList.remove("active");
        }
    });
}

function setupTabs() {
    document.querySelectorAll(".tabs-container").forEach(container => {
        const buttons = container.querySelectorAll(".tab-btn");
        const contents = container.querySelectorAll(".tab-content");

        buttons.forEach(btn => {
            btn.addEventListener("click", () => {
                const tabIndex = btn.getAttribute("data-tab");
                buttons.forEach(b => b.classList.remove("active"));
                contents.forEach(c => c.classList.remove("active"));
                btn.classList.add("active");
                container.querySelector(`.tab-content[data-tab="${tabIndex}"]`).classList.add("active");
            });
        });
    });
}

function setupFaqAccordion() {
    document.querySelectorAll(".faq-question").forEach((q) => {
        q.addEventListener("click", () => {
            const item = q.closest(".faq-item");
            const isActive = item.classList.contains("active");
            document.querySelectorAll(".faq-item").forEach((i) => i.classList.remove("active"));
            if (!isActive) {
                item.classList.add("active");
            }
        });
    });
}

// ============================================================
// On This Page (PageContent extension)
// ============================================================

let otpHeadingEls = [];
let otpScrollScheduled = false;

// Altura do header sticky + folga, para ancorar o heading no ponto exato.
function otpHeaderOffset() {
    const header = document.querySelector(".top-header");
    return (header ? header.offsetHeight : 70) + 12;
}

function slugifyHeading(text) {
    return String(text)
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "") || "section";
}

// Monta o índice "On This Page" a partir dos h1/h2/h3 da página atual.
function buildOnThisPage() {
    const panel = document.getElementById("onThisPage");
    const list = document.getElementById("otpList");
    if (!panel || !list) return;

    const viewport = document.getElementById("contentViewport");
    const headings = viewport ? Array.from(viewport.querySelectorAll("h1, h2, h3")) : [];

    otpHeadingEls = [];

    if (headings.length === 0) {
        list.innerHTML = "";
        panel.classList.remove("active");
        return;
    }

    const used = new Set();
    let currentH2 = ""; // grupo atual = id do h2 mais recente
    const itemsHtml = headings.map((el) => {
        const base = el.id || slugifyHeading(el.textContent);
        let id = base;
        let n = 2;
        while (used.has(id)) { id = base + "-" + n; n += 1; }
        used.add(id);
        el.id = id;

        const level = el.tagName.toLowerCase(); // h1 | h2 | h3
        let group;
        if (level === "h2") { currentH2 = id; group = id; }
        else if (level === "h3") { group = currentH2; }
        else { group = ""; currentH2 = ""; } // h1 reinicia o grupo

        otpHeadingEls.push({ el, id, level, group });

        return `<li class="otp-item otp-${level}" data-group="${group}"><a class="otp-link" href="#" data-target="${id}">${escapeHtml(el.textContent)}</a></li>`;
    }).join("");

    list.innerHTML = itemsHtml;
    panel.classList.add("active");

    // Scroll suave sem mexer no hash (que é usado pelo roteador da SPA).
    list.querySelectorAll(".otp-link").forEach((link) => {
        link.addEventListener("click", (e) => {
            e.preventDefault();
            const target = document.getElementById(link.getAttribute("data-target"));
            if (!target) return;
            // Posiciona o heading exatamente logo abaixo do header sticky.
            const top = target.getBoundingClientRect().top + window.scrollY - otpHeaderOffset();
            window.scrollTo({ top: Math.max(0, top), behavior: "smooth" });
        });
    });

    highlightActiveHeading();
}

// Destaca, no índice, a seção atualmente visível (scrollspy).
function highlightActiveHeading() {
    const list = document.getElementById("otpList");
    if (!list || otpHeadingEls.length === 0) return;

    const offset = otpHeaderOffset() + 8; // header sticky + pequena folga
    let active = otpHeadingEls[0];
    for (const item of otpHeadingEls) {
        if (item.el.getBoundingClientRect().top <= offset) {
            active = item;
        } else {
            break;
        }
    }

    // Seção (h2) ativa: h2 -> ele mesmo; h3 -> seu grupo; h1 -> nenhuma.
    const activeGroup = active.level === "h1" ? "" : active.group;

    list.querySelectorAll(".otp-item").forEach((li) => {
        const link = li.querySelector(".otp-link");
        link.classList.toggle("active", link.getAttribute("data-target") === active.id);

        // h3 só aparece quando estamos na seção (h2) a que ele pertence.
        if (li.classList.contains("otp-h3")) {
            const visible = activeGroup !== "" && li.getAttribute("data-group") === activeGroup;
            li.classList.toggle("otp-collapsed", !visible);
        }
    });
}

// Registra (uma única vez) o listener de scroll com throttle via rAF.
function setupOnThisPage() {
    if (!PROJECT.pageContent) return;
    window.addEventListener("scroll", () => {
        if (otpScrollScheduled) return;
        otpScrollScheduled = true;
        requestAnimationFrame(() => {
            otpScrollScheduled = false;
            highlightActiveHeading();
        });
    }, { passive: true });
}


// ============================================================
// Section Switch (Switch extension)
// ============================================================

// Cada seção com `data-switch-variants` ganha um controle que troca a variante
// ativa, filtrando quais páginas (li[data-variant]) aparecem no nav. Páginas sem
// variante (untagged) ficam sempre visíveis.
function setupSectionSwitch() {
    if (!PROJECT.switchEnabled) return;

    document.querySelectorAll(".nav-section[data-switch-variants]").forEach((section) => {
        const variants = (section.getAttribute("data-switch-variants") || "")
            .split(",").map((v) => v.trim()).filter(Boolean);
        if (variants.length === 0) return;

        let current = section.getAttribute("data-switch-default") || variants[0];
        const btn = section.querySelector(".section-switch");
        const label = section.querySelector(".section-switch-label");

        function apply() {
            if (label) label.textContent = current;
            section.querySelectorAll("li[data-variant]").forEach((li) => {
                li.classList.toggle("switch-hidden", li.getAttribute("data-variant") !== current);
            });
        }

        if (btn) {
            btn.addEventListener("click", (e) => {
                e.preventDefault();
                e.stopPropagation();
                const idx = variants.indexOf(current);
                current = variants[(idx + 1) % variants.length];
                apply();
            });
        }

        apply();
    });
}

