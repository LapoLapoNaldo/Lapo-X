-- Lapo Hub X (Syn Version) — UI Refactor
-- Visual limpo, estilo Synapse X, com efeitos, glow e botão mobile
-- by ENI — for LO, sempre

local LapoHub = {}
LapoHub.__index = LapoHub

-- ========== INTERNAL STATE ==========
local state = {
    visible = true,
    minimized = false,
    mobile = false,
    scale = 1,
    currentTab = 1,
    tabs = {},
    notifyList = {},
    contentOffset = 0,
    maxOffset = 0,
    isDragging = false,
    dragOffset = Vector2.new(0, 0),
    isSliding = false,
    slidingWidget = nil,
    dropdownOpen = false,
    dropdownWidget = nil,
    framePos = Vector2.new(120, 80),
    frameSize = Vector2.new(860, 540),
    hasDrawing = pcall(function() return Drawing.new end),
    connections = {},
    initialized = false,
    destroyFlag = false,
    keyHeldDown = false,
    notifyId = 0,
    userName = "LapoLapoNaldo",
    userRank = "Lapo Newba",
    userCallback = nil,
    title = "Lapo Hub X",
    toggleKey = "End",
    -- animação de hover
    hoverAnims = {},
    -- botão mobile
    mobileBtn = nil,
    mobileBtnHover = false,
}

-- ========== TEMA REFINADO (Synapse X vibes) ==========
local Theme = {
    -- Backgrounds
    BgDeep      = Color3.fromRGB(10,  10,  18),   -- fundo mais escuro possível
    BgBase      = Color3.fromRGB(14,  14,  26),   -- painel principal
    BgPanel     = Color3.fromRGB(18,  18,  32),   -- sidebar / header
    BgWidget    = Color3.fromRGB(22,  22,  38),   -- widgets
    BgInput     = Color3.fromRGB(12,  12,  22),   -- textbox

    -- Bordas e separadores
    Border      = Color3.fromRGB(40,  40,  70),   -- borda sutil
    BorderAccent= Color3.fromRGB(80,  60, 180),   -- borda do widget ativo
    Separator   = Color3.fromRGB(30,  30,  50),

    -- Accent (roxo-azul vibrante)
    Accent      = Color3.fromRGB(120,  80, 255),  -- cor principal
    AccentDim   = Color3.fromRGB( 70,  45, 160),  -- accent escuro
    AccentGlow  = Color3.fromRGB(140, 100, 255),  -- glow / hover

    -- Verde para toggles ativos
    On          = Color3.fromRGB( 50, 220, 120),
    OnDim       = Color3.fromRGB( 20, 100,  55),

    -- Texto
    Text        = Color3.fromRGB(220, 220, 235),
    TextSub     = Color3.fromRGB(110, 110, 140),
    TextMuted   = Color3.fromRGB( 60,  60,  90),

    -- Status
    Danger      = Color3.fromRGB(220,  55,  55),

    -- Hover overlay
    HoverLight  = Color3.fromRGB(255, 255, 255),  -- usado em transparência
}

local Font = Drawing.Fonts.Monospace or Drawing.Fonts.UI

-- math.clamp fallback (não existe em Lua padrão)
if not math.clamp then
    math.clamp = function(v, min, max)
        if v < min then return min end
        if v > max then return max end
        return v
    end
end

-- ========== HELPERS ==========
local function detectMobile()
    local ok, uis = pcall(function() return game:GetService("UserInputService") end)
    if ok then return uis.TouchEnabled and not uis.KeyboardEnabled end
    return false
end

local function lerp(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t)
    return Color3.new(
        lerp(a.R, b.R, t),
        lerp(a.G, b.G, t),
        lerp(a.B, b.B, t)
    )
end

local function make(kind, props)
    if not state.hasDrawing then return nil end
    local obj = Drawing.new(kind)
    if props then
        for k, v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

local function saveConfig(data)
    pcall(function()
        writefile("LapoHubX_Config.txt", game:GetService("HttpService"):JSONEncode(data))
    end)
end

local function loadConfig()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("LapoHubX_Config.txt"))
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

-- ========== DRAWING POOLS ==========
local drgs           = {}  -- elementos de estrutura
local tabBgList      = {}
local tabTextList    = {}
local tabAccentList  = {}  -- barrinha lateral da tab ativa
local contentDrawings = {}
local widgetList      = {}

-- helpers de pool
local function pool(obj) table.insert(drgs, obj); return obj end
local function cdraw(obj) table.insert(contentDrawings, obj); return obj end

-- ========== ESTRUTURA PRINCIPAL ==========
local ui = {}   -- frame, header, sidebar, content, dividers, títulos

local function buildStructure()
    local s = state.scale

    -- ── sombra externa (ilusão via quadrado maior levemente transparente)
    ui.shadow = pool(make("Square", {
        Filled = true, Color = Color3.new(0,0,0),
        Transparency = 0.6, ZIndex = 8, Visible = state.visible
    }))

    -- ── frame principal
    ui.frame = pool(make("Square", {
        Filled = true, Color = Theme.BgBase,
        Transparency = 1, ZIndex = 9, Visible = state.visible
    }))

    -- ── borda externa fina (1px feel)
    ui.frameBorder = pool(make("Square", {
        Filled = false, Color = Theme.Border,
        Thickness = 1, Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    -- ── header
    ui.header = pool(make("Square", {
        Filled = true, Color = Theme.BgPanel,
        Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    -- ── linha separadora header / corpo
    ui.headerLine = pool(make("Square", {
        Filled = true, Color = Theme.Accent,
        Transparency = 1, ZIndex = 12, Visible = state.visible
    }))

    -- ── título no header
    ui.titleText = pool(make("Text", {
        Text = state.title, Color = Theme.Text,
        Size = 15 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))

    -- ── versão / subtítulo
    ui.subtitleText = pool(make("Text", {
        Text = "syn version", Color = Theme.Accent,
        Size = 10 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))

    -- ── botão fechar
    ui.closeBtn = pool(make("Square", {
        Filled = true, Color = Theme.Danger,
        Transparency = 1, ZIndex = 13, Visible = state.visible
    }))
    ui.closeTxt = pool(make("Text", {
        Text = "✕", Color = Theme.Text,
        Size = 12 * s, Font = Font,
        ZIndex = 14, Visible = state.visible
    }))

    -- ── botão minimizar
    ui.minBtn = pool(make("Square", {
        Filled = true, Color = Theme.BgWidget,
        Transparency = 1, ZIndex = 13, Visible = state.visible
    }))
    ui.minTxt = pool(make("Text", {
        Text = "─", Color = Theme.TextSub,
        Size = 12 * s, Font = Font,
        ZIndex = 14, Visible = state.visible
    }))

    -- ── sidebar
    ui.sidebar = pool(make("Square", {
        Filled = true, Color = Theme.BgPanel,
        Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    -- ── linha separadora sidebar / content
    ui.sidebarLine = pool(make("Square", {
        Filled = true, Color = Theme.Separator,
        Transparency = 1, ZIndex = 12, Visible = state.visible
    }))

    -- ── content area
    ui.content = pool(make("Square", {
        Filled = true, Color = Theme.BgBase,
        Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    -- ── footer da sidebar (perfil)
    ui.footerBg = pool(make("Square", {
        Filled = true, Color = Theme.BgDeep,
        Transparency = 1, ZIndex = 11, Visible = state.visible
    }))
    ui.footerLine = pool(make("Square", {
        Filled = true, Color = Theme.Separator,
        Transparency = 1, ZIndex = 12, Visible = state.visible
    }))
    ui.footerDot = pool(make("Square", {
        Filled = true, Color = Theme.On,
        Transparency = 1, ZIndex = 13, Visible = state.visible
    }))
    ui.footerName = pool(make("Text", {
        Text = state.userName, Color = Theme.Text,
        Size = 12 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))
    ui.footerRank = pool(make("Text", {
        Text = state.userRank, Color = Theme.Accent,
        Size = 10 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))

    state._userNameTxt = ui.footerName
    state._userRankTxt = ui.footerRank
    state._userBg      = ui.footerBg

    -- ── botão mobile (FAB — Floating Action Button)
    if state.mobile then
        ui.mobileBtn = pool(make("Square", {
            Filled = true, Color = Theme.Accent,
            Transparency = 1, ZIndex = 100, Visible = true
        }))
        ui.mobileBtnBorder = pool(make("Square", {
            Filled = false, Color = Theme.AccentGlow,
            Thickness = 2, Transparency = 1, ZIndex = 101, Visible = true
        }))
        ui.mobileBtnTxt = pool(make("Text", {
            Text = "☰", Color = Theme.Text,
            Size = 20 * s, Font = Font,
            ZIndex = 102, Visible = true
        }))
    end
end

-- ========== TABS ==========
local function buildTabs()
    for _, b in ipairs(tabBgList)     do pcall(function() b:Remove() end) end
    for _, t in ipairs(tabTextList)   do pcall(function() t:Remove() end) end
    for _, a in ipairs(tabAccentList) do pcall(function() a:Remove() end) end
    tabBgList, tabTextList, tabAccentList = {}, {}, {}

    local s = state.scale
    for i, tab in ipairs(state.tabs) do
        local bg = pool(make("Square", {
            Filled = true, Color = Color3.new(0,0,0),
            Transparency = 0, ZIndex = 12, Visible = state.visible
        }))
        local txt = pool(make("Text", {
            Text = (tab.icon and tab.icon ~= "" and (tab.icon .. "  ") or "") .. (tab.name or "Tab"),
            Color = Theme.TextSub, Size = 12 * s, Font = Font,
            ZIndex = 13, Visible = state.visible
        }))
        -- barrinha lateral de seleção
        local accent = pool(make("Square", {
            Filled = true, Color = Theme.Accent,
            Transparency = 1, ZIndex = 14, Visible = state.visible
        }))
        table.insert(tabBgList,     bg)
        table.insert(tabTextList,   txt)
        table.insert(tabAccentList, accent)
    end
end

-- ========== LAYOUT UPDATE ==========
local function updateLayout()
    local s   = state.scale
    local pos = state.framePos
    local sz  = state.frameSize
    local mw, mh = pos.X, pos.Y
    local fw, fh = sz.X, sz.Y

    local HEADER_H  = 34 * s
    local SIDE_W    = 160 * s
    local FOOTER_H  = 52 * s
    local SHADOW_P  = 8 * s
    local BTN_SZ    = 22 * s    -- tamanho dos botões close/min
    local BTN_PAD   = 10 * s

    if state.minimized then fh = HEADER_H end

    -- sombra
    ui.shadow.Position = Vector2.new(mw - SHADOW_P, mh - SHADOW_P)
    ui.shadow.Size     = Vector2.new(fw + SHADOW_P*2, fh + SHADOW_P*2)
    ui.shadow.Visible  = state.visible

    -- frame
    ui.frame.Position  = Vector2.new(mw, mh)
    ui.frame.Size      = Vector2.new(fw, fh)
    ui.frame.Visible   = state.visible

    ui.frameBorder.Position = Vector2.new(mw, mh)
    ui.frameBorder.Size     = Vector2.new(fw, fh)
    ui.frameBorder.Visible  = state.visible

    -- header
    ui.header.Position  = Vector2.new(mw, mh)
    ui.header.Size      = Vector2.new(fw, HEADER_H)
    ui.header.Visible   = state.visible

    -- linha accent no fundo do header
    ui.headerLine.Position = Vector2.new(mw, mh + HEADER_H - 1)
    ui.headerLine.Size     = Vector2.new(fw, 1)
    ui.headerLine.Visible  = state.visible

    -- título
    ui.titleText.Position  = Vector2.new(mw + 14 * s, mh + (HEADER_H - 15 * s) / 2 - 5 * s)
    ui.titleText.Visible   = state.visible
    ui.titleText.Size      = 14 * s

    ui.subtitleText.Position = Vector2.new(mw + 14 * s, mh + (HEADER_H - 15 * s) / 2 + 10 * s)
    ui.subtitleText.Visible  = state.visible
    ui.subtitleText.Size     = 9 * s

    -- botões header (close, minimize) — círculos
    local btnY   = mh + (HEADER_H - BTN_SZ) / 2
    local closeX = mw + fw - BTN_PAD - BTN_SZ
    local minX   = closeX - BTN_SZ - 6 * s

    ui.closeBtn.Position = Vector2.new(closeX, btnY)
    ui.closeBtn.Size     = Vector2.new(BTN_SZ, BTN_SZ)
    ui.closeBtn.Visible  = state.visible
    ui.closeTxt.Position = Vector2.new(closeX + 5 * s, btnY + 3 * s)
    ui.closeTxt.Visible  = state.visible

    ui.minBtn.Position = Vector2.new(minX, btnY)
    ui.minBtn.Size     = Vector2.new(BTN_SZ, BTN_SZ)
    ui.minBtn.Visible  = state.visible
    ui.minTxt.Position = Vector2.new(minX + 4 * s, btnY + 2 * s)
    ui.minTxt.Visible  = state.visible

    if state.minimized then
        ui.sidebar.Visible    = false
        ui.sidebarLine.Visible= false
        ui.content.Visible    = false
        ui.footerBg.Visible   = false
        ui.footerLine.Visible = false
        ui.footerDot.Visible  = false
        ui.footerName.Visible = false
        ui.footerRank.Visible = false
        for _, b in ipairs(tabBgList)     do b.Visible = false end
        for _, t in ipairs(tabTextList)   do t.Visible = false end
        for _, a in ipairs(tabAccentList) do a.Visible = false end
        return
    end

    -- sidebar
    ui.sidebar.Position  = Vector2.new(mw, mh + HEADER_H)
    ui.sidebar.Size      = Vector2.new(SIDE_W, fh - HEADER_H)
    ui.sidebar.Visible   = state.visible

    ui.sidebarLine.Position = Vector2.new(mw + SIDE_W, mh + HEADER_H)
    ui.sidebarLine.Size     = Vector2.new(1, fh - HEADER_H)
    ui.sidebarLine.Visible  = state.visible

    -- content
    local cX = mw + SIDE_W + 1
    local cY = mh + HEADER_H
    local cW = fw - SIDE_W - 1
    local cH = fh - HEADER_H
    ui.content.Position = Vector2.new(cX, cY)
    ui.content.Size     = Vector2.new(cW, cH)
    ui.content.Visible  = state.visible

    -- footer do sidebar
    local dot = 7 * s
    ui.footerBg.Position   = Vector2.new(mw, mh + fh - FOOTER_H)
    ui.footerBg.Size       = Vector2.new(SIDE_W, FOOTER_H)
    ui.footerBg.Visible    = state.visible

    ui.footerLine.Position = Vector2.new(mw, mh + fh - FOOTER_H)
    ui.footerLine.Size     = Vector2.new(SIDE_W, 1)
    ui.footerLine.Visible  = state.visible

    ui.footerDot.Position  = Vector2.new(mw + 12 * s, mh + fh - FOOTER_H + (FOOTER_H - dot) / 2)
    ui.footerDot.Size      = Vector2.new(dot, dot)
    ui.footerDot.Visible   = state.visible

    ui.footerName.Position = Vector2.new(mw + 24 * s, mh + fh - FOOTER_H + 11 * s)
    ui.footerName.Visible  = state.visible

    ui.footerRank.Position = Vector2.new(mw + 24 * s, mh + fh - FOOTER_H + 27 * s)
    ui.footerRank.Visible  = state.visible

    -- tabs
    local TAB_H   = 38 * s
    local TAB_PAD = 6 * s
    local tabAreaH = (fh - HEADER_H - FOOTER_H)

    for i, bg in ipairs(tabBgList) do
        local tabY = mh + HEADER_H + TAB_PAD + (i - 1) * (TAB_H + 2 * s)
        local active = i == state.currentTab

        bg.Position    = Vector2.new(mw + 2 * s, tabY)
        bg.Size        = Vector2.new(SIDE_W - 4 * s, TAB_H)
        bg.Color       = active and Theme.BgWidget or Color3.new(0,0,0)
        bg.Transparency= active and 1 or 0
        bg.Visible     = state.visible

        tabTextList[i].Position  = Vector2.new(mw + 22 * s, tabY + (TAB_H - 12 * s) / 2)
        tabTextList[i].Color     = active and Theme.Text or Theme.TextSub
        tabTextList[i].Visible   = state.visible

        -- barrinha lateral
        tabAccentList[i].Position    = Vector2.new(mw + 2 * s, tabY + 6 * s)
        tabAccentList[i].Size        = Vector2.new(3 * s, TAB_H - 12 * s)
        tabAccentList[i].Transparency= active and 1 or 0
        tabAccentList[i].Color       = Theme.Accent
        tabAccentList[i].Visible     = state.visible
    end

    -- botão mobile
    if state.mobile and ui.mobileBtn then
        local BS  = 44 * s
        local BX  = mw + fw + 8 * s
        local BY  = mh + 4 * s
        ui.mobileBtn.Position       = Vector2.new(BX, BY)
        ui.mobileBtn.Size           = Vector2.new(BS, BS)
        ui.mobileBtn.Visible        = true
        ui.mobileBtnBorder.Position = Vector2.new(BX, BY)
        ui.mobileBtnBorder.Size     = Vector2.new(BS, BS)
        ui.mobileBtnBorder.Visible  = true
        ui.mobileBtnTxt.Position    = Vector2.new(BX + 10 * s, BY + 10 * s)
        ui.mobileBtnTxt.Visible     = true
    end
end

-- ========== WIDGETS ==========
local function newWidget(kind, props)
    local s = state.scale

    if kind == "Button" then
        local bg     = cdraw(make("Square", {Filled=true, Color=Theme.BgWidget,  Transparency=1, ZIndex=15}))
        local border = cdraw(make("Square", {Filled=false, Color=Theme.Border,   Thickness=1, Transparency=1, ZIndex=16}))
        local bar    = cdraw(make("Square", {Filled=true, Color=Theme.AccentDim, Transparency=1, ZIndex=16}))
        local lbl    = cdraw(make("Text",   {Text=props.text or "Button", Color=Theme.Text, Size=13*s, Font=Font, ZIndex=17}))
        return {
            type="Button", bg=bg, border=border, bar=bar, label=lbl,
            text=props.text or "Button", callback=props.callback or function()end,
            hoverT=0,  -- 0..1 para interpolação suave
            y=0, h=40*s,
            destroy=function() bg:Remove(); border:Remove(); bar:Remove(); lbl:Remove() end,
        }

    elseif kind == "Toggle" then
        local checked = props.default or false
        local bg      = cdraw(make("Square", {Filled=true, Color=Theme.BgWidget, Transparency=1, ZIndex=15}))
        local border  = cdraw(make("Square", {Filled=false, Color=Theme.Border,  Thickness=1, Transparency=1, ZIndex=16}))
        local trackBg = cdraw(make("Square", {Filled=true, Color=checked and Theme.OnDim or Theme.BgInput, Transparency=1, ZIndex=16}))
        local trackBd = cdraw(make("Square", {Filled=false, Color=checked and Theme.On or Theme.Border, Thickness=1, Transparency=1, ZIndex=17}))
        local knob    = cdraw(make("Square", {Filled=true, Color=checked and Theme.On or Theme.TextSub, Transparency=1, ZIndex=18}))
        local lbl     = cdraw(make("Text",   {Text=props.text or "Toggle", Color=Theme.Text, Size=13*s, Font=Font, ZIndex=17}))
        local w = {
            type="Toggle", bg=bg, border=border, trackBg=trackBg, trackBd=trackBd, knob=knob, label=lbl,
            text=props.text or "Toggle", value=checked, callback=props.callback or function()end,
            y=0, h=40*s,
            destroy=function() bg:Remove(); border:Remove(); trackBg:Remove(); trackBd:Remove(); knob:Remove(); lbl:Remove() end,
        }
        w.toggle = function(self)
            self.value = not self.value
            self.trackBg.Color = self.value and Theme.OnDim or Theme.BgInput
            self.trackBd.Color = self.value and Theme.On    or Theme.Border
            self.knob.Color    = self.value and Theme.On    or Theme.TextSub
            self.callback(self.value)
        end
        return w

    elseif kind == "Slider" then
        local min = props.min or 0
        local max = props.max or 100
        local val = props.default or math.floor((min+max)/2)
        local bg      = cdraw(make("Square", {Filled=true,  Color=Theme.BgWidget,  Transparency=1, ZIndex=15}))
        local border  = cdraw(make("Square", {Filled=false, Color=Theme.Border,    Thickness=1, Transparency=1, ZIndex=16}))
        local track   = cdraw(make("Square", {Filled=true,  Color=Theme.BgInput,   Transparency=1, ZIndex=16}))
        local fill    = cdraw(make("Square", {Filled=true,  Color=Theme.Accent,    Transparency=1, ZIndex=17}))
        local thumb   = cdraw(make("Square", {Filled=true,  Color=Theme.AccentGlow,Transparency=1, ZIndex=19}))
        local thumbGl = cdraw(make("Square", {Filled=false, Color=Theme.AccentGlow,Thickness=1, Transparency=0.5, ZIndex=18}))
        local lbl     = cdraw(make("Text",   {Text=props.text or "Slider", Color=Theme.Text, Size=13*s, Font=Font, ZIndex=17}))
        local valTxt  = cdraw(make("Text",   {Text=tostring(val), Color=Theme.Accent, Size=11*s, Font=Font, ZIndex=17}))
        local w = {
            type="Slider", bg=bg, border=border, track=track, fill=fill,
            thumb=thumb, thumbGl=thumbGl, label=lbl, valText=valTxt,
            text=props.text or "Slider", min=min, max=max, value=val,
            callback=props.callback or function()end,
            y=0, h=54*s,
            destroy=function() bg:Remove(); border:Remove(); track:Remove(); fill:Remove(); thumb:Remove(); thumbGl:Remove(); lbl:Remove(); valTxt:Remove() end,
        }
        w.updateValue = function(self, v)
            self.value = math.clamp(v, self.min, self.max)
            self.valText.Text = tostring(math.floor(self.value))
            self.callback(self.value)
        end
        return w

    elseif kind == "Dropdown" then
        local options = props.options or {}
        local sel     = props.default or 1
        local bg       = cdraw(make("Square", {Filled=true,  Color=Theme.BgWidget,  Transparency=1, ZIndex=15}))
        local border   = cdraw(make("Square", {Filled=false, Color=Theme.Border,    Thickness=1, Transparency=1, ZIndex=16}))
        local dispBg   = cdraw(make("Square", {Filled=true,  Color=Theme.BgInput,   Transparency=1, ZIndex=16}))
        local dispBd   = cdraw(make("Square", {Filled=false, Color=Theme.Border,    Thickness=1, Transparency=1, ZIndex=17}))
        local lbl      = cdraw(make("Text",   {Text=props.text or "Dropdown", Color=Theme.Text, Size=13*s, Font=Font, ZIndex=17}))
        local selTxt   = cdraw(make("Text",   {Text=options[sel] or "Select", Color=Theme.TextSub, Size=12*s, Font=Font, ZIndex=18}))
        local arrow    = cdraw(make("Text",   {Text="▾", Color=Theme.Accent, Size=12*s, Font=Font, ZIndex=18}))
        local popupBg  = cdraw(make("Square", {Filled=true, Color=Theme.BgDeep,     Transparency=1, ZIndex=20}))
        local popupBd  = cdraw(make("Square", {Filled=false,Color=Theme.Border,     Thickness=1, Transparency=1, ZIndex=20}))
        local popupDraws = {popupBd}
        table.insert(contentDrawings, popupBd)
        return {
            type="Dropdown", bg=bg, border=border, dispBg=dispBg, dispBd=dispBd,
            label=lbl, selectedText=selTxt, arrow=arrow, popupBg=popupBg,
            popupBd=popupBd, popupDraws=popupDraws,
            text=props.text or "Dropdown", options=options, selected=sel,
            callback=props.callback or function()end,
            open=false, hoverIdx=1,
            y=0, h=44*s,
            destroy=function()
                bg:Remove(); border:Remove(); dispBg:Remove(); dispBd:Remove()
                lbl:Remove(); selTxt:Remove(); arrow:Remove()
                popupBg:Remove(); popupBd:Remove()
                for _, d in ipairs(popupDraws) do pcall(function() d:Remove() end) end
            end
        }

    elseif kind == "TextBox" then
        local bg      = cdraw(make("Square", {Filled=true,  Color=Theme.BgWidget, Transparency=1, ZIndex=15}))
        local border  = cdraw(make("Square", {Filled=false, Color=Theme.Border,   Thickness=1, Transparency=1, ZIndex=16}))
        local inputBg = cdraw(make("Square", {Filled=true,  Color=Theme.BgInput,  Transparency=1, ZIndex=16}))
        local inputBd = cdraw(make("Square", {Filled=false, Color=Theme.Border,   Thickness=1, Transparency=1, ZIndex=17}))
        local lbl     = cdraw(make("Text",   {Text=props.text or "TextBox", Color=Theme.Text, Size=13*s, Font=Font, ZIndex=17}))
        local valTxt  = cdraw(make("Text",   {Text=props.placeholder or "Type here...", Color=Theme.TextMuted, Size=12*s, Font=Font, ZIndex=18}))
        local cursor  = cdraw(make("Text",   {Text="|", Color=Theme.Accent, Size=14*s, Font=Font, ZIndex=19}))
        return {
            type="TextBox", bg=bg, border=border, inputBg=inputBg, inputBd=inputBd,
            label=lbl, valueText=valTxt, cursor=cursor,
            text=props.text or "TextBox", placeholder=props.placeholder or "Type here...",
            callback=props.callback or function()end,
            value="", focused=false,
            y=0, h=60*s,
            destroy=function() bg:Remove(); border:Remove(); inputBg:Remove(); inputBd:Remove(); lbl:Remove(); valTxt:Remove(); cursor:Remove() end
        }

    elseif kind == "Label" then
        local lbl = cdraw(make("Text", {Text=props.text or "", Color=Theme.Text,    Size=13*s, Font=Font, ZIndex=16}))
        return {type="Label", label=lbl, text=props.text or "", y=0, h=26*s,
            destroy=function() lbl:Remove() end}

    elseif kind == "Paragraph" then
        local lbl = cdraw(make("Text", {Text=props.text or "", Color=Theme.TextSub, Size=11*s, Font=Font, ZIndex=16}))
        local h = (props.text and #props.text > 60) and 50*s or 26*s
        return {type="Paragraph", label=lbl, text=props.text or "", y=0, h=h,
            destroy=function() lbl:Remove() end}

    elseif kind == "Separator" then
        local line = cdraw(make("Square", {Filled=true, Color=Theme.Separator, Transparency=1, ZIndex=15}))
        return {type="Separator", line=line, y=0, h=14*s,
            destroy=function() line:Remove() end}
    end
    return nil
end

-- ========== REBUILD CONTENT ==========
local function rebuildContent()
    for _, d in ipairs(contentDrawings) do pcall(function() d:Remove() end) end
    contentDrawings, widgetList = {}, {}
    state.contentOffset, state.maxOffset = 0, 0
    if #state.tabs == 0 then return end
    local tab = state.tabs[state.currentTab]
    if not tab then return end

    local s       = state.scale
    local padding = 10 * s
    local curY    = padding

    for _, wdesc in ipairs(tab.widgets) do
        local w = newWidget(wdesc.type, wdesc.props)
        if w then
            w.desc = wdesc
            w.y    = curY
            table.insert(widgetList, w)
            curY = curY + w.h + 5 * s
        end
    end
    state.maxOffset = math.max(0, curY - (state.frameSize.Y - 80 * s))
end

-- ========== TAB HELPERS ==========
local function resolveTab(tabIdx)
    if type(tabIdx) == "string" then
        for i, t in ipairs(state.tabs) do
            if t.name == tabIdx then return i end
        end
        return state.currentTab
    end
    return math.clamp(tabIdx or state.currentTab, 1, math.max(1, #state.tabs))
end

local function addWidget(tabIdx, kind, props)
    tabIdx = resolveTab(tabIdx)
    local tab = state.tabs[tabIdx]
    if not tab then return end
    table.insert(tab.widgets, {type=kind, props=props})
    if state.initialized then rebuildContent() end
end

-- ========== API PÚBLICA ==========
function LapoHub:AddTab(name, icon)
    table.insert(state.tabs, {name=name, icon=icon or "", widgets={}})
    return self
end

function LapoHub:AddButton(tabIdx,    cfg) addWidget(tabIdx, "Button",    cfg) return self end
function LapoHub:AddToggle(tabIdx,    cfg) addWidget(tabIdx, "Toggle",    cfg) return self end
function LapoHub:AddSlider(tabIdx,    cfg) addWidget(tabIdx, "Slider",    cfg) return self end
function LapoHub:AddDropdown(tabIdx,  cfg) addWidget(tabIdx, "Dropdown",  cfg) return self end
function LapoHub:AddTextBox(tabIdx,   cfg) addWidget(tabIdx, "TextBox",   cfg) return self end
function LapoHub:AddLabel(tabIdx,     cfg) addWidget(tabIdx, "Label",     cfg) return self end
function LapoHub:AddParagraph(tabIdx, cfg) addWidget(tabIdx, "Paragraph", cfg) return self end
function LapoHub:AddSeparator(tabIdx)      addWidget(tabIdx, "Separator", {})  return self end

function LapoHub:Notify(cfg)
    cfg = cfg or {}
    local s   = state.scale
    local id  = state.notifyId + 1
    state.notifyId = id
    table.insert(state.notifyList, {
        id=id, title=cfg.title or "Lapo Hub X",
        text=cfg.content or "", life=cfg.duration or 4,
        maxLife=cfg.duration or 4, alpha=1, slideY=0,
        bg      = make("Square", {Filled=true, Color=Theme.BgDeep,     Transparency=1,   ZIndex=9990}),
        accent  = make("Square", {Filled=true, Color=Theme.Accent,     Transparency=1,   ZIndex=9991}),
        border  = make("Square", {Filled=false,Color=Theme.Border,     Thickness=1, Transparency=1, ZIndex=9992}),
        titleT  = make("Text",   {Text=cfg.title or "Lapo Hub X", Color=Theme.Text,  Size=13*s, Font=Font, ZIndex=9993}),
        descT   = make("Text",   {Text=cfg.content or "",         Color=Theme.TextSub, Size=11*s, Font=Font, ZIndex=9993}),
        bar     = make("Square", {Filled=true, Color=Theme.Accent,     Transparency=1,   ZIndex=9994}),
    })
    return self
end

function LapoHub:SetUser(name, rank)
    state.userName = name or state.userName
    state.userRank = rank or state.userRank
    if ui.footerName then ui.footerName.Text = state.userName end
    if ui.footerRank then ui.footerRank.Text = state.userRank end
    return self
end

function LapoHub:SetUserCallback(cb)
    state.userCallback = cb
    return self
end

function LapoHub:ToggleVisibility()
    state.visible = not state.visible
    for _, d in ipairs(drgs)          do pcall(function() d.Visible = state.visible end) end
    for _, d in ipairs(contentDrawings) do pcall(function() d.Visible = state.visible end) end
    -- botão mobile sempre visível
    if state.mobile and ui.mobileBtn then
        ui.mobileBtn.Visible       = true
        ui.mobileBtnBorder.Visible = true
        ui.mobileBtnTxt.Visible    = true
        ui.mobileBtnTxt.Text = state.visible and "✕" or "☰"
    end
    return self
end

function LapoHub:Destroy()
    state.destroyFlag = true
    for _, d in ipairs(drgs)            do pcall(function() d:Remove() end) end
    for _, d in ipairs(contentDrawings) do pcall(function() d:Remove() end) end
    for _, n in ipairs(state.notifyList) do
        pcall(function() n.bg:Remove(); n.accent:Remove(); n.border:Remove(); n.titleT:Remove(); n.descT:Remove(); n.bar:Remove() end)
    end
    for _, c in ipairs(state.connections) do pcall(function() c:Disconnect() end) end
    drgs, contentDrawings, tabBgList, tabTextList, tabAccentList = {},{},{},{},{}
    state.connections, widgetList, state.notifyList = {},{},{}
    state.initialized = false
end

-- ========== INPUT ==========
local function setupInput()
    local uis    = game:GetService("UserInputService")
    local runSvc = game:GetService("RunService")

    local function mp() return uis:GetMouseLocation() end
    local function inRect(px,py, rx,ry,rw,rh) return px>=rx and px<=rx+rw and py>=ry and py<=ry+rh end

    -- toggle key
    local c1 = uis.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.End and not state.keyHeldDown then
            state.keyHeldDown = true
            LapoHub:ToggleVisibility()
        end
    end)
    local c2 = uis.InputEnded:Connect(function(inp)
        if inp.KeyCode == Enum.KeyCode.End then state.keyHeldDown = false end
    end)
    table.insert(state.connections, c1)
    table.insert(state.connections, c2)

    -- mouse down
    local c3 = uis.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end

        local pos = mp()
        local px, py = pos.X, pos.Y
        local s     = state.scale
        local mw,mh = state.framePos.X, state.framePos.Y
        local fw,fh = state.frameSize.X, state.frameSize.Y
        local HEADER_H = 34*s
        local SIDE_W   = 160*s
        local FOOTER_H = 52*s
        local BTN_SZ   = 22*s
        local BTN_PAD  = 10*s

        -- botão mobile
        if state.mobile and ui.mobileBtn then
            local BS = 44*s
            local BX = mw + fw + 8*s
            local BY = mh + 4*s
            if inRect(px,py, BX,BY, BS,BS) then
                LapoHub:ToggleVisibility()
                return
            end
        end

        if not state.visible then return end

        -- header — drag ou botões
        if inRect(px,py, mw,mh, fw,HEADER_H) then
            local closeX = mw + fw - BTN_PAD - BTN_SZ
            local minX   = closeX - BTN_SZ - 6*s
            if inRect(px,py, closeX, mh+(HEADER_H-BTN_SZ)/2, BTN_SZ,BTN_SZ) then
                LapoHub:Destroy(); return
            end
            if inRect(px,py, minX, mh+(HEADER_H-BTN_SZ)/2, BTN_SZ,BTN_SZ) then
                state.minimized = not state.minimized
                return
            end
            state.isDragging = true
            state.dragOffset = Vector2.new(px - mw, py - mh)
            return
        end

        -- sidebar — seleção de tabs
        if not state.minimized and inRect(px,py, mw,mh+HEADER_H, SIDE_W,fh-HEADER_H-FOOTER_H) then
            local TAB_H   = 38*s
            local TAB_PAD = 6*s
            for i = 1, #state.tabs do
                local tabY = mh + HEADER_H + TAB_PAD + (i-1)*(TAB_H+2*s)
                if inRect(px,py, mw+2*s,tabY, SIDE_W-4*s,TAB_H) then
                    state.currentTab = i
                    rebuildContent()
                    return
                end
            end
            return
        end

        -- footer do sidebar
        if not state.minimized and inRect(px,py, mw,mh+fh-FOOTER_H, SIDE_W,FOOTER_H) then
            if state.userCallback then state.userCallback(state.userName, state.userRank) end
            return
        end

        -- content area
        if not state.minimized then
            local cX = mw + SIDE_W + 1
            local cY = mh + HEADER_H
            local cW = fw - SIDE_W - 1
            local cH = fh - HEADER_H
            if inRect(px,py, cX,cY, cW,cH) then
                local relY = py - cY + state.contentOffset
                for _, w in ipairs(widgetList) do
                    if relY >= w.y and relY <= w.y + w.h then
                        if w.type == "Button" then
                            w.callback(); return
                        elseif w.type == "Toggle" then
                            w:toggle(); return
                        elseif w.type == "Slider" then
                            state.isSliding     = true
                            state.slidingWidget = w
                            local trackX = cX + 12*s
                            local trackW = cW - 24*s
                            w:updateValue(w.min + math.clamp((px-trackX)/trackW,0,1)*(w.max-w.min))
                            return
                        elseif w.type == "Dropdown" then
                            -- checar clique em popup aberta
                            if w.open then
                                local DISPW  = 150*s
                                local dispX  = cX + (cW-SIDE_W)/2 + SIDE_W/2 - DISPW/2
                                -- usa posição salva
                                local ITEM_H = 32*s
                                local popY   = cY + w.y - state.contentOffset + w.h
                                local popH   = #w.options * ITEM_H
                                if inRect(px,py, cX+8*s, popY, cW-16*s, popH) then
                                    local idx = math.floor((py-popY)/ITEM_H)+1
                                    idx = math.clamp(idx,1,#w.options)
                                    w.selected = idx
                                    w.selectedText.Text = w.options[idx] or "Select"
                                    w.callback(w.selected, w.options[idx])
                                end
                                w.open = false
                                state.dropdownOpen  = false
                                state.dropdownWidget= nil
                                for _, d in ipairs(w.popupDraws) do pcall(function() d:Remove() end) end
                                w.popupDraws = {}
                                return
                            else
                                w.open = true; w.hoverIdx = w.selected
                                state.dropdownOpen   = true
                                state.dropdownWidget = w
                                for _, d in ipairs(w.popupDraws) do pcall(function() d:Remove() end) end
                                w.popupDraws = {}
                                for idx, opt in ipairs(w.options) do
                                    local ob = make("Square", {Filled=true,  Color=Theme.BgWidget, Transparency=1, ZIndex=21})
                                    local ot = make("Text",   {Text=opt, Color=Theme.Text, Size=12*s, Font=Font, ZIndex=22})
                                    table.insert(w.popupDraws, ob)
                                    table.insert(w.popupDraws, ot)
                                    table.insert(contentDrawings, ob)
                                    table.insert(contentDrawings, ot)
                                end
                                return
                            end
                        elseif w.type == "TextBox" then
                            for _, ww in ipairs(widgetList) do
                                if ww.type=="TextBox" and ww.focused then
                                    ww.focused = false
                                    ww.inputBd.Color = Theme.Border
                                    if ww.value=="" then
                                        ww.valueText.Text  = ww.placeholder
                                        ww.valueText.Color = Theme.TextMuted
                                    else
                                        ww.valueText.Color = Theme.Text
                                        ww.callback(ww.value)
                                    end
                                end
                            end
                            w.focused = true
                            w.inputBd.Color    = Theme.Accent
                            w.valueText.Text   = w.value or ""
                            w.valueText.Color  = Theme.Text
                            return
                        end
                    end
                end
                -- clique fora de widgets — desfocar textbox / fechar dropdown
                for _, w in ipairs(widgetList) do
                    if w.type=="TextBox" and w.focused then
                        w.focused = false
                        w.inputBd.Color = Theme.Border
                        if w.value~="" then w.valueText.Color=Theme.Text; w.callback(w.value)
                        else w.valueText.Text=w.placeholder; w.valueText.Color=Theme.TextMuted end
                    end
                    if w.type=="Dropdown" and w.open then
                        w.open=false; state.dropdownOpen=false; state.dropdownWidget=nil
                        for _, d in ipairs(w.popupDraws) do pcall(function() d:Remove() end) end
                        w.popupDraws={}
                    end
                end
            end
        end
    end)
    table.insert(state.connections, c3)

    -- mouse up
    local c4 = uis.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        or inp.UserInputType==Enum.UserInputType.Touch then
            state.isDragging=false
            if state.slidingWidget then state.slidingWidget.isDragging=false end
            state.isSliding=false; state.slidingWidget=nil
        end
    end)
    table.insert(state.connections, c4)

    -- mouse move
    local c5 = uis.InputChanged:Connect(function(inp)
        if not state.visible then return end
        local pos = mp()
        local px,py = pos.X,pos.Y
        local s = state.scale

        if state.isDragging then
            state.framePos = Vector2.new(px-state.dragOffset.X, py-state.dragOffset.Y)
            return
        end
        if state.isSliding and state.slidingWidget then
            local w    = state.slidingWidget
            local SIDE_W = 160*s
            local cX   = state.framePos.X + SIDE_W + 1
            local cW   = state.frameSize.X - SIDE_W - 1
            w:updateValue(w.min + math.clamp((px-(cX+12*s))/(cW-24*s),0,1)*(w.max-w.min))
            return
        end

        -- hover em dropdown popup
        if state.dropdownOpen and state.dropdownWidget then
            local dw     = state.dropdownWidget
            local SIDE_W = 160*s
            local cX     = state.framePos.X + SIDE_W + 1
            local cY     = state.framePos.Y + 34*s
            local cW     = state.frameSize.X - SIDE_W - 1
            local ITEM_H = 32*s
            local popY   = cY + dw.y - state.contentOffset + dw.h
            local popH   = #dw.options * ITEM_H
            if inRect(px,py, cX+8*s,popY, cW-16*s,popH) then
                local idx = math.clamp(math.floor((py-popY)/ITEM_H)+1, 1, #dw.options)
                dw.hoverIdx = idx
                for i, d in ipairs(dw.popupDraws) do
                    if i%2==1 then
                        d.Color = (math.floor((i-1)/2)+1)==idx and Theme.BgPanel or Theme.BgWidget
                    end
                end
            end
        end
    end)
    table.insert(state.connections, c5)

    -- scroll
    local c6 = uis.InputChanged:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        if not state.visible or state.minimized then return end
        local s      = state.scale
        local SIDE_W = 160*s
        local cX     = state.framePos.X + SIDE_W + 1
        local cY     = state.framePos.Y + 34*s
        local cW     = state.frameSize.X - SIDE_W - 1
        local cH     = state.frameSize.Y - 34*s
        local pos    = mp()
        if inRect(pos.X,pos.Y, cX,cY, cW,cH) then
            state.contentOffset = math.clamp(state.contentOffset - inp.Position.Z*32, 0, state.maxOffset)
        end
    end)
    table.insert(state.connections, c6)

    -- teclado — textbox
    local c7 = uis.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for _, w in ipairs(widgetList) do
            if w.type=="TextBox" and w.focused then
                if inp.KeyCode == Enum.KeyCode.Backspace then
                    w.value = string.sub(w.value or "", 1, -2)
                    w.valueText.Text = w.value == "" and "" or w.value
                    return
                end
                if inp.KeyCode == Enum.KeyCode.Return then
                    w.focused=false; w.inputBd.Color=Theme.Border
                    w.callback(w.value)
                    if w.value=="" then w.valueText.Text=w.placeholder; w.valueText.Color=Theme.TextMuted
                    else w.valueText.Color=Theme.Text end
                    return
                end
                local char = ""
                local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift)
                if inp.KeyCode >= Enum.KeyCode.A and inp.KeyCode <= Enum.KeyCode.Z then
                    char = string.char(string.byte("A") + (inp.KeyCode.Value - 8))
                    if not shift then char = string.lower(char) end
                elseif inp.KeyCode >= Enum.KeyCode.One and inp.KeyCode <= Enum.KeyCode.Zero then
                    char = tostring((inp.KeyCode.Value - 9) % 10)
                elseif inp.KeyCode == Enum.KeyCode.Space then
                    char = " "
                end
                if #char > 0 then
                    w.value = (w.value or "") .. char
                    w.valueText.Text  = w.value
                    w.valueText.Color = Theme.Text
                end
                return
            end
        end
    end)
    table.insert(state.connections, c7)
end

-- ========== RENDER LOOP ==========
local function startRenderLoop()
    local runSvc = game:GetService("RunService")
    local conn
    conn = runSvc.RenderStepped:Connect(function(dt)
        if state.destroyFlag then conn:Disconnect(); return end

        -- ---- notificações ----------------------------------------
        local toRm = {}
        local screenW = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1280
        local screenH = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 720
        local NW = 280 * state.scale
        local NH = 72  * state.scale
        local NX = screenW - NW - 16 * state.scale
        local s  = state.scale

        for i, n in ipairs(state.notifyList) do
            n.life = n.life - dt
            if n.life > n.maxLife - 0.25 then
                local t = 1 - (n.life - (n.maxLife-0.25)) / 0.25
                n.slideY = lerp(-NH, 0, t)
            elseif n.life <= 0 then
                n.alpha = math.max(0, n.alpha - dt*4)
            end

            local ny = screenH - NH - 16*s - (#state.notifyList - i) * (NH + 6*s) + n.slideY
            local al = n.alpha

            n.bg.Position     = Vector2.new(NX, ny)
            n.bg.Size         = Vector2.new(NW, NH)
            n.bg.Transparency = al
            n.bg.Visible      = al > 0

            -- accent stripe esquerda
            n.accent.Position     = Vector2.new(NX, ny)
            n.accent.Size         = Vector2.new(3*s, NH)
            n.accent.Transparency = al
            n.accent.Visible      = al > 0

            n.border.Position     = Vector2.new(NX, ny)
            n.border.Size         = Vector2.new(NW, NH)
            n.border.Transparency = al * 0.6
            n.border.Visible      = al > 0

            n.titleT.Position     = Vector2.new(NX + 10*s, ny + 10*s)
            n.titleT.Transparency = al > 0 and 0 or 1
            n.titleT.Visible      = al > 0

            n.descT.Position      = Vector2.new(NX + 10*s, ny + 30*s)
            n.descT.Transparency  = al > 0 and 0 or 1
            n.descT.Visible       = al > 0

            -- barra de progresso na base
            local prog = math.max(0, n.life / n.maxLife)
            n.bar.Position     = Vector2.new(NX + 3*s, ny + NH - 2*s)
            n.bar.Size         = Vector2.new((NW-3*s) * prog, 2*s)
            n.bar.Transparency = al
            n.bar.Visible      = al > 0

            if n.alpha <= 0 then table.insert(toRm, i) end
        end
        for i = #toRm, 1, -1 do
            local n = table.remove(state.notifyList, toRm[i])
            pcall(function() n.bg:Remove(); n.accent:Remove(); n.border:Remove(); n.titleT:Remove(); n.descT:Remove(); n.bar:Remove() end)
        end

        if not state.visible then return end

        local ss    = state.scale
        local pos   = state.framePos
        local sz    = state.frameSize
        local mw,mh = pos.X, pos.Y
        local fw,fh = sz.X, sz.Y
        local HEADER_H = 34*ss
        local SIDE_W   = 160*ss
        local FOOTER_H = 52*ss

        if state.minimized then fh = HEADER_H end

        -- estrutura
        ui.shadow.Position = Vector2.new(mw-8*ss, mh-8*ss)
        ui.shadow.Size     = Vector2.new(fw+16*ss, fh+16*ss)

        ui.frame.Position       = Vector2.new(mw, mh)
        ui.frame.Size           = Vector2.new(fw, fh)
        ui.frameBorder.Position = Vector2.new(mw, mh)
        ui.frameBorder.Size     = Vector2.new(fw, fh)

        ui.header.Position      = Vector2.new(mw, mh)
        ui.header.Size          = Vector2.new(fw, HEADER_H)
        ui.headerLine.Position  = Vector2.new(mw, mh+HEADER_H-1)
        ui.headerLine.Size      = Vector2.new(fw, 1)

        ui.titleText.Position   = Vector2.new(mw+14*ss, mh+(HEADER_H-14*ss)/2 - 5*ss)
        ui.subtitleText.Position= Vector2.new(mw+14*ss, mh+(HEADER_H-14*ss)/2 + 9*ss)

        local btnSz  = 22*ss
        local btnPad = 10*ss
        local btnY   = mh + (HEADER_H-btnSz)/2
        local closeX = mw + fw - btnPad - btnSz
        local minX   = closeX - btnSz - 6*ss

        ui.closeBtn.Position = Vector2.new(closeX, btnY)
        ui.closeBtn.Size     = Vector2.new(btnSz, btnSz)
        ui.closeTxt.Position = Vector2.new(closeX + 5*ss, btnY + 3*ss)
        ui.minBtn.Position   = Vector2.new(minX,   btnY)
        ui.minBtn.Size       = Vector2.new(btnSz,  btnSz)
        ui.minTxt.Position   = Vector2.new(minX + 4*ss, btnY + 2*ss)

        local showBody = not state.minimized

        ui.sidebar.Visible    = showBody
        ui.sidebarLine.Visible= showBody
        ui.content.Visible    = showBody
        ui.footerBg.Visible   = showBody
        ui.footerLine.Visible = showBody
        ui.footerDot.Visible  = showBody
        ui.footerName.Visible = showBody
        ui.footerRank.Visible = showBody

        if showBody then
            ui.sidebar.Position      = Vector2.new(mw, mh+HEADER_H)
            ui.sidebar.Size          = Vector2.new(SIDE_W, fh-HEADER_H)
            ui.sidebarLine.Position  = Vector2.new(mw+SIDE_W, mh+HEADER_H)
            ui.sidebarLine.Size      = Vector2.new(1, fh-HEADER_H)
            ui.content.Position      = Vector2.new(mw+SIDE_W+1, mh+HEADER_H)
            ui.content.Size          = Vector2.new(fw-SIDE_W-1, fh-HEADER_H)
            ui.footerBg.Position     = Vector2.new(mw, mh+fh-FOOTER_H)
            ui.footerBg.Size         = Vector2.new(SIDE_W, FOOTER_H)
            ui.footerLine.Position   = Vector2.new(mw, mh+fh-FOOTER_H)
            ui.footerLine.Size       = Vector2.new(SIDE_W, 1)
            local dotSz = 7*ss
            ui.footerDot.Position    = Vector2.new(mw+12*ss, mh+fh-FOOTER_H+(FOOTER_H-dotSz)/2)
            ui.footerDot.Size        = Vector2.new(dotSz, dotSz)
            ui.footerName.Position   = Vector2.new(mw+24*ss, mh+fh-FOOTER_H+11*ss)
            ui.footerRank.Position   = Vector2.new(mw+24*ss, mh+fh-FOOTER_H+27*ss)

            -- tabs
            local TAB_H   = 38*ss
            local TAB_PAD = 6*ss
            for i, bg in ipairs(tabBgList) do
                local tabY  = mh+HEADER_H+TAB_PAD+(i-1)*(TAB_H+2*ss)
                local active= i==state.currentTab
                bg.Position = Vector2.new(mw+2*ss, tabY)
                bg.Size     = Vector2.new(SIDE_W-4*ss, TAB_H)
                bg.Color    = active and Theme.BgWidget or Color3.new(0,0,0)
                bg.Transparency = active and 1 or 0
                bg.Visible  = true
                tabTextList[i].Position = Vector2.new(mw+22*ss, tabY+(TAB_H-12*ss)/2)
                tabTextList[i].Color    = active and Theme.Text or Theme.TextSub
                tabTextList[i].Visible  = true
                tabAccentList[i].Position    = Vector2.new(mw+2*ss, tabY+6*ss)
                tabAccentList[i].Size        = Vector2.new(3*ss, TAB_H-12*ss)
                tabAccentList[i].Transparency= active and 1 or 0
                tabAccentList[i].Visible     = true
            end

            -- widgets
            local cX = mw + SIDE_W + 1
            local cY = mh + HEADER_H
            local cW = fw - SIDE_W - 1
            local cH = fh - HEADER_H
            local PAD = 10*ss

            for _, w in ipairs(widgetList) do
                local wy  = cY + w.y - state.contentOffset
                local wh  = w.h
                local vis = wy+wh > cY and wy < cY+cH

                -- helpers visibilidade
                local function setVis(obj, v) if obj then obj.Visible = v end end
                local function hide(...)
                    for _, o in ipairs({...}) do setVis(o,false) end
                end

                if not vis then
                    hide(w.bg, w.label, w.border)
                    if w.type=="Toggle"    then hide(w.trackBg,w.trackBd,w.knob) end
                    if w.type=="Slider"    then hide(w.track,w.fill,w.thumb,w.thumbGl,w.valText) end
                    if w.type=="Dropdown"  then hide(w.dispBg,w.dispBd,w.selectedText,w.arrow,w.popupBg,w.popupBd) for _,d in ipairs(w.popupDraws) do setVis(d,false) end end
                    if w.type=="TextBox"   then hide(w.inputBg,w.inputBd,w.valueText,w.cursor) end
                    if w.type=="Separator" then hide(w.line) end
                else
                    local wW = cW - PAD*2

                    if w.type == "Separator" then
                        w.line.Position = Vector2.new(cX+PAD, wy+w.h/2)
                        w.line.Size     = Vector2.new(wW, 1)
                        w.line.Visible  = true

                    elseif w.type == "Label" then
                        w.label.Position = Vector2.new(cX+PAD, wy+4*ss)
                        w.label.Visible  = true

                    elseif w.type == "Paragraph" then
                        w.label.Position = Vector2.new(cX+PAD, wy+4*ss)
                        w.label.Visible  = true

                    elseif w.type == "Button" then
                        -- hover suave
                        local mpos = game:GetService("UserInputService"):GetMouseLocation()
                        local hovering = mpos.X>=cX+PAD and mpos.X<=cX+PAD+wW and mpos.Y>=wy and mpos.Y<=wy+wh
                        w.hoverT = lerp(w.hoverT or 0, hovering and 1 or 0, dt*10)
                        local t  = w.hoverT

                        w.bg.Position     = Vector2.new(cX+PAD, wy)
                        w.bg.Size         = Vector2.new(wW, wh)
                        w.bg.Color        = lerpColor(Theme.BgWidget, Theme.BgPanel, t)
                        w.bg.Visible      = true
                        w.border.Position = Vector2.new(cX+PAD, wy)
                        w.border.Size     = Vector2.new(wW, wh)
                        w.border.Color    = lerpColor(Theme.Border, Theme.Accent, t)
                        w.border.Visible  = true
                        -- barrinha accent na esquerda
                        w.bar.Position    = Vector2.new(cX+PAD, wy+4*ss)
                        w.bar.Size        = Vector2.new(3*ss, wh-8*ss)
                        w.bar.Color       = Theme.Accent
                        w.bar.Transparency= t
                        w.bar.Visible     = true
                        w.label.Position  = Vector2.new(cX+PAD+14*ss, wy+(wh-13*ss)/2)
                        w.label.Text      = w.text
                        w.label.Color     = lerpColor(Theme.Text, Theme.AccentGlow, t*0.5)
                        w.label.Visible   = true

                    elseif w.type == "Toggle" then
                        local TRACK_W = 36*ss
                        local TRACK_H = 18*ss
                        local tX      = cX+PAD+wW-TRACK_W-8*ss
                        local tY      = wy+(wh-TRACK_H)/2
                        local knobSz  = TRACK_H - 4*ss
                        local knobX   = w.value and (tX+TRACK_W-knobSz-2*ss) or (tX+2*ss)

                        w.bg.Position      = Vector2.new(cX+PAD, wy)
                        w.bg.Size          = Vector2.new(wW, wh)
                        w.bg.Visible       = true
                        w.border.Position  = Vector2.new(cX+PAD, wy)
                        w.border.Size      = Vector2.new(wW, wh)
                        w.border.Visible   = true
                        w.trackBg.Position = Vector2.new(tX, tY)
                        w.trackBg.Size     = Vector2.new(TRACK_W, TRACK_H)
                        w.trackBg.Visible  = true
                        w.trackBd.Position = Vector2.new(tX, tY)
                        w.trackBd.Size     = Vector2.new(TRACK_W, TRACK_H)
                        w.trackBd.Visible  = true
                        w.knob.Position    = Vector2.new(knobX, tY+2*ss)
                        w.knob.Size        = Vector2.new(knobSz, knobSz)
                        w.knob.Visible     = true
                        w.label.Position   = Vector2.new(cX+PAD+10*ss, wy+(wh-13*ss)/2)
                        w.label.Text       = w.text
                        w.label.Visible    = true

                    elseif w.type == "Slider" then
                        local trkX = cX+PAD+10*ss
                        local trkW = wW-20*ss
                        local trkH = 5*ss
                        local trkY = wy+wh-16*ss
                        local ratio= (w.value-w.min)/(w.max-w.min)

                        w.bg.Position       = Vector2.new(cX+PAD, wy)
                        w.bg.Size           = Vector2.new(wW, wh)
                        w.bg.Visible        = true
                        w.border.Position   = Vector2.new(cX+PAD, wy)
                        w.border.Size       = Vector2.new(wW, wh)
                        w.border.Visible    = true
                        w.label.Position    = Vector2.new(cX+PAD+10*ss, wy+6*ss)
                        w.label.Text        = w.text
                        w.label.Visible     = true
                        w.valText.Position  = Vector2.new(cX+PAD+wW-45*ss, wy+6*ss)
                        w.valText.Text      = tostring(math.floor(w.value))
                        w.valText.Visible   = true
                        w.track.Position    = Vector2.new(trkX, trkY)
                        w.track.Size        = Vector2.new(trkW, trkH)
                        w.track.Visible     = true
                        w.fill.Position     = Vector2.new(trkX, trkY)
                        w.fill.Size         = Vector2.new(trkW*ratio, trkH)
                        w.fill.Visible      = true
                        local thumbSz = 12*ss
                        local thumbX  = trkX + trkW*ratio - thumbSz/2
                        w.thumb.Position    = Vector2.new(thumbX, trkY - (thumbSz-trkH)/2)
                        w.thumb.Size        = Vector2.new(thumbSz, thumbSz)
                        w.thumb.Visible     = true
                        w.thumbGl.Position  = Vector2.new(thumbX-1, trkY-(thumbSz-trkH)/2-1)
                        w.thumbGl.Size      = Vector2.new(thumbSz+2, thumbSz+2)
                        w.thumbGl.Visible   = true

                    elseif w.type == "Dropdown" then
                        local DISPW = 150*ss
                        local dispX = cX+PAD+wW-DISPW-8*ss
                        local dispH = wh - 16*ss

                        w.bg.Position       = Vector2.new(cX+PAD, wy)
                        w.bg.Size           = Vector2.new(wW, wh)
                        w.bg.Visible        = true
                        w.border.Position   = Vector2.new(cX+PAD, wy)
                        w.border.Size       = Vector2.new(wW, wh)
                        w.border.Color      = w.open and Theme.Accent or Theme.Border
                        w.border.Visible    = true
                        w.label.Position    = Vector2.new(cX+PAD+10*ss, wy+(wh-13*ss)/2)
                        w.label.Text        = w.text
                        w.label.Visible     = true
                        w.dispBg.Position   = Vector2.new(dispX, wy+8*ss)
                        w.dispBg.Size       = Vector2.new(DISPW, dispH)
                        w.dispBg.Visible    = true
                        w.dispBd.Position   = Vector2.new(dispX, wy+8*ss)
                        w.dispBd.Size       = Vector2.new(DISPW, dispH)
                        w.dispBd.Visible    = true
                        w.selectedText.Position = Vector2.new(dispX+8*ss, wy+(wh-12*ss)/2)
                        w.selectedText.Text = w.options[w.selected] or "Select"
                        w.selectedText.Visible  = true
                        w.arrow.Position    = Vector2.new(dispX+DISPW-16*ss, wy+(wh-12*ss)/2)
                        w.arrow.Text        = w.open and "▴" or "▾"
                        w.arrow.Visible     = true

                        w.popupBg.Visible   = w.open
                        w.popupBd.Visible   = w.open
                        if w.open then
                            local ITEM_H = 32*ss
                            local popY   = wy + wh
                            local popH   = #w.options * ITEM_H
                            w.popupBg.Position = Vector2.new(cX+8*ss, popY)
                            w.popupBg.Size     = Vector2.new(cW-16*ss, popH)
                            w.popupBd.Position = Vector2.new(cX+8*ss, popY)
                            w.popupBd.Size     = Vector2.new(cW-16*ss, popH)
                            for i, d in ipairs(w.popupDraws) do
                                d.Visible = true
                                if i%2==1 then
                                    local optIdx = math.floor((i-1)/2)+1
                                    d.Position = Vector2.new(cX+8*ss, popY+(optIdx-1)*ITEM_H)
                                    d.Size     = Vector2.new(cW-16*ss, ITEM_H)
                                    d.Color    = (optIdx==w.hoverIdx) and Theme.BgPanel or Theme.BgWidget
                                else
                                    local optIdx = math.floor((i-2)/2)+1
                                    d.Position = Vector2.new(cX+18*ss, popY+(optIdx-1)*ITEM_H+(ITEM_H-12*ss)/2)
                                    d.Color    = (optIdx==w.hoverIdx) and Theme.Text or Theme.TextSub
                                end
                            end
                        end

                    elseif w.type == "TextBox" then
                        local inputY = wy+28*ss
                        local inputH = wh-34*ss

                        w.bg.Position       = Vector2.new(cX+PAD, wy)
                        w.bg.Size           = Vector2.new(wW, wh)
                        w.bg.Visible        = true
                        w.border.Position   = Vector2.new(cX+PAD, wy)
                        w.border.Size       = Vector2.new(wW, wh)
                        w.border.Color      = w.focused and Theme.Accent or Theme.Border
                        w.border.Visible    = true
                        w.label.Position    = Vector2.new(cX+PAD+10*ss, wy+6*ss)
                        w.label.Text        = w.text
                        w.label.Visible     = true
                        w.inputBg.Position  = Vector2.new(cX+PAD+8*ss, inputY)
                        w.inputBg.Size      = Vector2.new(wW-16*ss, inputH)
                        w.inputBg.Visible   = true
                        w.inputBd.Position  = Vector2.new(cX+PAD+8*ss, inputY)
                        w.inputBd.Size      = Vector2.new(wW-16*ss, inputH)
                        w.inputBd.Visible   = true
                        local txtX = cX+PAD+14*ss
                        local txtY = inputY+(inputH-12*ss)/2
                        w.valueText.Position= Vector2.new(txtX, txtY)
                        w.valueText.Visible = true
                        -- cursor piscante
                        local cursorX = txtX + (#(w.valueText.Text or "")) * 7*ss
                        w.cursor.Position   = Vector2.new(cursorX, txtY-1)
                        w.cursor.Visible    = w.focused and (math.floor(tick()*2)%2==0)
                    end
                end
            end
        else
            for _, bg in ipairs(tabBgList)     do bg.Visible = false end
            for _, tt in ipairs(tabTextList)   do tt.Visible = false end
            for _, ac in ipairs(tabAccentList) do ac.Visible = false end
            for _, w  in ipairs(widgetList) do
                for _, o in pairs({w.bg,w.label,w.border,w.track,w.fill,w.thumb,w.thumbGl,
                    w.valText,w.trackBg,w.trackBd,w.knob,w.dispBg,w.dispBd,
                    w.selectedText,w.arrow,w.popupBg,w.popupBd,w.inputBg,w.inputBd,
                    w.valueText,w.cursor,w.bar,w.line}) do
                    if o then pcall(function() o.Visible=false end) end
                end
            end
        end

        -- botão mobile — sempre atualiza pos
        if state.mobile and ui.mobileBtn then
            local BS = 44*ss
            local BX = mw + fw + 8*ss
            local BY = mh + 4*ss
            ui.mobileBtn.Position       = Vector2.new(BX, BY)
            ui.mobileBtn.Size           = Vector2.new(BS, BS)
            ui.mobileBtn.Color          = state.visible and Theme.AccentDim or Theme.Accent
            ui.mobileBtn.Visible        = true
            ui.mobileBtnBorder.Position = Vector2.new(BX, BY)
            ui.mobileBtnBorder.Size     = Vector2.new(BS, BS)
            ui.mobileBtnBorder.Visible  = true
            ui.mobileBtnTxt.Position    = Vector2.new(BX+12*ss, BY+12*ss)
            ui.mobileBtnTxt.Text        = state.visible and "✕" or "☰"
            ui.mobileBtnTxt.Visible     = true
        end
    end)
    table.insert(state.connections, conn)
end

-- ========== INIT ==========
function LapoHub:Init(config)
    config = config or {}
    state.title     = config.Title     or "Lapo Hub X"
    state.toggleKey = config.ToggleKey or "End"
    state.mobile    = detectMobile()
    state.scale     = state.mobile and 0.72 or 1

    local s = state.scale
    if state.mobile then
        state.frameSize = Vector2.new(460*s, 540*s)
        state.framePos  = Vector2.new(16, 40)
    else
        state.frameSize = Vector2.new(820*s, 500*s)
        state.framePos  = Vector2.new(120, 80)
    end

    buildStructure()
    buildTabs()

    state.initialized = true
    rebuildContent()
    setupInput()
    startRenderLoop()

    local saved = loadConfig()
    if saved.currentTab then
        state.currentTab = math.clamp(saved.currentTab, 1, math.max(1,#state.tabs))
        rebuildContent()
    end

    self:Notify({
        title   = "Lapo Hub X",
        content = (state.mobile and "📱 Mobile" or "🖥 Desktop") .. " — pronto",
        duration= 3
    })

    return self
end

return LapoHub
