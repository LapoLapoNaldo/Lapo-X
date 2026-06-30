local LapoX = {}
LapoX.__index = LapoX

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
    isScrolling = false,
    scrollStartPos = Vector2.new(0, 0),
    scrollStartOffset = 0,
    touchStartPos = nil,
    draggedPastThreshold = false,
    pressedWidget = nil,
    isScrollingDropdown = false,
    pressedDropdownItemIndex = nil,
    framePos = Vector2.new(120, 80),
    frameSize = Vector2.new(960, 600),
    hasDrawing = pcall(function() return Drawing.new end),
    connections = {},
    initialized = false,
    destroyFlag = false,
    batchMode = false,
    keyHeldDown = false,
    notifyId = 0,
    userName = "LapoLapoNaldo",
    userRank = "Lapo Newba",
    userCallback = nil,
    title = "Lapo Library X",
    toggleKey = "End",
    mobileBtn = nil,
    focusedTextBox = nil,
    sinkTextBox = nil,
    mainInputFrame = nil,
    mobileInputFrame = nil,
    dropdownInputFrame = nil,
}

local Theme = {
    BgDeep      = Color3.fromRGB(10,  10,  18),
    BgBase      = Color3.fromRGB(14,  14,  26),
    BgPanel     = Color3.fromRGB(18,  18,  32),
    BgWidget    = Color3.fromRGB(22,  22,  38),
    BgInput     = Color3.fromRGB(12,  12,  22),
    Border      = Color3.fromRGB(40,  40,  70),
    BorderAccent= Color3.fromRGB(80,  60, 180),
    Separator   = Color3.fromRGB(30,  30,  50),
    Accent      = Color3.fromRGB(120,  80, 255),
    AccentDim   = Color3.fromRGB( 70,  45, 160),
    AccentGlow  = Color3.fromRGB(140, 100, 255),
    On          = Color3.fromRGB( 50, 220, 120),
    OnDim       = Color3.fromRGB( 20, 100,  55),
    Text        = Color3.fromRGB(220, 220, 235),
    TextSub     = Color3.fromRGB(110, 110, 140),
    TextMuted   = Color3.fromRGB( 60,  60,  90),
    Danger      = Color3.fromRGB(220,  55,  55),
    HoverLight  = Color3.fromRGB(255, 255, 255),
}

local Font = Drawing.Fonts.Monospace or Drawing.Fonts.UI

if not math.clamp then
    function math.clamp(v, min, max)
        if v < min then return min end
        if v > max then return max end
        return v
    end
end

local function detectMobile()
    local ok, uis = pcall(function() return game:GetService("UserInputService") end)
    if ok then return uis.TouchEnabled and not uis.KeyboardEnabled end
    return false
end

local UIS_SVC = (function()
    local ok, s = pcall(function() return game:GetService("UserInputService") end)
    return ok and s or nil
end)()

local function lerp(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t)
    if t <= 0 then return a end
    if t >= 1 then return b end
    return Color3.new(
        lerp(a.R, b.R, t),
        lerp(a.G, b.G, t),
        lerp(a.B, b.B, t)
    )
end

-- ============================================================
--  ETAPA 1 — Fundação de animação (Opção A)
--  A Drawing API não suporta TweenService/UIListLayout/UIPadding,
--  então implementamos equivalentes próprios que rodam no
--  RenderStepped. Estas peças não alteram o visual sozinhas;
--  são usadas pelas etapas seguintes (loading, hover, layout).
-- ============================================================

-- Funções de easing (curvas de aceleração)
local Ease = {}
function Ease.linear(t)  return t end
function Ease.outQuad(t) return 1 - (1 - t) * (1 - t) end
function Ease.inQuad(t)  return t * t end
function Ease.inOutQuad(t)
    if t < 0.5 then return 2 * t * t end
    local f = -2 * t + 2
    return 1 - (f * f) / 2
end
function Ease.outCubic(t) local f = 1 - t; return 1 - f * f * f end
function Ease.inCubic(t)  return t * t * t end
function Ease.inOutCubic(t)
    if t < 0.5 then return 4 * t * t * t end
    local f = -2 * t + 2
    return 1 - (f * f * f) / 2
end
function Ease.outBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    local f  = t - 1
    return 1 + c3 * f * f * f + c1 * f * f
end
function Ease.outExpo(t)
    if t >= 1 then return 1 end
    return 1 - 2 ^ (-10 * t)
end

-- Suavização exponencial independente de framerate.
-- Ideal para estados contínuos (hover/press) que perseguem um alvo.
local function damp(current, target, speed, dt)
    local a = 1 - math.exp(-(speed or 10) * (dt or 1 / 60))
    return current + (target - current) * a
end

-- Medidas base de layout (sem escala) — centraliza os "magic numbers".
-- Equivalente conceitual a UIPadding + UIListLayout.Padding.
local Layout = {
    contentPad = 12,  -- padding das bordas da área de conteúdo
    gap        = 8,   -- espaço vertical entre widgets
    widgetPadX = 12,  -- padding horizontal interno dos widgets
}

local function inRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

local function truncateText(txt, maxW, fontSize)
    txt = tostring(txt)
    local charW = fontSize * 0.55
    local maxChars = math.floor(maxW / charW)
    if #txt * charW > maxW then
        if maxChars > 3 then
            return string.sub(txt, 1, maxChars - 3) .. "..."
        else
            return string.sub(txt, 1, math.max(1, maxChars))
        end
    end
    return txt
end

local function truncCached(w, key, txt, maxW, fontSize)
    local ck = w._trunc
    if not ck then ck = {}; w._trunc = ck end
    local e = ck[key]
    if e and e.txt == txt and e.maxW == maxW and e.fs == fontSize then return e.out end
    local out = truncateText(txt, maxW, fontSize)
    if e then
        e.txt, e.maxW, e.fs, e.out = txt, maxW, fontSize, out
    else
        ck[key] = {txt = txt, maxW = maxW, fs = fontSize, out = out}
    end
    return out
end

local function renderClippedSquare(squareObj, posX, posY, sizeX, sizeY, cY, cY2)
    local top = posY
    local bottom = posY + sizeY
    if bottom <= cY or top >= cY2 then
        squareObj.Visible = false
        return
    end
    local drawTop = math.clamp(top, cY, cY2)
    local drawBottom = math.clamp(bottom, cY, cY2)
    local drawHeight = drawBottom - drawTop
    if drawHeight <= 0 then
        squareObj.Visible = false
    else
        squareObj.Position = Vector2.new(posX, drawTop)
        squareObj.Size = Vector2.new(sizeX, drawHeight)
        squareObj.Visible = true
    end
end

local function renderClippedOutline(obj, posX, posY, sizeX, sizeY, cY, cY2)
    if posY >= cY and (posY + sizeY) <= cY2 then
        obj.Position = Vector2.new(posX, posY)
        obj.Size = Vector2.new(sizeX, sizeY)
        obj.Visible = true
    else
        obj.Visible = false
    end
end

local function isSubVisible(y, h, cY, cY2)
    return y >= cY and (y + h) <= cY2
end

local function setVis(obj, v) if obj then obj.Visible = v end end
local function hide(...)
    for i = 1, select("#", ...) do
        local o = select(i, ...)
        if o then o.Visible = false end
    end
end

local function getGuiParent()
    local p = game:GetService("Players").LocalPlayer
    if p then
        local success, pg = pcall(function() return p:FindFirstChildOfClass("PlayerGui") end)
        if success and pg then return pg end
    end
    local cl, cg = pcall(function() return game:GetService("CoreGui") end)
    if cl and cg then return cg end
    return nil
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
        writefile("LapoLibraryX_Config.txt", game:GetService("HttpService"):JSONEncode(data))
    end)
end

local function loadConfig()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("LapoLibraryX_Config.txt"))
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

local drgs           = {}
local tabBgList      = {}
local tabTextList    = {}
local tabAccentList  = {}
local contentDrawings = {}
local widgetList      = {}

local DD_MAX_VIS = 6

local function pool(obj) table.insert(drgs, obj); return obj end
local function cdraw(obj) table.insert(contentDrawings, obj); return obj end

local tabDrawings = {}
local function tpool(obj) table.insert(tabDrawings, obj); return obj end

local ui = {}

local function buildStructure()
    local s = state.scale

    ui.shadow = pool(make("Square", {
        Filled = true, Color = Color3.new(0,0,0),
        Transparency = 0.6, ZIndex = 8, Visible = state.visible
    }))

    ui.frame = pool(make("Square", {
        Filled = true, Color = Theme.BgBase,
        Transparency = 1, ZIndex = 9, Visible = state.visible
    }))

    ui.frameBorder = pool(make("Square", {
        Filled = false, Color = Theme.Border,
        Thickness = 1, Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    ui.header = pool(make("Square", {
        Filled = true, Color = Theme.BgPanel,
        Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    ui.headerLine = pool(make("Square", {
        Filled = true, Color = Theme.Accent,
        Transparency = 1, ZIndex = 12, Visible = state.visible
    }))

    ui.titleText = pool(make("Text", {
        Text = state.title, Color = Theme.Text,
        Size = 19 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))

    ui.subtitleText = pool(make("Text", {
        Text = "syn version", Color = Theme.Accent,
        Size = 14 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))

    ui.closeBtn = pool(make("Square", {
        Filled = true, Color = Theme.Danger,
        Transparency = 1, ZIndex = 13, Visible = state.visible
    }))
    ui.closeTxt = pool(make("Text", {
        Text = "✕", Color = Theme.Text,
        Size = 16 * s, Font = Font,
        ZIndex = 14, Visible = state.visible
    }))

    ui.minBtn = pool(make("Square", {
        Filled = true, Color = Theme.BgWidget,
        Transparency = 1, ZIndex = 13, Visible = state.visible
    }))
    ui.minTxt = pool(make("Text", {
        Text = "─", Color = Theme.TextSub,
        Size = 16 * s, Font = Font,
        ZIndex = 14, Visible = state.visible
    }))

    ui.sidebar = pool(make("Square", {
        Filled = true, Color = Theme.BgPanel,
        Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

    ui.sidebarLine = pool(make("Square", {
        Filled = true, Color = Theme.Separator,
        Transparency = 1, ZIndex = 12, Visible = state.visible
    }))

    ui.content = pool(make("Square", {
        Filled = true, Color = Theme.BgBase,
        Transparency = 1, ZIndex = 10, Visible = state.visible
    }))

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
        Size = 16 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))
    ui.footerRank = pool(make("Text", {
        Text = state.userRank, Color = Theme.Accent,
        Size = 14 * s, Font = Font,
        ZIndex = 13, Visible = state.visible
    }))

    state._userNameTxt = ui.footerName
    state._userRankTxt = ui.footerRank
    state._userBg      = ui.footerBg

    -- Indicador de aba deslizante (destaque + barra de accent que escorrega
    -- entre as abas). Substitui o acender/apagar por tab.
    ui.tabHighlight = pool(make("Square", {
        Filled = true, Color = Theme.BgWidget,
        Transparency = 1, ZIndex = 11, Visible = state.visible
    }))
    ui.tabIndicator = pool(make("Square", {
        Filled = true, Color = Theme.Accent,
        Transparency = 1, ZIndex = 14, Visible = state.visible
    }))

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
            Size = 24 * s, Font = Font,
            ZIndex = 102, Visible = true
        }))
    end
end

local function buildTabs()
    for _, b in ipairs(tabBgList)     do pcall(function() b:Remove() end) end
    for _, t in ipairs(tabTextList)   do pcall(function() t:Remove() end) end
    for _, a in ipairs(tabAccentList) do pcall(function() a:Remove() end) end
    tabBgList, tabTextList, tabAccentList = {}, {}, {}
    tabDrawings = {}
    state.tabIndY = nil        -- faz o indicador "encaixar" na aba ativa no 1º frame
    state.tabTextAnim = {}

    local s = state.scale
    for i, tab in ipairs(state.tabs) do
        local bg = tpool(make("Square", {
            Filled = true, Color = Color3.new(0,0,0),
            Transparency = 0, ZIndex = 12, Visible = state.visible
        }))
        local txt = tpool(make("Text", {
            Text = (tab.icon and tab.icon ~= "" and (tab.icon .. "  ") or "") .. (tab.name or "Tab"),
            Color = Theme.TextSub, Size = 16 * s, Font = Font,
            ZIndex = 13, Visible = state.visible
        }))
        local accent = tpool(make("Square", {
            Filled = true, Color = Theme.Accent,
            Transparency = 1, ZIndex = 14, Visible = state.visible
        }))
        table.insert(tabBgList,     bg)
        table.insert(tabTextList,   txt)
        table.insert(tabAccentList, accent)
    end
end

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
    local BTN_SZ    = 22 * s
    local BTN_PAD   = 10 * s

    if state.minimized then fh = HEADER_H end

    ui.shadow.Position = Vector2.new(mw - SHADOW_P, mh - SHADOW_P)
    ui.shadow.Size     = Vector2.new(fw + SHADOW_P*2, fh + SHADOW_P*2)
    ui.shadow.Visible  = state.visible

    ui.frame.Position  = Vector2.new(mw, mh)
    ui.frame.Size      = Vector2.new(fw, fh)
    ui.frame.Visible   = state.visible

    ui.frameBorder.Position = Vector2.new(mw, mh)
    ui.frameBorder.Size     = Vector2.new(fw, fh)
    ui.frameBorder.Visible  = state.visible

    ui.header.Position  = Vector2.new(mw, mh)
    ui.header.Size      = Vector2.new(fw, HEADER_H)
    ui.header.Visible   = state.visible

    ui.headerLine.Position = Vector2.new(mw, mh + HEADER_H - 1)
    ui.headerLine.Size     = Vector2.new(fw, 1)
    ui.headerLine.Visible  = state.visible

    ui.titleText.Position  = Vector2.new(mw + 14 * s, mh + (HEADER_H - 19 * s) / 2 - 5 * s)
    ui.titleText.Visible   = state.visible
    ui.titleText.Size      = 18 * s

    ui.subtitleText.Position = Vector2.new(mw + 14 * s, mh + (HEADER_H - 19 * s) / 2 + 10 * s)
    ui.subtitleText.Visible  = state.visible
    ui.subtitleText.Size     = 13 * s

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

    ui.sidebar.Position  = Vector2.new(mw, mh + HEADER_H)
    ui.sidebar.Size      = Vector2.new(SIDE_W, fh - HEADER_H)
    ui.sidebar.Visible   = state.visible

    ui.sidebarLine.Position = Vector2.new(mw + SIDE_W, mh + HEADER_H)
    ui.sidebarLine.Size     = Vector2.new(1, fh - HEADER_H)
    ui.sidebarLine.Visible  = state.visible

    local cX = mw + SIDE_W + 1
    local cY = mh + HEADER_H
    local cW = fw - SIDE_W - 1
    local cH = fh - HEADER_H
    ui.content.Position = Vector2.new(cX, cY)
    ui.content.Size     = Vector2.new(cW, cH)
    ui.content.Visible  = state.visible

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

    local TAB_H   = 38 * s
    local TAB_PAD = 6 * s

    for i, bg in ipairs(tabBgList) do
        local tabY = mh + HEADER_H + TAB_PAD + (i - 1) * (TAB_H + 2 * s)
        local active = i == state.currentTab

        bg.Position    = Vector2.new(mw + 2 * s, tabY)
        bg.Size        = Vector2.new(SIDE_W - 4 * s, TAB_H)
        bg.Color       = active and Theme.BgWidget or Color3.new(0,0,0)
        bg.Transparency= active and 1 or 0
        bg.Visible     = state.visible

        tabTextList[i].Position  = Vector2.new(mw + 22 * s, tabY + (TAB_H - 16 * s) / 2)
        tabTextList[i].Color     = active and Theme.Text or Theme.TextSub
        tabTextList[i].Visible   = state.visible

        tabAccentList[i].Position    = Vector2.new(mw + 2 * s, tabY + 6 * s)
        tabAccentList[i].Size        = Vector2.new(3 * s, TAB_H - 12 * s)
        tabAccentList[i].Transparency= active and 1 or 0
        tabAccentList[i].Color       = Theme.Accent
        tabAccentList[i].Visible     = state.visible
    end

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

local function newWidget(kind, props)
    local s = state.scale

    if kind == "Button" then
        local bg     = cdraw(make("Square", {Filled=true, Color=Theme.BgWidget,  Transparency=1, ZIndex=15}))
        local border = cdraw(make("Square", {Filled=false, Color=Theme.Border,   Thickness=1, Transparency=1, ZIndex=16}))
        local bar    = cdraw(make("Square", {Filled=true, Color=Theme.AccentDim, Transparency=1, ZIndex=16}))
        local lbl    = cdraw(make("Text",   {Text=props.text or "Button", Color=Theme.Text, Size=17*s, Font=Font, ZIndex=17}))
        return {
            type="Button", bg=bg, border=border, bar=bar, label=lbl,
            text=props.text or "Button", callback=props.callback or function()end,
            hoverT=0,
            y=0, h=48*s,
            destroy=function() bg:Remove(); border:Remove(); bar:Remove(); lbl:Remove() end,
        }

    elseif kind == "Toggle" then
        local checked = props.default or false
        local bg      = cdraw(make("Square", {Filled=true, Color=Theme.BgWidget, Transparency=1, ZIndex=15}))
        local border  = cdraw(make("Square", {Filled=false, Color=Theme.Border,  Thickness=1, Transparency=1, ZIndex=16}))
        local trackBg = cdraw(make("Square", {Filled=true, Color=checked and Theme.OnDim or Theme.BgInput, Transparency=1, ZIndex=16}))
        local trackBd = cdraw(make("Square", {Filled=false, Color=checked and Theme.On or Theme.Border, Thickness=1, Transparency=1, ZIndex=17}))
        local knob    = cdraw(make("Square", {Filled=true, Color=checked and Theme.On or Theme.TextSub, Transparency=1, ZIndex=18}))
        local lbl     = cdraw(make("Text",   {Text=props.text or "Toggle", Color=Theme.Text, Size=17*s, Font=Font, ZIndex=17}))
        local w = {
            type="Toggle", bg=bg, border=border, trackBg=trackBg, trackBd=trackBd, knob=knob, label=lbl,
            text=props.text or "Toggle", value=checked, callback=props.callback or function()end,
            y=0, h=48*s,
            destroy=function() bg:Remove(); border:Remove(); trackBg:Remove(); trackBd:Remove(); knob:Remove(); lbl:Remove() end,
        }
        w.toggle = function(self)
            self.value = not self.value
            self.trackBg.Color = self.value and Theme.OnDim or Theme.BgInput
            self.trackBd.Color = self.value and Theme.On    or Theme.Border
            self.knob.Color    = self.value and Theme.On    or Theme.TextSub
            local ok, err = pcall(self.callback, self.value)
            if not ok then warn("[LapoLibraryX] Toggle callback error: " .. tostring(err)) end
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
        local lbl     = cdraw(make("Text",   {Text=props.text or "Slider", Color=Theme.Text, Size=17*s, Font=Font, ZIndex=17}))
        local valTxt  = cdraw(make("Text",   {Text=tostring(val), Color=Theme.Accent, Size=15*s, Font=Font, ZIndex=17}))
        local w = {
            type="Slider", bg=bg, border=border, track=track, fill=fill,
            thumb=thumb, thumbGl=thumbGl, label=lbl, valText=valTxt,
            text=props.text or "Slider", min=min, max=max, value=val,
            callback=props.callback or function()end,
            y=0, h=64*s,
            destroy=function() bg:Remove(); border:Remove(); track:Remove(); fill:Remove(); thumb:Remove(); thumbGl:Remove(); lbl:Remove(); valTxt:Remove() end,
        }
        w.updateValue = function(self, v)
            self.value = math.clamp(v, self.min, self.max)
            self.valText.Text = tostring(math.floor(self.value))
            local ok, err = pcall(self.callback, self.value)
            if not ok then warn("[LapoLibraryX] Slider callback error: " .. tostring(err)) end
        end
        return w

    elseif kind == "Dropdown" then
        local options    = props.options or {}
        local sel        = props.default or 1
        local searchable = props.search == true
        local bg       = cdraw(make("Square", {Filled=true,  Color=Theme.BgWidget,  Transparency=1, ZIndex=15}))
        local border   = cdraw(make("Square", {Filled=false, Color=Theme.Border,    Thickness=1, Transparency=1, ZIndex=16}))
        local dispBg   = cdraw(make("Square", {Filled=true,  Color=Theme.BgInput,   Transparency=1, ZIndex=16}))
        local dispBd   = cdraw(make("Square", {Filled=false, Color=Theme.Border,    Thickness=1, Transparency=1, ZIndex=17}))
        local lbl      = cdraw(make("Text",   {Text=props.text or "Dropdown", Color=Theme.Text, Size=17*s, Font=Font, ZIndex=17}))
        local selTxt   = cdraw(make("Text",   {Text=options[sel] or "Select", Color=Theme.TextSub, Size=16*s, Font=Font, ZIndex=18}))
        local arrow    = cdraw(make("Text",   {Text="▾", Color=Theme.Accent, Size=16*s, Font=Font, ZIndex=18}))
        local popupBg  = cdraw(make("Square", {Filled=true, Color=Theme.BgDeep,     Transparency=1, ZIndex=20}))
        local popupBd  = cdraw(make("Square", {Filled=false,Color=Theme.Border,     Thickness=1, Transparency=1, ZIndex=20}))
        local searchBg = cdraw(make("Square", {Filled=true,  Color=Theme.BgInput, Transparency=1, ZIndex=21}))
        local searchBd = cdraw(make("Square", {Filled=false, Color=Theme.Accent,  Thickness=1, Transparency=1, ZIndex=22}))
        local searchIc = cdraw(make("Text",   {Text="⌕", Color=Theme.TextSub, Size=17*s, Font=Font, ZIndex=23}))
        local searchTx = cdraw(make("Text",   {Text="Pesquisar...", Color=Theme.TextMuted, Size=16*s, Font=Font, ZIndex=23}))

        local w = {
            type="Dropdown", bg=bg, border=border, dispBg=dispBg, dispBd=dispBd,
            label=lbl, selectedText=selTxt, arrow=arrow, popupBg=popupBg, popupBd=popupBd,
            searchBg=searchBg, searchBd=searchBd, searchIc=searchIc, searchTx=searchTx,
            search=searchable, query="",
            text=props.text or "Dropdown", options=options, selected=sel,
            callback=props.callback or function()end,
            open=false, hoverIdx=sel, scroll=0,
            itemDraws={}, filtered={},
            y=0, h=52*s,
        }
        for _ = 1, DD_MAX_VIS do
            local ob = cdraw(make("Square", {Filled=true, Color=Theme.BgWidget, Transparency=1, ZIndex=21}))
            local ot = cdraw(make("Text",   {Text="", Color=Theme.Text, Size=16*s, Font=Font, ZIndex=22}))
            table.insert(w.itemDraws, {bg=ob, txt=ot})
        end
        w.applyFilter = function(self)
            self.filtered = {}
            local q = string.lower(self.query or "")
            for idx, opt in ipairs(self.options) do
                if q == "" or string.find(string.lower(tostring(opt)), q, 1, true) then
                    table.insert(self.filtered, idx)
                end
            end
            self.scroll   = 0
            self.hoverIdx = self.filtered[1] or self.selected
        end
        w:applyFilter()
        w.destroy = function()
            bg:Remove(); border:Remove(); dispBg:Remove(); dispBd:Remove()
            lbl:Remove(); selTxt:Remove(); arrow:Remove()
            popupBg:Remove(); popupBd:Remove()
            searchBg:Remove(); searchBd:Remove(); searchIc:Remove(); searchTx:Remove()
            for _, it in ipairs(w.itemDraws) do pcall(function() it.bg:Remove(); it.txt:Remove() end) end
        end
        return w

    elseif kind == "TextBox" then
        local bg      = cdraw(make("Square", {Filled=true,  Color=Theme.BgWidget, Transparency=1, ZIndex=15}))
        local border  = cdraw(make("Square", {Filled=false, Color=Theme.Border,   Thickness=1, Transparency=1, ZIndex=16}))
        local inputBg = cdraw(make("Square", {Filled=true,  Color=Theme.BgInput,  Transparency=1, ZIndex=16}))
        local inputBd = cdraw(make("Square", {Filled=false, Color=Theme.Border,   Thickness=1, Transparency=1, ZIndex=17}))
        local lbl     = cdraw(make("Text",   {Text=props.text or "TextBox", Color=Theme.Text, Size=17*s, Font=Font, ZIndex=17}))
        local valTxt  = cdraw(make("Text",   {Text=props.placeholder or "Type here...", Color=Theme.TextMuted, Size=16*s, Font=Font, ZIndex=18}))
        local cursor  = cdraw(make("Text",   {Text="|", Color=Theme.Accent, Size=18*s, Font=Font, ZIndex=19}))
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
        local lbl = cdraw(make("Text", {Text=props.text or "", Color=Theme.Text,    Size=17*s, Font=Font, ZIndex=16}))
        return {type="Label", label=lbl, text=props.text or "", y=0, h=32*s,
            updateText=function(self, newText) self.text = newText; self.label.Text = newText end,
            destroy=function() lbl:Remove() end}

    elseif kind == "Paragraph" then
        local lbl = cdraw(make("Text", {Text=props.text or "", Color=Theme.TextSub, Size=15*s, Font=Font, ZIndex=16}))
        local h = (props.text and #props.text > 60) and 60*s or 32*s
        return {type="Paragraph", label=lbl, text=props.text or "", y=0, h=h,
            destroy=function() lbl:Remove() end}

    elseif kind == "Separator" then
        local line = cdraw(make("Square", {Filled=true, Color=Theme.Separator, Transparency=1, ZIndex=15}))
        return {type="Separator", line=line, y=0, h=18*s,
            destroy=function() line:Remove() end}
    end
    return nil
end

local function recalcMaxOffset()
    if state._maxOffsetDirty == false then return state.maxOffset end
    local ss = state.scale
    local totalH = Layout.contentPad * ss
    for _, w in ipairs(widgetList) do totalH = totalH + w.h + Layout.gap * ss end
    local contentAreaH = state.frameSize.Y - 34 * ss
    state.maxOffset = math.max(0, totalH - contentAreaH + Layout.contentPad * ss)
    state._maxOffsetDirty = false
    return state.maxOffset
end

local function rebuildContent()
    for _, d in ipairs(contentDrawings) do pcall(function() d:Remove() end) end
    contentDrawings, widgetList = {}, {}
    state.contentOffset, state.maxOffset = 0, 0
    state._maxOffsetDirty = true
    if #state.tabs == 0 then return end
    local tab = state.tabs[state.currentTab]
    if not tab then return end

    local s       = state.scale
    local padding = Layout.contentPad * s
    local curY    = padding

    for _, wdesc in ipairs(tab.widgets) do
        local w = newWidget(wdesc.type, wdesc.props)
        if w then
            w.desc = wdesc
            w.y    = curY
            -- pré-computar lista de Drawing objects para hide rápido
            local all = {}
            for _, o in pairs({w.bg,w.label,w.border,w.track,w.fill,w.thumb,w.thumbGl,
                w.valText,w.trackBg,w.trackBd,w.knob,w.dispBg,w.dispBd,
                w.selectedText,w.arrow,w.popupBg,w.popupBd,w.inputBg,w.inputBd,
                w.valueText,w.cursor,w.bar,w.line,
                w.searchBg,w.searchBd,w.searchIc,w.searchTx}) do
                if o then all[#all+1] = o end
            end
            w._allDrawings = all
            table.insert(widgetList, w)
            curY = curY + w.h + Layout.gap * s
        end
    end
    recalcMaxOffset()
end

local function updateMetrics()
    local s = state.scale
    state.metrics = {
        headerH = 34*s, sideW = 160*s, footerH = 52*s,
        btnSz = 22*s, btnPad = 10*s, tabH = 38*s, tabPad = 6*s,
        itemH = 32*s, pad = 10*s,
    }
end

local function dropdownGeom(w)
    local m      = state.metrics or {}
    local s      = state.scale
    local SIDE_W = m.sideW or 160 * s
    local cX     = state.framePos.X + SIDE_W + 1
    local cY     = state.framePos.Y + (m.headerH or 34 * s)
    local cW     = state.frameSize.X - SIDE_W - 1
    local ITEM_H = m.itemH or 32 * s
    local searchH= w.search and 30 * s or 0
    local popX   = cX + 8 * s
    local popY   = cY + w.y - state.contentOffset + w.h
    local popW   = cW - 16 * s
    local visN   = math.min(#w.filtered, DD_MAX_VIS)
    local popH   = searchH + visN * ITEM_H
    return {
        s=s, cX=cX, cY=cY, cW=cW, ITEM_H=ITEM_H, searchH=searchH,
        popX=popX, popY=popY, popW=popW, visN=visN, popH=popH,
    }
end

local function renderDropdownPopup(w, ss, cY, cY2)
    local function hidePopup()
        setVis(w.popupBg, false);  setVis(w.popupBd, false)
        setVis(w.searchBg, false); setVis(w.searchBd, false)
        setVis(w.searchIc, false); setVis(w.searchTx, false)
        for _, slot in ipairs(w.itemDraws) do setVis(slot.bg, false); setVis(slot.txt, false) end
    end
    if not w.open then hidePopup(); return end
    local g = dropdownGeom(w)
    local popupVis = (g.popY + g.popH > cY) and (g.popY < cY2)
    if not popupVis then hidePopup(); return end

    renderClippedSquare(w.popupBg, g.popX, g.popY, g.popW, g.popH, cY, cY2)
    renderClippedOutline(w.popupBd, g.popX, g.popY, g.popW, g.popH, cY, cY2)

    if w.search then
        renderClippedSquare(w.searchBg, g.popX, g.popY, g.popW, g.searchH, cY, cY2)
        renderClippedOutline(w.searchBd, g.popX, g.popY, g.popW, g.searchH, cY, cY2)

        w.searchIc.Visible = isSubVisible(g.popY+(g.searchH-17*ss)/2, 17*ss, cY, cY2)
        w.searchIc.Position = Vector2.new(g.popX+7*ss,  g.popY+(g.searchH-17*ss)/2)
        w.searchIc.Size     = 17*ss

        w.searchTx.Visible = isSubVisible(g.popY+(g.searchH-16*ss)/2, 16*ss, cY, cY2)
        w.searchTx.Position = Vector2.new(g.popX+22*ss, g.popY+(g.searchH-16*ss)/2)
        w.searchTx.Size     = 16*ss
        local queryStr = w.query ~= "" and w.query or "Pesquisar..."
        local st = truncCached(w, "search", queryStr, g.popW - 30*ss, 16*ss)
        if w.searchTx.Text ~= st then w.searchTx.Text = st end
        w.searchTx.Color = w.query ~= "" and Theme.Text or Theme.TextMuted
    else
        setVis(w.searchBg, false); setVis(w.searchBd, false)
        setVis(w.searchIc, false); setVis(w.searchTx, false)
    end

    for k, slot in ipairs(w.itemDraws) do
        local optIdx = (k <= g.visN) and w.filtered[w.scroll + k] or nil
        if optIdx then
            local iy       = g.popY + g.searchH + (k-1)*g.ITEM_H
            local hovered  = (optIdx == w.hoverIdx)
            local selected = (optIdx == w.selected)

            renderClippedSquare(slot.bg, g.popX, iy, g.popW, g.ITEM_H, cY, cY2)
            slot.bg.Color = hovered and Theme.BgPanel or (selected and Theme.BgWidget or Theme.BgDeep)

            slot.txt.Visible = isSubVisible(iy+(g.ITEM_H-16*ss)/2, 16*ss, cY, cY2)
            slot.txt.Position = Vector2.new(g.popX+10*ss, iy+(g.ITEM_H-16*ss)/2)
            slot.txt.Size     = 16*ss
            local it = truncCached(w, "item"..k, tostring(w.options[optIdx]), g.popW - 20*ss, 16*ss)
            if slot.txt.Text ~= it then slot.txt.Text = it end
            slot.txt.Color    = (hovered or selected) and Theme.Text or Theme.TextSub
        else
            setVis(slot.bg, false); setVis(slot.txt, false)
        end
    end
end

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
    if state.initialized and not state.batchMode then rebuildContent() end
end

function LapoX:AddTab(name, icon)
    table.insert(state.tabs, {name=name, icon=icon or "", widgets={}})
    if state.initialized and not state.batchMode then
        buildTabs()
        updateLayout()
        rebuildContent()
    end
    return self
end

function LapoX:AddButton(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Button", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    return handle
end

function LapoX:AddToggle(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Toggle", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:Set(val)
        cfg.default = val
        for _, w in ipairs(widgetList) do
            if w.desc and w.desc.props == cfg and w.type == "Toggle" then
                if w.value ~= val then
                    w:toggle()
                end
                break
            end
        end
    end
    return handle
end

function LapoX:AddSlider(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Slider", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:Set(val)
        cfg.default = val
        for _, w in ipairs(widgetList) do
            if w.desc and w.desc.props == cfg and w.type == "Slider" then
                w:updateValue(val)
                break
            end
        end
    end
    return handle
end

function LapoX:AddDropdown(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Dropdown", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:Set(valOrOptions)
        if type(valOrOptions) == "table" then
            cfg.options = valOrOptions
            for _, w in ipairs(widgetList) do
                if w.desc and w.desc.props == cfg and w.type == "Dropdown" then
                    w.options = valOrOptions
                    w.selected = 1
                    w.query = ""
                    w.scroll = 0
                    w:applyFilter()
                    w.selectedText.Text = valOrOptions[1] or "Select"
                    break
                end
            end
        else
            cfg.default = valOrOptions
            for _, w in ipairs(widgetList) do
                if w.desc and w.desc.props == cfg and w.type == "Dropdown" then
                    local idx = table.find(w.options, valOrOptions) or 1
                    w.selected = idx
                    w.selectedText.Text = tostring(valOrOptions)
                    break
                end
            end
        end
    end
    return handle
end

function LapoX:AddTextBox(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "TextBox", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:Set(val)
        cfg.placeholder = val
        for _, w in ipairs(widgetList) do
            if w.desc and w.desc.props == cfg and w.type == "TextBox" then
                w.value = val
                w.valueText.Text = val
                w.valueText.Color = Theme.Text
                break
            end
        end
    end
    return handle
end

function LapoX:AddLabel(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Label", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:updateText(newText)
        cfg.text = newText
        for _, w in ipairs(widgetList) do
            if w.desc and w.desc.props == cfg and w.type == "Label" then
                w.text = newText
                w.label.Text = newText
                break
            end
        end
    end
    function handle:Set(newText)
        self:updateText(newText)
    end
    return handle
end

function LapoX:AddParagraph(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Paragraph", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:updateText(newText)
        cfg.text = newText
        for _, w in ipairs(widgetList) do
            if w.desc and w.desc.props == cfg and w.type == "Paragraph" then
                w.text = newText
                w.label.Text = newText
                break
            end
        end
    end
    function handle:Set(newText)
        self:updateText(newText)
    end
    return handle
end

function LapoX:AddSeparator(tabIdx)
    addWidget(tabIdx, "Separator", {})
    return self
end

function LapoX:Notify(cfg)
    if not state.hasDrawing then return self end
    cfg = cfg or {}
    local s   = state.scale
    local id  = state.notifyId + 1
    state.notifyId = id

    local WRAP_CHARS = 45
    local rawText = cfg.content or ""
    local wrappedLines = {}

    for segment in string.gmatch(rawText .. "\n", "(.-)\n") do
        if #segment <= WRAP_CHARS then
            table.insert(wrappedLines, segment)
        else
            local remaining = segment
            while #remaining > 0 do
                if #remaining <= WRAP_CHARS then
                    table.insert(wrappedLines, remaining)
                    remaining = ""
                else
                    local cutAt = WRAP_CHARS
                    local spacePos = nil
                    for ci = WRAP_CHARS, 1, -1 do
                        if string.sub(remaining, ci, ci) == " " then
                            spacePos = ci
                            break
                        end
                    end
                    if spacePos and spacePos > 10 then
                        cutAt = spacePos
                    end
                    table.insert(wrappedLines, string.sub(remaining, 1, cutAt))
                    remaining = string.sub(remaining, cutAt + 1)
                    if string.sub(remaining, 1, 1) == " " then
                        remaining = string.sub(remaining, 2)
                    end
                end
            end
        end
    end

    if #wrappedLines > 8 then
        local trimmed = {}
        for li = 1, 7 do
            table.insert(trimmed, wrappedLines[li])
        end
        table.insert(trimmed, "... +" .. (#wrappedLines - 7) .. " linhas")
        wrappedLines = trimmed
    end

    if #wrappedLines == 0 then
        table.insert(wrappedLines, "")
    end

    local LINE_H   = 18 * s
    local TITLE_H  = 28 * s
    local PAD_BOT  = 10 * s
    local BAR_H    = 3  * s
    local notifH   = TITLE_H + #wrappedLines * LINE_H + PAD_BOT + BAR_H

    local lineDrawings = {}
    for _, ln in ipairs(wrappedLines) do
        table.insert(lineDrawings, make("Text", {
            Text=ln, Color=Theme.TextSub, Size=15*s, Font=Font, ZIndex=9993
        }))
    end

    table.insert(state.notifyList, {
        id=id, title=cfg.title or "Lapo Library X",
        text=rawText, life=cfg.duration or 4,
        maxLife=cfg.duration or 4, alpha=1, slideY=0,
        notifH=notifH,
        lineDrawings=lineDrawings,
        lineH=LINE_H,
        titleH=TITLE_H,
        bg      = make("Square", {Filled=true, Color=Theme.BgDeep,     Transparency=1,   ZIndex=9990}),
        accent  = make("Square", {Filled=true, Color=Theme.Accent,     Transparency=1,   ZIndex=9991}),
        border  = make("Square", {Filled=false,Color=Theme.Border,     Thickness=1, Transparency=1, ZIndex=9992}),
        titleT  = make("Text",   {Text=cfg.title or "Lapo Library X", Color=Theme.Text,  Size=17*s, Font=Font, ZIndex=9993}),
        bar     = make("Square", {Filled=true, Color=Theme.Accent,     Transparency=1,   ZIndex=9994}),
    })
    return self
end

function LapoX:SetUser(name, rank)
    state.userName = name or state.userName
    state.userRank = rank or state.userRank
    if ui.footerName then ui.footerName.Text = state.userName end
    if ui.footerRank then ui.footerRank.Text = state.userRank end
    return self
end

function LapoX:SetUserCallback(cb)
    state.userCallback = cb
    return self
end

function LapoX:ToggleVisibility()
    state.visible = not state.visible
    state.layoutDirty = true
    if not state.visible then

        if state.sinkTextBox then pcall(function() state.sinkTextBox:ReleaseFocus() end) end
        if state.focusedTextBox then
            local w = state.focusedTextBox
            w.focused = false
            pcall(function() w.inputBd.Color = Theme.Border end)
            state.focusedTextBox = nil
        end
        if state.dropdownWidget then state.dropdownWidget.open = false end
        state.dropdownOpen   = false
        state.dropdownWidget = nil
    end
    for _, d in ipairs(drgs)          do pcall(function() d.Visible = state.visible end) end
    for _, d in ipairs(contentDrawings) do pcall(function() d.Visible = state.visible end) end
    for _, d in ipairs(tabDrawings)   do pcall(function() d.Visible = state.visible end) end
    if state.mobile and ui.mobileBtn then
        ui.mobileBtn.Visible       = true
        ui.mobileBtnBorder.Visible = true
        ui.mobileBtnTxt.Visible    = true
        ui.mobileBtnTxt.Text = state.visible and "✕" or "☰"
    end
    return self
end

function LapoX:Destroy()
    state.destroyFlag = true
    if state.sinkTextBox then pcall(function() state.sinkTextBox:ReleaseFocus() end) end
    state.focusedTextBox = nil
    state.dropdownOpen   = false
    state.dropdownWidget = nil
    pcall(function() game:GetService("ContextActionService"):UnbindAction("LapoLibraryX_MouseSink") end)
    local sgParent = getGuiParent()
    if sgParent then
        local existing = sgParent:FindFirstChild("LapoLibraryX_InputSink")
        if existing then pcall(function() existing:Destroy() end) end
    end
    for _, d in ipairs(drgs)            do pcall(function() d:Remove() end) end
    for _, d in ipairs(contentDrawings) do pcall(function() d:Remove() end) end
    for _, d in ipairs(tabDrawings)     do pcall(function() d:Remove() end) end
    for _, n in ipairs(state.notifyList) do
        pcall(function() n.bg:Remove(); n.accent:Remove(); n.border:Remove(); n.titleT:Remove(); n.bar:Remove(); if n.lineDrawings then for _, ld in ipairs(n.lineDrawings) do pcall(function() ld:Remove() end) end end end)
    end
    for _, c in ipairs(state.connections) do pcall(function() c:Disconnect() end) end
    drgs, contentDrawings, tabBgList, tabTextList, tabAccentList, tabDrawings = {},{},{},{},{},{}
    state.connections, widgetList, state.notifyList = {},{},{}
    state.initialized = false
    state.sinkTextBox = nil
    state.mainInputFrame, state.mobileInputFrame, state.dropdownInputFrame = nil, nil, nil
end

local function mouseSinkHandler(actionName, inputState, inputObject)
    if not state.visible then
        return Enum.ContextActionResult.Pass
    end

    local uis = game:GetService("UserInputService")
    local pos = uis:GetMouseLocation()
    local px, py = pos.X, pos.Y
    local s = state.scale

    local mw, mh = state.framePos.X, state.framePos.Y
    local fw, fh = state.frameSize.X, state.frameSize.Y

    local headerH = 34 * s
    local actualHeight = state.minimized and headerH or fh
    local insideUI = inRect(px, py, mw, mh, fw, actualHeight)

    local insideMobile = false
    if state.mobile and ui and ui.mobileBtn then
        local BS = 44 * s
        local BX = mw + fw + 8 * s
        local BY = mh + 4 * s
        insideMobile = inRect(px, py, BX, BY, BS, BS)
    end

    local insideNotification = false
    for _, n in ipairs(state.notifyList) do
        if n.bg and n.bg.Visible then
            local nPos = n.bg.Position
            local nSize = n.bg.Size
            if inRect(px, py, nPos.X, nPos.Y, nSize.X, nSize.Y) then
                insideNotification = true
                break
            end
        end
    end

    local insideDropdownPopup = false
    if state.dropdownOpen and state.dropdownWidget then
        local w = state.dropdownWidget
        local g = dropdownGeom(w)
        insideDropdownPopup = inRect(px, py, g.popX, g.popY, g.popW, g.popH)
    end

    if insideUI or insideMobile or insideNotification or insideDropdownPopup then
        return Enum.ContextActionResult.Sink
    end

    return Enum.ContextActionResult.Pass
end

local function setupInput()
    local uis    = game:GetService("UserInputService")
    local runSvc = game:GetService("RunService")
    local cas    = game:GetService("ContextActionService")

    local function mp() return uis:GetMouseLocation() end

    pcall(function() cas:UnbindAction("LapoLibraryX_MouseSink") end)
    pcall(function()
        cas:BindActionAtPriority(
            "LapoLibraryX_MouseSink",
            mouseSinkHandler,
            false,
            2000,
            Enum.UserInputType.MouseButton1,
            Enum.UserInputType.MouseButton2,
            Enum.UserInputType.MouseWheel,
            Enum.UserInputType.Touch
        )
    end)

    local toggleKeyCode = Enum.KeyCode.End
    pcall(function()
        if type(state.toggleKey) == "string" then
            toggleKeyCode = Enum.KeyCode[state.toggleKey] or Enum.KeyCode.End
        elseif typeof(state.toggleKey) == "EnumItem" then
            toggleKeyCode = state.toggleKey
        end
    end)

    local c1 = uis.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == toggleKeyCode and not state.keyHeldDown then
            state.keyHeldDown = true
            LapoX:ToggleVisibility()
        end
    end)
    local c2 = uis.InputEnded:Connect(function(inp)
        if inp.KeyCode == toggleKeyCode then state.keyHeldDown = false end
    end)
    table.insert(state.connections, c1)
    table.insert(state.connections, c2)

    local function activateWidget(w, px, py, s, cX, cY, cW, cH, cY2)
        w.pressT = 1
        if w.type == "Button" then
            local ok, err = pcall(w.callback)
            if not ok then warn("[LapoLibraryX] Button callback error: " .. tostring(err)) end
        elseif w.type == "Toggle" then
            w:toggle()
        elseif w.type == "Slider" then
            state.isSliding     = true
            state.slidingWidget = w
            local trackX = cX + 12*s
            local trackW = cW - 24*s
            w:updateValue(w.min + math.clamp((px-trackX)/trackW,0,1)*(w.max-w.min))
        elseif w.type == "Dropdown" then
            w.open   = true
            w.query  = ""
            w.scroll = 0
            w:applyFilter()
            w.hoverIdx = w.selected
            state.dropdownOpen   = true
            state.dropdownWidget = w
            -- Não captura o teclado ao abrir: ter busca não obriga a digitar.
            -- A busca só ativa se o usuário clicar na caixa de busca (o clique
            -- re-captura o foco no handler de InputBegan). Assim dá pra apenas
            -- selecionar um item normalmente.
            if w.search and state.sinkTextBox then
                state.sinkTextBox.Text = ""
            end
        elseif w.type == "TextBox" then
            w.focused = true
            w.inputBd.Color    = Theme.Accent
            w.valueText.Text   = w.value or ""
            w.valueText.Color  = Theme.Text
            if state.sinkTextBox then
                state.focusedTextBox = w
                state.sinkTextBox.Text = w.value
                state.sinkTextBox.Position = UDim2.new(0, px - 5, 0, py - 5)
                state.sinkTextBox.Size = UDim2.new(0, 10, 0, 10)
                task.defer(function()
                    state.sinkTextBox:CaptureFocus()
                end)
            end
        end
    end

    local c3 = uis.InputBegan:Connect(function(inp, gpe)

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

        local cX = mw + SIDE_W + 1
        local cY = mh + HEADER_H
        local cW = fw - SIDE_W - 1
        local cH = fh - HEADER_H
        local cY2 = cY + cH

        if state.mobile and ui and ui.mobileBtn then
            local BS = 44*s
            local BX = mw + fw + 8*s
            local BY = mh + 4*s
            if inRect(px,py, BX,BY, BS,BS) then
                LapoX:ToggleVisibility()
                return
            end
        end

        if not state.visible then return end

        if state.focusedTextBox then
            local w = state.focusedTextBox
            local wy = cY + w.y - state.contentOffset
            local insideTextBox = inRect(px, py, cX + 10*s, wy, cW - 20*s, w.h) and py >= cY and py <= cY2
            if not insideTextBox then
                state.focusedTextBox = nil
                w.focused = false
                w.inputBd.Color = Theme.Border
                if w.value ~= "" then
                    w.valueText.Color = Theme.Text
                else
                    w.valueText.Text = w.placeholder
                    w.valueText.Color = Theme.TextMuted
                end
                pcall(w.callback, w.value)
                if state.sinkTextBox then
                    state.sinkTextBox:ReleaseFocus()
                end
            end
        end

        if state.dropdownOpen and state.dropdownWidget then
            local w = state.dropdownWidget
            local g = dropdownGeom(w)
            local inSearch = w.search and inRect(px,py, g.popX, g.popY, g.popW, g.searchH) and py >= cY and py <= cY2
            local inItems  = inRect(px,py, g.popX, g.popY + g.searchH, g.popW, g.visN * g.ITEM_H) and py >= cY and py <= cY2
            if inSearch then
                -- Clique na caixa de busca: o próprio clique tira o foco do TextBox
                -- invisível, então re-capturamos o foco para a digitação continuar
                -- funcionando. O return consome o clique para que ele NÃO vaze para
                -- widgets que estejam atrás do popup.
                if w.search and state.sinkTextBox then
                    state.sinkTextBox.Position = UDim2.new(0, px - 5, 0, py - 5)
                    state.sinkTextBox.Size = UDim2.new(0, 10, 0, 10)
                    task.defer(function()
                        if state.dropdownOpen and state.dropdownWidget == w then
                            pcall(function() state.sinkTextBox:CaptureFocus() end)
                        end
                    end)
                end
                return
            elseif inItems then
                local slot   = math.floor((py - (g.popY + g.searchH)) / g.ITEM_H)
                if inp.UserInputType == Enum.UserInputType.Touch then
                    state.touchStartPos = Vector2.new(px, py)
                    state.scrollStartOffset = w.scroll
                    state.isScrollingDropdown = true
                    state.pressedDropdownItemIndex = slot
                    state.draggedPastThreshold = false
                    return
                else
                    local optIdx = w.filtered[w.scroll + slot + 1]
                    if optIdx then
                        w.selected = optIdx
                        w.selectedText.Text = w.options[optIdx] or "Select"
                        pcall(w.callback, w.selected, w.options[optIdx])
                    end
                    w.open = false; state.dropdownOpen = false; state.dropdownWidget = nil
                    if state.sinkTextBox then
                        state.sinkTextBox:ReleaseFocus()
                    end
                    return
                end
            else
                w.open = false; state.dropdownOpen = false; state.dropdownWidget = nil
                if state.sinkTextBox then
                    state.sinkTextBox:ReleaseFocus()
                end
                -- Sempre consome o clique que fecha o dropdown. Antes, fora da própria
                -- linha do widget, o código "vazava" para o loop de widgets e podia
                -- ativar o widget que estava atrás do popup (bug de Z-Index/focus).
                return
            end
        end

        if inRect(px,py, mw,mh, fw,HEADER_H) then
            local closeX = mw + fw - BTN_PAD - BTN_SZ
            local minX   = closeX - BTN_SZ - 6*s
            if inRect(px,py, closeX, mh+(HEADER_H-BTN_SZ)/2, BTN_SZ,BTN_SZ) then
                LapoX:Destroy(); return
            end
            if inRect(px,py, minX, mh+(HEADER_H-BTN_SZ)/2, BTN_SZ,BTN_SZ) then
                state.minimized = not state.minimized
                state.layoutDirty = true
                return
            end
            state.isDragging = true
            state.dragOffset = Vector2.new(px - mw, py - mh)
            return
        end

        if not state.minimized and inRect(px,py, mw,mh+HEADER_H, SIDE_W,fh-HEADER_H-FOOTER_H) then
            local TAB_H   = 38*s
            local TAB_PAD = 6*s
            for i = 1, #state.tabs do
                local tabY = mh + HEADER_H + TAB_PAD + (i-1)*(TAB_H+2*s)
                if inRect(px,py, mw+2*s,tabY, SIDE_W-4*s,TAB_H) then
                    state.currentTab = i
                    state.layoutDirty = true
                    rebuildContent()
                    return
                end
            end
            return
        end

        if not state.minimized and inRect(px,py, mw,mh+fh-FOOTER_H, SIDE_W,FOOTER_H) then
            if state.userCallback then state.userCallback(state.userName, state.userRank) end
            return
        end

        if not state.minimized then
            if inRect(px,py, cX,cY, cW,cH) then
                if inp.UserInputType == Enum.UserInputType.Touch then
                    state.touchStartPos = Vector2.new(px, py)
                    state.scrollStartOffset = state.contentOffset
                    state.isScrolling = false
                    state.draggedPastThreshold = false
                    state.pressedWidget = nil
                    for _, w in ipairs(widgetList) do
                        local wy = cY + w.y - state.contentOffset
                        if py >= wy and py <= wy + w.h and py >= cY and py <= cY2 then
                            state.pressedWidget = w
                            break
                        end
                    end
                else
                    for _, w in ipairs(widgetList) do
                        local wy = cY + w.y - state.contentOffset
                        if py >= wy and py <= wy + w.h and py >= cY and py <= cY2 then
                            activateWidget(w, px, py, s, cX, cY, cW, cH, cY2)
                            return
                        end
                    end
                end
            end
        end
    end)
    table.insert(state.connections, c3)

    local c4 = uis.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        or inp.UserInputType==Enum.UserInputType.Touch then
            state.isDragging=false
            if state.slidingWidget then state.slidingWidget.isDragging=false end
            state.isSliding=false; state.slidingWidget=nil

            if inp.UserInputType == Enum.UserInputType.Touch then
                state.isScrolling = false
                if state.isScrollingDropdown then
                    state.isScrollingDropdown = false
                    if not state.draggedPastThreshold and state.pressedDropdownItemIndex then
                        local w = state.dropdownWidget
                        if w then
                            local g = dropdownGeom(w)
                            local slot = state.pressedDropdownItemIndex
                            local optIdx = w.filtered[w.scroll + slot + 1]
                            if optIdx then
                                w.selected = optIdx
                                w.selectedText.Text = w.options[optIdx] or "Select"
                                pcall(w.callback, w.selected, w.options[optIdx])
                            end
                            w.open = false; state.dropdownOpen = false; state.dropdownWidget = nil
                            if state.sinkTextBox then
                                state.sinkTextBox:ReleaseFocus()
                            end
                        end
                    end
                elseif state.pressedWidget then
                    local pos = mp()
                    local px, py = pos.X, pos.Y
                    local s     = state.scale
                    local mw,mh = state.framePos.X, state.framePos.Y
                    local fw,fh = state.frameSize.X, state.frameSize.Y
                    local HEADER_H = 34*s
                    local SIDE_W   = 160*s

                    local cX = mw + SIDE_W + 1
                    local cY = mh + HEADER_H
                    local cW = fw - SIDE_W - 1
                    local cH = fh - HEADER_H
                    local cY2 = cY + cH

                    local w = state.pressedWidget
                    local wy = cY + w.y - state.contentOffset
                    if py >= wy and py <= wy + w.h and py >= cY and py <= cY2 and inRect(px, py, cX, cY, cW, cH) then
                        activateWidget(w, px, py, s, cX, cY, cW, cH, cY2)
                    end
                end

                state.pressedWidget = nil
                state.pressedDropdownItemIndex = nil
                state.touchStartPos = nil
            end
        end
    end)
    table.insert(state.connections, c4)

    local c5 = uis.InputChanged:Connect(function(inp)
        if not state.visible then return end
        local pos = mp()
        local px,py = pos.X,pos.Y
        local s = state.scale

        if inp.UserInputType == Enum.UserInputType.Touch then
            if state.touchStartPos then
                local deltaY = py - state.touchStartPos.Y
                local deltaX = px - state.touchStartPos.X

                if state.isScrollingDropdown then
                    if math.abs(deltaY) > 8 then
                        state.draggedPastThreshold = true
                        state.pressedDropdownItemIndex = nil
                    end
                    local w = state.dropdownWidget
                    if w then
                        local g = dropdownGeom(w)
                        local maxScroll = math.max(0, #w.filtered - DD_MAX_VIS)
                        local scrollDelta = math.round(deltaY / g.ITEM_H)
                        w.scroll = math.clamp(state.scrollStartOffset - scrollDelta, 0, maxScroll)
                    end
                elseif not state.isScrolling and not state.isSliding then
                    if math.abs(deltaY) > 8 or math.abs(deltaX) > 8 then
                        state.draggedPastThreshold = true
                        if math.abs(deltaY) > math.abs(deltaX) then
                            state.isScrolling = true
                            state.pressedWidget = nil
                        elseif state.pressedWidget and state.pressedWidget.type == "Slider" then
                            state.isSliding = true
                            state.slidingWidget = state.pressedWidget
                        end
                    end
                end

                if state.isScrolling then
                    recalcMaxOffset()
                    state.contentOffset = math.clamp(state.scrollStartOffset - deltaY, 0, state.maxOffset)
                end
            end
        end

        if state.isDragging then
            local cam = workspace.CurrentCamera
            local sw = cam and cam.ViewportSize.X or 1280
            local sh = cam and cam.ViewportSize.Y or 720
            local newX = math.clamp(px - state.dragOffset.X, 0, sw - state.frameSize.X)
            local newY = math.clamp(py - state.dragOffset.Y, 0, sh - (34*s))
            state.framePos = Vector2.new(newX, newY)
            state.layoutDirty = true
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

        if state.dropdownOpen and state.dropdownWidget then
            local dw = state.dropdownWidget
            local g  = dropdownGeom(dw)
            if inRect(px,py, g.popX, g.popY+g.searchH, g.popW, g.visN*g.ITEM_H) then
                local slot   = math.floor((py-(g.popY+g.searchH))/g.ITEM_H)
                local optIdx = dw.filtered[dw.scroll + slot + 1]
                if optIdx then dw.hoverIdx = optIdx end
            end
        end
    end)
    table.insert(state.connections, c5)

    local c6 = uis.InputChanged:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        if not state.visible or state.minimized then return end
        local pos = mp()

        local delta = inp.Position.Z > 0 and 1 or (inp.Position.Z < 0 and -1 or 0)

        if state.dropdownOpen and state.dropdownWidget then
            local w = state.dropdownWidget
            local g = dropdownGeom(w)
            if inRect(pos.X,pos.Y, g.popX, g.popY, g.popW, g.popH) then
                local maxScroll = math.max(0, #w.filtered - DD_MAX_VIS)
                w.scroll = math.clamp(w.scroll - delta, 0, maxScroll)
                return
            end
        end

        local s      = state.scale
        local SIDE_W = 160*s
        local cX     = state.framePos.X + SIDE_W + 1
        local cY     = state.framePos.Y + 34*s
        local cW     = state.frameSize.X - SIDE_W - 1
        local cH     = state.frameSize.Y - 34*s
        if inRect(pos.X,pos.Y, cX,cY, cW,cH) then
            recalcMaxOffset()
            state.contentOffset = math.clamp(state.contentOffset - delta*32, 0, state.maxOffset)
        end
    end)
    table.insert(state.connections, c6)

    -- Fallback: só registra handler de teclado se sinkTextBox falhou ao ser criado
    if not state.sinkTextBox then
    local function keyToChar(inp)
        local kc = inp.KeyCode
        local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift)
        if kc >= Enum.KeyCode.A and kc <= Enum.KeyCode.Z then
            local ch = string.char(kc.Value)
            if shift then ch = string.upper(ch) end
            return ch
        elseif kc >= Enum.KeyCode.Zero and kc <= Enum.KeyCode.Nine then
            return tostring(kc.Value - Enum.KeyCode.Zero.Value)
        elseif kc == Enum.KeyCode.Space then
            return " "
        end
        return ""
    end

    local c7 = uis.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end

        if state.dropdownOpen and state.dropdownWidget and state.dropdownWidget.search then
            local w = state.dropdownWidget
            if inp.KeyCode == Enum.KeyCode.Backspace then
                w.query = string.sub(w.query or "", 1, -2)
                w:applyFilter()
                return
            elseif inp.KeyCode == Enum.KeyCode.Return then
                local optIdx = w.filtered[1]
                if optIdx then
                    w.selected = optIdx
                    w.selectedText.Text = w.options[optIdx] or "Select"
                    pcall(w.callback, w.selected, w.options[optIdx])
                end
                w.open=false; state.dropdownOpen=false; state.dropdownWidget=nil
                return
            elseif inp.KeyCode == Enum.KeyCode.Escape then
                w.open=false; state.dropdownOpen=false; state.dropdownWidget=nil
                return
            else
                local char = keyToChar(inp)
                if #char > 0 then
                    w.query = (w.query or "") .. char
                    w:applyFilter()
                end
                return
            end
        end

        for _, w in ipairs(widgetList) do
            if w.type=="TextBox" and w.focused then
                if inp.KeyCode == Enum.KeyCode.Backspace then
                    w.value = string.sub(w.value or "", 1, -2)
                    w.valueText.Text = w.value == "" and "" or w.value
                    return
                end
                if inp.KeyCode == Enum.KeyCode.Return then
                    w.focused=false; w.inputBd.Color=Theme.Border
                    pcall(w.callback, w.value)
                    if w.value=="" then w.valueText.Text=w.placeholder; w.valueText.Color=Theme.TextMuted
                    else w.valueText.Color=Theme.Text end
                    return
                end
                local char = keyToChar(inp)
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
    end -- fim do if not state.sinkTextBox
end

local function startRenderLoop()
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
        if state.destroyFlag then conn:Disconnect(); return end

        local ss = state.scale
        if state.visible then
            local headerH = 34 * ss
            local actualHeight = state.minimized and headerH or state.frameSize.Y
            if state.mainInputFrame then
                state.mainInputFrame.Position = UDim2.new(0, state.framePos.X, 0, state.framePos.Y)
                state.mainInputFrame.Size = UDim2.new(0, state.frameSize.X, 0, actualHeight)
                state.mainInputFrame.Visible = true
            end
        else
            if state.mainInputFrame then
                state.mainInputFrame.Visible = false
            end
        end

        if state.mobile and ui and ui.mobileBtn and ui.mobileBtn.Visible then
            local BS = 44 * ss
            local BX = state.framePos.X + state.frameSize.X + 8 * ss
            local BY = state.framePos.Y + 4 * ss
            if state.mobileInputFrame then
                state.mobileInputFrame.Position = UDim2.new(0, BX, 0, BY)
                state.mobileInputFrame.Size = UDim2.new(0, BS, 0, BS)
                state.mobileInputFrame.Visible = true
            end
        else
            if state.mobileInputFrame then
                state.mobileInputFrame.Visible = false
            end
        end

        if state.dropdownOpen and state.dropdownWidget and state.visible and not state.minimized then
            local w = state.dropdownWidget
            local g = dropdownGeom(w)
            if state.dropdownInputFrame then
                state.dropdownInputFrame.Position = UDim2.new(0, g.popX, 0, g.popY)
                state.dropdownInputFrame.Size = UDim2.new(0, g.popW, 0, g.popH)
                state.dropdownInputFrame.Visible = true
            end
        else
            if state.dropdownInputFrame then
                state.dropdownInputFrame.Visible = false
            end
        end

        local toRm = {}
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize
        local screenW = vp and vp.X or 1280
        local screenH = vp and vp.Y or 720
        local NW = 380 * state.scale
        local s  = state.scale
        local NX = screenW - NW - 16 * s

        local stackOffsets = {}
        local totalStack = 0
        for i = #state.notifyList, 1, -1 do
            stackOffsets[i] = totalStack
            totalStack = totalStack + (state.notifyList[i].notifH or 80*s) + 6*s
        end

        for i, n in ipairs(state.notifyList) do
            local NH = n.notifH or 80*s
            n.life = n.life - dt
            if n.life > n.maxLife - 0.25 then
                local t = 1 - (n.life - (n.maxLife-0.25)) / 0.25
                n.slideY = lerp(-NH, 0, t)
            elseif n.life <= 0 then
                n.alpha = math.max(0, n.alpha - dt*4)
            end

            local ny = screenH - NH - 16*s - (stackOffsets[i] or 0) + n.slideY
            local al = n.alpha

            n.bg.Position     = Vector2.new(NX, ny)
            n.bg.Size         = Vector2.new(NW, NH)
            n.bg.Transparency = al
            n.bg.Visible      = al > 0

            n.accent.Position     = Vector2.new(NX, ny)
            n.accent.Size         = Vector2.new(3*s, NH)
            n.accent.Transparency = al
            n.accent.Visible      = al > 0

            n.border.Position     = Vector2.new(NX, ny)
            n.border.Size         = Vector2.new(NW, NH)
            n.border.Transparency = al * 0.6
            n.border.Visible      = al > 0

            n.titleT.Position     = Vector2.new(NX + 12*s, ny + 8*s)
            n.titleT.Transparency = al
            n.titleT.Visible      = al > 0

            if n.lineDrawings then
                local lineH  = n.lineH or 18*s
                local titleH = n.titleH or 28*s
                for li, ld in ipairs(n.lineDrawings) do
                    ld.Position     = Vector2.new(NX + 12*s, ny + titleH + (li-1)*lineH)
                    ld.Transparency = al
                    ld.Visible      = al > 0
                end
            end

            local prog = math.max(0, n.life / n.maxLife)
            n.bar.Position     = Vector2.new(NX + 3*s, ny + NH - 3*s)
            n.bar.Size         = Vector2.new((NW-3*s) * prog, 3*s)
            n.bar.Transparency = al
            n.bar.Visible      = al > 0

            if n.alpha <= 0 then table.insert(toRm, i) end
        end
        for i = #toRm, 1, -1 do
            local n = table.remove(state.notifyList, toRm[i])
            pcall(function()
                n.bg:Remove(); n.accent:Remove(); n.border:Remove()
                n.titleT:Remove(); n.bar:Remove()
                if n.lineDrawings then
                    for _, ld in ipairs(n.lineDrawings) do
                        pcall(function() ld:Remove() end)
                    end
                end
            end)
        end

        if not state.visible then return end

        local mouseLoc = UIS_SVC and UIS_SVC:GetMouseLocation() or Vector2.new(-1, -1)

        local ss    = state.scale
        local pos   = state.framePos
        local sz    = state.frameSize
        local mw,mh = pos.X, pos.Y
        local fw,fh = sz.X, sz.Y
        local HEADER_H = 34*ss
        local SIDE_W   = 160*ss
        local FOOTER_H = 52*ss

        if state.minimized then fh = HEADER_H end

        if state.layoutDirty or state.layoutDirty == nil then
        state.layoutDirty = false

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

        ui.titleText.Position   = Vector2.new(mw+14*ss, mh+(HEADER_H-19*ss)/2 - 5*ss)
        ui.titleText.Size       = 18*ss
        ui.subtitleText.Position= Vector2.new(mw+14*ss, mh+(HEADER_H-19*ss)/2 + 9*ss)
        ui.subtitleText.Size    = 13*ss

        local btnSz  = 22*ss
        local btnPad = 10*ss
        local btnY   = mh + (HEADER_H-btnSz)/2
        local closeX = mw + fw - btnPad - btnSz
        local minX   = closeX - btnSz - 6*ss

        ui.closeBtn.Position = Vector2.new(closeX, btnY)
        ui.closeBtn.Size     = Vector2.new(btnSz, btnSz)
        ui.closeTxt.Position = Vector2.new(closeX + 5*ss, btnY + 3*ss)
        ui.closeTxt.Size     = 16*ss

        ui.minBtn.Position   = Vector2.new(minX,   btnY)
        ui.minBtn.Size       = Vector2.new(btnSz,  btnSz)
        ui.minTxt.Position   = Vector2.new(minX + 4*ss, btnY + 2*ss)
        ui.minTxt.Size       = 16*ss

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

            local TAB_H   = 38*ss
            local TAB_PAD = 6*ss
            for i, bg in ipairs(tabBgList) do
                local tabY  = mh+HEADER_H+TAB_PAD+(i-1)*(TAB_H+2*ss)
                bg.Position = Vector2.new(mw+2*ss, tabY)
                bg.Size     = Vector2.new(SIDE_W-4*ss, TAB_H)
                bg.Transparency = 0          -- destaque agora é o indicador deslizante
                bg.Visible  = true
                tabTextList[i].Position = Vector2.new(mw+22*ss, tabY+(TAB_H-16*ss)/2)
                tabTextList[i].Color    = Theme.TextSub
                tabTextList[i].Visible  = true
                tabAccentList[i].Transparency = 0   -- idem (substituído pelo indicador)
                tabAccentList[i].Visible      = false
            end
            if ui.tabHighlight then ui.tabHighlight.Visible = true end
            if ui.tabIndicator then ui.tabIndicator.Visible = true end
        end -- fim if showBody (layout estático)
        end -- fim layoutDirty

        local showBody = not state.minimized
        if showBody then
            -- indicador de aba deslizante + cor de texto animada (hover/ativo)
            do
                local TAB_H   = 38*ss
                local TAB_PAD = 6*ss
                local nTabs   = #tabBgList
                if nTabs > 0 then
                    local activeY = mh+HEADER_H+TAB_PAD+(state.currentTab-1)*(TAB_H+2*ss)
                    if state.tabIndY == nil then state.tabIndY = activeY end
                    state.tabIndY = damp(state.tabIndY, activeY, 16, dt)

                    if ui.tabHighlight then
                        ui.tabHighlight.Position = Vector2.new(mw+2*ss, state.tabIndY)
                        ui.tabHighlight.Size     = Vector2.new(SIDE_W-4*ss, TAB_H)
                        ui.tabHighlight.Visible  = true
                    end
                    if ui.tabIndicator then
                        ui.tabIndicator.Position = Vector2.new(mw+2*ss, state.tabIndY+6*ss)
                        ui.tabIndicator.Size     = Vector2.new(3*ss, TAB_H-12*ss)
                        ui.tabIndicator.Visible  = true
                    end

                    state.tabTextAnim = state.tabTextAnim or {}
                    local anim = state.tabTextAnim
                    for i = 1, nTabs do
                        local tabY   = mh+HEADER_H+TAB_PAD+(i-1)*(TAB_H+2*ss)
                        local over   = mouseLoc.X>=mw+2*ss and mouseLoc.X<=mw+SIDE_W-2*ss
                            and mouseLoc.Y>=tabY and mouseLoc.Y<=tabY+TAB_H
                        local active = i == state.currentTab
                        anim[i] = damp(anim[i] or 0, (active or over) and 1 or 0, 14, dt)
                        if tabTextList[i] then
                            tabTextList[i].Color = lerpColor(Theme.TextSub, Theme.Text, anim[i])
                        end
                    end
                elseif ui.tabHighlight then
                    ui.tabHighlight.Visible = false
                    if ui.tabIndicator then ui.tabIndicator.Visible = false end
                end
            end

            local cX = mw + SIDE_W + 1
            local cY = mh + HEADER_H
            local cW = fw - SIDE_W - 1
            local cH = fh - HEADER_H
            local cY2 = cY + cH
            local PAD = Layout.contentPad*ss
            local wWidth = cW - PAD*2

            -- micro-interações: hover/press suaves via damp (etapa 1).
            -- pressT é setado para 1 no clique (activateWidget) e decai aqui.
            local function interact(w, wy, wh)
                local over = mouseLoc.X >= cX+PAD and mouseLoc.X <= cX+PAD+wWidth
                    and mouseLoc.Y >= math.max(wy, cY) and mouseLoc.Y <= math.min(wy+wh, cY2)
                w.hoverT = damp(w.hoverT or 0, over and 1 or 0, 12, dt)
                w.pressT = damp(w.pressT or 0, 0, 16, dt)
                return w.hoverT, w.pressT
            end

            for _, w in ipairs(widgetList) do

                local wy  = cY + w.y - state.contentOffset
                local wh  = w.h

                local vis = (wy + wh > cY) and (wy < cY2)

                if not vis then
                    hide(w.bg, w.label, w.border)
                    if w.type=="Button"    then hide(w.bar) end
                    if w.type=="Toggle"    then hide(w.trackBg,w.trackBd,w.knob) end
                    if w.type=="Slider"    then hide(w.track,w.fill,w.thumb,w.thumbGl,w.valText) end
                    if w.type=="Dropdown"  then hide(w.dispBg,w.dispBd,w.selectedText,w.arrow) renderDropdownPopup(w, ss, cY, cY2) end
                    if w.type=="TextBox"   then hide(w.inputBg,w.inputBd,w.valueText,w.cursor) end
                    if w.type=="Separator" then hide(w.line) end
                else
                    local wW = cW - PAD*2

                    if w.type == "Separator" then
                        renderClippedSquare(w.line, cX+PAD, wy+w.h/2, wW, 1, cY, cY2)

                    elseif w.type == "Label" then
                        w.label.Visible = isSubVisible(wy+4*ss, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD, wy+4*ss)
                        local nt = truncCached(w, "label", w.text, wW - 16*ss, 17*ss)
                        if w.label.Text ~= nt then w.label.Text = nt end

                    elseif w.type == "Paragraph" then
                        w.label.Visible = isSubVisible(wy+4*ss, 15*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD, wy+4*ss)
                        local nt = truncCached(w, "label", w.text, wW - 16*ss, 15*ss)
                        if w.label.Text ~= nt then w.label.Text = nt end

                    elseif w.type == "Button" then
                        local t, p = interact(w, wy, wh)
                        local emph = math.max(t, p)

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        w.bg.Color = lerpColor(lerpColor(Theme.BgWidget, Theme.BgPanel, t), Theme.AccentDim, p*0.5)

                        renderClippedOutline(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = lerpColor(Theme.Border, Theme.Accent, emph)

                        renderClippedSquare(w.bar, cX+PAD, wy+4*ss, (2 + 2*emph)*ss, wh-8*ss, cY, cY2)
                        w.bar.Color = lerpColor(Theme.Accent, Theme.AccentGlow, p)
                        w.bar.Transparency = emph

                        w.label.Visible = isSubVisible(wy+(wh-17*ss)/2, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+14*ss, wy+(wh-17*ss)/2)
                        w.label.Size = 17*ss
                        local nt = truncCached(w, "label", w.text, wW - 24*ss, 17*ss)
                        if w.label.Text ~= nt then w.label.Text = nt end
                        w.label.Color = lerpColor(Theme.Text, Theme.AccentGlow, emph*0.5)

                    elseif w.type == "Toggle" then
                        local t, p = interact(w, wy, wh)
                        local TRACK_W = 36*ss
                        local TRACK_H = 18*ss
                        local tX      = cX+PAD+wW-TRACK_W-8*ss
                        local tY      = wy+(wh-TRACK_H)/2
                        local knobSz  = TRACK_H - 4*ss
                        w.knobT = damp(w.knobT or (w.value and 1 or 0), w.value and 1 or 0, 16, dt)
                        local knobX   = lerp(tX+2*ss, tX+TRACK_W-knobSz-2*ss, w.knobT)

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        w.bg.Color = lerpColor(lerpColor(Theme.BgWidget, Theme.BgPanel, t), Theme.AccentDim, p*0.5)
                        renderClippedOutline(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = lerpColor(Theme.Border, Theme.Accent, math.max(t, p))

                        renderClippedSquare(w.trackBg, tX, tY, TRACK_W, TRACK_H, cY, cY2)
                        renderClippedOutline(w.trackBd, tX, tY, TRACK_W, TRACK_H, cY, cY2)

                        renderClippedSquare(w.knob, knobX, tY+2*ss, knobSz, knobSz, cY, cY2)

                        w.label.Visible = isSubVisible(wy+(wh-17*ss)/2, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+(wh-17*ss)/2)
                        w.label.Size = 17*ss
                        local nt = truncCached(w, "label", w.text, wW - TRACK_W - 24*ss, 17*ss)
                        if w.label.Text ~= nt then w.label.Text = nt end

                    elseif w.type == "Slider" then
                        local t, p = interact(w, wy, wh)
                        local trkX = cX+PAD+10*ss
                        local trkW = wW-20*ss
                        local trkH = 5*ss
                        local trkY = wy+wh-16*ss
                        local ratio= (w.value-w.min)/(w.max-w.min)

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        w.bg.Color = lerpColor(lerpColor(Theme.BgWidget, Theme.BgPanel, t), Theme.AccentDim, p*0.5)
                        renderClippedOutline(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = lerpColor(Theme.Border, Theme.Accent, math.max(t, p))

                        w.label.Visible = isSubVisible(wy+6*ss, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+6*ss)
                        w.label.Size = 17*ss
                        local nt = truncCached(w, "label", w.text, wW - 60*ss, 17*ss)
                        if w.label.Text ~= nt then w.label.Text = nt end

                        w.valText.Visible = isSubVisible(wy+6*ss, 15*ss, cY, cY2)
                        w.valText.Position = Vector2.new(cX+PAD+wW-45*ss, wy+6*ss)
                        w.valText.Size = 15*ss
                        w.valText.Text = tostring(math.floor(w.value))

                        renderClippedSquare(w.track, trkX, trkY, trkW, trkH, cY, cY2)
                        renderClippedSquare(w.fill, trkX, trkY, trkW*ratio, trkH, cY, cY2)

                        local thumbSz = (12 + 3*math.max(t, p))*ss
                        local thumbX  = trkX + trkW*ratio - thumbSz/2
                        renderClippedSquare(w.thumb, thumbX, trkY - (thumbSz-trkH)/2, thumbSz, thumbSz, cY, cY2)
                        renderClippedOutline(w.thumbGl, thumbX-1, trkY-(thumbSz-trkH)/2-1, thumbSz+2, thumbSz+2, cY, cY2)

                    elseif w.type == "Dropdown" then
                        local DISPW = 150*ss
                        local dispX = cX+PAD+wW-DISPW-8*ss
                        local dispH = wh - 16*ss

                        local t, p = interact(w, wy, wh)
                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        w.bg.Color = lerpColor(lerpColor(Theme.BgWidget, Theme.BgPanel, t), Theme.AccentDim, p*0.5)
                        renderClippedOutline(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = lerpColor(Theme.Border, Theme.Accent, math.max(t, p, w.open and 1 or 0))

                        w.label.Visible = isSubVisible(wy+(wh-17*ss)/2, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+(wh-17*ss)/2)
                        w.label.Size = 17*ss
                        local nlbl = truncCached(w, "label", w.text, wW - DISPW - 24*ss, 17*ss)
                        if w.label.Text ~= nlbl then w.label.Text = nlbl end

                        renderClippedSquare(w.dispBg, dispX, wy+8*ss, DISPW, dispH, cY, cY2)
                        renderClippedOutline(w.dispBd, dispX, wy+8*ss, DISPW, dispH, cY, cY2)

                        w.selectedText.Visible = isSubVisible(wy+(wh-16*ss)/2, 16*ss, cY, cY2)
                        w.selectedText.Position = Vector2.new(dispX+8*ss, wy+(wh-16*ss)/2)
                        w.selectedText.Size = 16*ss
                        local nsel = truncCached(w, "sel", w.options[w.selected] or "Select", DISPW-24*ss, 16*ss)
                        if w.selectedText.Text ~= nsel then w.selectedText.Text = nsel end

                        w.arrow.Visible = isSubVisible(wy+(wh-16*ss)/2, 16*ss, cY, cY2)
                        w.arrow.Position = Vector2.new(dispX+DISPW-16*ss, wy+(wh-16*ss)/2)
                        w.arrow.Size = 16*ss
                        w.arrow.Text = w.open and "▴" or "▾"

                        renderDropdownPopup(w, ss, cY, cY2)

                    elseif w.type == "TextBox" then
                        local inputY = wy+28*ss
                        local inputH = wh-34*ss

                        local t, p = interact(w, wy, wh)
                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        w.bg.Color = lerpColor(Theme.BgWidget, Theme.BgPanel, t)
                        renderClippedOutline(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = lerpColor(Theme.Border, Theme.Accent, math.max(t, w.focused and 1 or 0))

                        w.label.Visible = isSubVisible(wy+6*ss, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+6*ss)
                        w.label.Size = 17*ss
                        local nlbl = truncCached(w, "label", w.text, wW - 16*ss, 17*ss)
                        if w.label.Text ~= nlbl then w.label.Text = nlbl end

                        renderClippedSquare(w.inputBg, cX+PAD+8*ss, inputY, wW-16*ss, inputH, cY, cY2)
                        renderClippedOutline(w.inputBd, cX+PAD+8*ss, inputY, wW-16*ss, inputH, cY, cY2)

                        local txtX = cX+PAD+14*ss
                        local txtY = inputY+(inputH-16*ss)/2
                        w.valueText.Visible = isSubVisible(txtY, 16*ss, cY, cY2)
                        w.valueText.Position = Vector2.new(txtX, txtY)
                        w.valueText.Size = 16*ss
                        local valStr = (w.focused or w.value ~= "") and w.value or w.placeholder
                        local nval = truncCached(w, "val", valStr, wW - 32*ss, 16*ss)
                        if w.valueText.Text ~= nval then w.valueText.Text = nval end
                        w.valueText.Color = (w.focused or w.value ~= "") and Theme.Text or Theme.TextMuted

                        local shownLen = #w.valueText.Text
                        local inputRight = cX+PAD+8*ss + (wW-16*ss)
                        local maxCursorX = inputRight - 6*ss
                        local cursorX = math.min(txtX + shownLen * 7*ss, maxCursorX)
                        w.cursor.Visible = w.focused and (math.floor(tick()*2)%2==0)
                            and isSubVisible(txtY-1, 18*ss, cY, cY2)
                            and (cursorX <= inputRight)
                        w.cursor.Position = Vector2.new(cursorX, txtY-1)
                        w.cursor.Size = 18*ss
                    end
                end
            end
        else
            if ui.tabHighlight then ui.tabHighlight.Visible = false end
            if ui.tabIndicator then ui.tabIndicator.Visible = false end
            for _, bg in ipairs(tabBgList)     do bg.Visible = false end
            for _, tt in ipairs(tabTextList)   do tt.Visible = false end
            for _, ac in ipairs(tabAccentList) do ac.Visible = false end
            for _, w  in ipairs(widgetList) do
                if w._allDrawings then
                    for _, o in ipairs(w._allDrawings) do
                        if o then pcall(function() o.Visible=false end) end
                    end
                else
                    for _, o in pairs({w.bg,w.label,w.border,w.track,w.fill,w.thumb,w.thumbGl,
                        w.valText,w.trackBg,w.trackBd,w.knob,w.dispBg,w.dispBd,
                        w.selectedText,w.arrow,w.popupBg,w.popupBd,w.inputBg,w.inputBd,
                        w.valueText,w.cursor,w.bar,w.line,
                        w.searchBg,w.searchBd,w.searchIc,w.searchTx}) do
                        if o then pcall(function() o.Visible=false end) end
                    end
                end
                if w.itemDraws then
                    for _, it in ipairs(w.itemDraws) do
                        pcall(function() it.bg.Visible=false; it.txt.Visible=false end)
                    end
                end
            end
        end

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

-- ============================================================
--  LOADING SCREEN  (tela de carregamento)
--  Tela independente desenhada com a Drawing API. Aparece
--  antes da UI principal, permite imagem custom, mensagem,
--  barra de progresso e spinner. Inclui uma fila de tarefas
--  que distribui o carregamento ao longo de vários frames
--  para evitar travadas e erros.
-- ============================================================
local Loader = {
    objs            = {},
    conn            = nil,
    active          = false,
    progress        = 0,      -- alvo (0..1)
    shownProgress   = 0,      -- valor animado
    message         = "Carregando...",
    title           = "Lapo Library X",
    subtitle        = "",
    spin            = 0,
    pulse           = 0,
    fadingOut       = false,
    fade            = 0,      -- 0 = invisível, 1 = totalmente visível
    onDone          = nil,
    hasImage        = false,
    -- fila de tarefas
    queue           = {},
    queueIndex      = 0,
    running         = false,
    frameGap        = 2,      -- frames de espera entre tarefas (respira)
    frameCounter    = 0,
}

local LOADER_DOTS = 12

local function loaderLoadImage(obj, src)
    Loader.imageErr = nil
    if not obj then
        Loader.imageErr = "Drawing Image nao suportado neste executor"
        return false
    end
    if not src or src == "" then return false end

    -- rbxassetid:// (ou getcustomasset) -> tenta via .Uri direto
    if type(src) == "string" and (src:match("^rbxassetid://") or src:match("^rbxasset://")) then
        if pcall(function() obj.Uri = src end) then return true end
        Loader.imageErr = "executor nao aceita .Uri (rbxassetid)"
        return false
    end

    -- URL http(s): baixa os bytes crus
    if type(src) == "string" and src:match("^https?://") then
        local ok, body = pcall(function() return game:HttpGet(src, true) end)
        if not ok or type(body) ~= "string" or #body == 0 then
            Loader.imageErr = "HttpGet falhou (host bloqueou, redirect ou sem internet)"
            return false
        end
        -- veio HTML? entao a URL nao e um link DIRETO de imagem
        local head = body:sub(1, 64):lower()
        if head:find("<!doctype", 1, true) or head:find("<html", 1, true) then
            Loader.imageErr = "URL nao e link DIRETO de imagem (veio HTML). Use o link .png/.jpg cru"
            return false
        end
        -- valida assinatura real do arquivo
        local b1, b2 = body:byte(1), body:byte(2)
        local isPng = body:sub(1, 4) == "\137PNG"
        local isJpg = (b1 == 0xFF and b2 == 0xD8)
        if not (isPng or isJpg) then
            Loader.imageErr = "conteudo baixado nao parece PNG/JPG valido"
            -- mesmo assim tenta atribuir; alguns executores aceitam outros formatos
        end
        if pcall(function() obj.Data = body end) then return true end
        if pcall(function() obj.Uri = src end) then return true end
        Loader.imageErr = "executor nao suporta Drawing Image (.Data/.Uri)"
        return false
    end

    -- dados crus (string de bytes) ja fornecidos
    if pcall(function() obj.Data = src end) then return true end
    Loader.imageErr = "formato de imagem nao reconhecido"
    return false
end

-- versão à prova de falhas: nem todo executor suporta "Image"/"Circle"
local function safeMake(kind, props)
    local ok, obj = pcall(make, kind, props)
    if ok then return obj end
    return nil
end

local function loaderBuild(cfg)
    Loader.objs = {}
    local function add(obj) if obj then table.insert(Loader.objs, obj) end return obj end

    -- fundo escuro cobrindo toda a tela
    Loader.overlay = add(make("Square", {
        Filled = true, Color = Theme.BgDeep,
        Transparency = 0, ZIndex = 900, Visible = true
    }))
    -- card central
    Loader.card = add(make("Square", {
        Filled = true, Color = Theme.BgBase,
        Transparency = 0, ZIndex = 901, Visible = true
    }))
    Loader.cardBorder = add(make("Square", {
        Filled = false, Color = Theme.BorderAccent, Thickness = 1,
        Transparency = 0, ZIndex = 902, Visible = true
    }))
    Loader.topAccent = add(make("Square", {
        Filled = true, Color = Theme.Accent,
        Transparency = 0, ZIndex = 903, Visible = true
    }))

    -- imagem custom (se houver)
    Loader.image = add(safeMake("Image", {
        Transparency = 0, ZIndex = 904, Visible = false
    }))
    Loader.hasImage = false
    if cfg.Image then
        if not Loader.image then
            warn("[LapoLibraryX] Imagem do loading ignorada: este executor nao suporta Drawing.new(\"Image\"). Usando spinner.")
        else
            Loader.hasImage = loaderLoadImage(Loader.image, cfg.Image)
            Loader.image.Visible = Loader.hasImage
            if not Loader.hasImage then
                warn("[LapoLibraryX] Imagem do loading nao carregou: " .. (Loader.imageErr or "motivo desconhecido") .. ". Usando spinner.")
            end
        end
    end

    -- spinner (anel de pontos) — usado sempre, é o destaque animado
    Loader.dots = {}
    for i = 1, LOADER_DOTS do
        local d = add(safeMake("Circle", {
            Filled = true, Color = Theme.Accent, Radius = 4,
            Transparency = 0, ZIndex = 905, Visible = true,
            NumSides = 16
        }))
        if d then table.insert(Loader.dots, d) end
    end

    -- textos
    Loader.titleTxt = add(make("Text", {
        Text = cfg.Title or "Lapo Library X", Color = Theme.Text,
        Size = 26, Font = Font, Center = true,
        Transparency = 0, ZIndex = 906, Visible = true
    }))
    Loader.subTxt = add(make("Text", {
        Text = cfg.Subtitle or "", Color = Theme.Accent,
        Size = 14, Font = Font, Center = true,
        Transparency = 0, ZIndex = 906, Visible = (cfg.Subtitle and cfg.Subtitle ~= "")
    }))
    Loader.msgTxt = add(make("Text", {
        Text = Loader.message, Color = Theme.TextSub,
        Size = 15, Font = Font, Center = true,
        Transparency = 0, ZIndex = 906, Visible = true
    }))
    Loader.pctTxt = add(make("Text", {
        Text = "0%", Color = Theme.AccentGlow,
        Size = 13, Font = Font, Center = true,
        Transparency = 0, ZIndex = 906, Visible = true
    }))

    -- barra de progresso
    Loader.barBg = add(make("Square", {
        Filled = true, Color = Theme.BgInput,
        Transparency = 0, ZIndex = 905, Visible = true
    }))
    Loader.barBorder = add(make("Square", {
        Filled = false, Color = Theme.Border, Thickness = 1,
        Transparency = 0, ZIndex = 905, Visible = true
    }))
    Loader.barFill = add(make("Square", {
        Filled = true, Color = Theme.Accent,
        Transparency = 0, ZIndex = 906, Visible = true
    }))
    -- brilho pulsante na ponta da barra de progresso
    Loader.barGlow = add(make("Square", {
        Filled = true, Color = Theme.AccentGlow,
        Transparency = 0, ZIndex = 907, Visible = true
    }))
end

local function loaderSetAlpha(a)
    -- aplica fade (0..1) em todos os objetos respeitando seus máximos
    for _, o in ipairs(Loader.objs) do
        if o then
            pcall(function()
                if o == Loader.overlay then
                    o.Transparency = 0.92 * a
                else
                    o.Transparency = a
                end
            end)
        end
    end
end

local function loaderLayout()
    local cam = workspace.CurrentCamera
    local vp  = cam and cam.ViewportSize
    local sw  = vp and vp.X or 1280
    local sh  = vp and vp.Y or 720

    if Loader.overlay then
        Loader.overlay.Position = Vector2.new(0, 0)
        Loader.overlay.Size     = Vector2.new(sw, sh)
    end

    local CW = math.clamp(sw * 0.34, 320, 460)
    local CH = math.clamp(sh * 0.5, 300, 380)
    -- scale-pop de entrada/saída aplicado ao card inteiro
    local sc = Loader.cardScale or 1
    CW = CW * sc
    CH = CH * sc
    local CX = (sw - CW) / 2
    local CY = (sh - CH) / 2

    if Loader.card then
        Loader.card.Position = Vector2.new(CX, CY)
        Loader.card.Size     = Vector2.new(CW, CH)
    end
    if Loader.cardBorder then
        Loader.cardBorder.Position = Vector2.new(CX, CY)
        Loader.cardBorder.Size     = Vector2.new(CW, CH)
    end
    if Loader.topAccent then
        -- barra de accent expandindo a partir do centro
        local aw = CW * (Loader.accentT or 1)
        Loader.topAccent.Position = Vector2.new(CX + (CW - aw) / 2, CY)
        Loader.topAccent.Size     = Vector2.new(aw, 3)
    end

    local cx = CX + CW / 2

    -- imagem / spinner no topo do card
    local imgSize = math.clamp(CH * 0.28, 72, 110)
    local imgY    = CY + CH * 0.12
    local centerY = imgY + imgSize / 2
    if Loader.hasImage and Loader.image then
        Loader.image.Position = Vector2.new(cx - imgSize / 2, imgY)
        Loader.image.Size     = Vector2.new(imgSize, imgSize)
    end

    -- spinner: comet circular suave (cabeça forte, cauda some) que gira
    local fade  = Loader.fade or 1
    local ringR = imgSize / 2 + (Loader.hasImage and 16 or 0)
    if not Loader.hasImage then ringR = imgSize * 0.42 end
    local nDots = #Loader.dots
    for i, d in ipairs(Loader.dots) do
        if d then
            local frac   = (i - 1) / nDots                 -- 0 = cabeça do comet
            local ang    = Loader.spin + frac * math.pi * 2
            d.Position   = Vector2.new(cx + math.cos(ang) * ringR, centerY + math.sin(ang) * ringR)
            local bright = 1 - frac                          -- cabeça forte, cauda fraca
            d.Radius     = 2.5 + bright * 3.5
            d.Color      = lerpColor(Theme.AccentDim, Theme.AccentGlow, bright)
            -- cauda some mais rápido (bright^2) e respeita o fade global de entrada/saída
            d.Transparency = (bright * bright) * fade
        end
    end

    -- textos (com leve slide-in vertical na entrada)
    local introE = Ease.outCubic(math.clamp((Loader.introElapsed or 1) / 0.5, 0, 1))
    local slide  = (1 - introE) * 10
    local textY = centerY + ringR + 22
    if Loader.titleTxt then
        Loader.titleTxt.Position = Vector2.new(cx, textY - slide)
    end
    if Loader.subTxt and Loader.subTxt.Visible then
        Loader.subTxt.Position = Vector2.new(cx, textY + 30 - slide)
    end

    -- barra de progresso perto da base
    local barW = CW - 56
    local barH = 8
    local barX = CX + 28
    local barY = CY + CH - 58
    if Loader.barBg then
        Loader.barBg.Position = Vector2.new(barX, barY)
        Loader.barBg.Size     = Vector2.new(barW, barH)
    end
    if Loader.barBorder then
        Loader.barBorder.Position = Vector2.new(barX, barY)
        Loader.barBorder.Size     = Vector2.new(barW, barH)
    end
    if Loader.barFill then
        Loader.barFill.Position = Vector2.new(barX, barY)
        Loader.barFill.Size     = Vector2.new(math.max(0, barW * Loader.shownProgress), barH)
    end
    if Loader.barGlow then
        local fw    = math.max(0, barW * Loader.shownProgress)
        local gw    = 12
        local pulse = 0.5 + 0.5 * math.abs(math.sin(Loader.pulse or 0))
        Loader.barGlow.Position     = Vector2.new(barX + math.max(0, fw - gw), barY - 1)
        Loader.barGlow.Size         = Vector2.new(gw, barH + 2)
        Loader.barGlow.Transparency = (Loader.shownProgress > 0.02) and (pulse * (Loader.fade or 1)) or 0
    end

    -- mensagem acima da barra, porcentagem abaixo
    if Loader.msgTxt then
        Loader.msgTxt.Position = Vector2.new(cx, barY - 26)
    end
    if Loader.pctTxt then
        Loader.pctTxt.Position = Vector2.new(cx, barY + 14)
    end
end

local function loaderStop()
    if Loader.conn then pcall(function() Loader.conn:Disconnect() end) Loader.conn = nil end
    for _, o in ipairs(Loader.objs) do
        pcall(function() o:Remove() end)
    end
    Loader.objs = {}
    Loader.dots = {}
    Loader.active = false
    Loader.running = false
    local cb = Loader.onDone
    Loader.onDone = nil
    if cb then pcall(cb) end
end

-- inicia o fade out, garantindo que a UI principal seja construída
-- uma única vez (sai do batch mode) antes da tela de load sumir
local function loaderBeginFade()
    if state.batchMode then
        state.batchMode = false
        if state.initialized then
            pcall(buildTabs)
            pcall(updateLayout)
            pcall(rebuildContent)
        end
    end
    Loader.fadingOut = true
end

local function loaderStartLoop()
    if Loader.conn then return end
    local runSvc = game:GetService("RunService")
    Loader.conn = runSvc.RenderStepped:Connect(function(dt)
        if not Loader.active then return end
        dt = math.clamp(dt or (1/60), 0, 0.1)

        -- animações contínuas
        Loader.spin  = Loader.spin + dt * 3.2
        Loader.pulse = Loader.pulse + dt * 4

        local INTRO_DUR = 0.5
        local OUTRO_DUR = 0.4

        if Loader.fadingOut then
            -- saída: fade-out + leve scale-down (easeInOutCubic)
            Loader.outroElapsed = (Loader.outroElapsed or 0) + dt
            local t = math.clamp(Loader.outroElapsed / OUTRO_DUR, 0, 1)
            local e = Ease.inOutCubic(t)
            Loader.fade      = 1 - e
            Loader.cardScale = 1 - 0.06 * e
            Loader.accentT   = 1
            loaderSetAlpha(Loader.fade)
            if t >= 1 then
                loaderStop()
                return
            end
        else
            -- entrada: fade-in (outCubic) + scale-pop (outBack) + accent expandindo
            if (Loader.introElapsed or 0) < INTRO_DUR then
                Loader.introElapsed = (Loader.introElapsed or 0) + dt
                local t = math.clamp(Loader.introElapsed / INTRO_DUR, 0, 1)
                Loader.fade      = Ease.outCubic(t)
                Loader.cardScale = 0.9 + 0.1 * Ease.outBack(t)
                Loader.accentT   = Ease.outCubic(math.clamp(t * 1.3, 0, 1))
                loaderSetAlpha(Loader.fade)
            else
                Loader.fade      = 1
                Loader.cardScale = 1
                Loader.accentT   = 1
            end
        end

        -- progresso animado em direção ao alvo
        Loader.shownProgress = lerp(Loader.shownProgress, Loader.progress, math.clamp(dt * 8, 0, 1))
        if Loader.shownProgress > Loader.progress - 0.002 and Loader.shownProgress < Loader.progress + 0.002 then
            Loader.shownProgress = Loader.progress
        end

        -- executa a fila de tarefas (uma por vez, com respiro entre elas)
        if Loader.running and not Loader.fadingOut then
            Loader.frameCounter = Loader.frameCounter + 1
            if Loader.frameCounter >= Loader.frameGap then
                Loader.frameCounter = 0
                Loader.queueIndex = Loader.queueIndex + 1
                local step = Loader.queue[Loader.queueIndex]
                if step then
                    if step.label and Loader.msgTxt then
                        Loader.message = step.label
                        Loader.msgTxt.Text = step.label
                    end
                    if step.fn then pcall(step.fn) end
                    Loader.progress = Loader.queueIndex / #Loader.queue
                else
                    -- fila concluída
                    Loader.running = false
                    Loader.progress = 1
                    Loader.message = "Pronto!"
                    if Loader.msgTxt then Loader.msgTxt.Text = "Pronto!" end
                    -- espera o progresso visual chegar perto de 100% e some
                    task.spawn(function()
                        local t0 = tick()
                        while Loader.shownProgress < 0.99 and tick() - t0 < 1.5 do
                            task.wait()
                        end
                        loaderBeginFade()
                    end)
                end
            end
        end

        if Loader.pctTxt then
            Loader.pctTxt.Text = math.floor(Loader.shownProgress * 100 + 0.5) .. "%"
        end

        loaderLayout()
    end)
end

-- ativa modo batch manualmente: adições de tabs/widgets não reconstroem
-- a UI a cada chamada (muito mais rápido para muitos widgets)
function LapoX:BeginBatch()
    state.batchMode = true
    return self
end

-- encerra o modo batch e reconstrói a UI uma única vez
function LapoX:EndBatch()
    if not state.batchMode then return self end
    state.batchMode = false
    if state.initialized then
        pcall(buildTabs)
        pcall(updateLayout)
        pcall(rebuildContent)
    end
    return self
end

function LapoX:ShowLoading(config)
    config = config or {}
    if not state.hasDrawing then
        warn("[LapoLibraryX] Drawing API indisponível — tela de load ignorada.")
        return self
    end
    -- evita duplicar
    if Loader.active then loaderStop() end

    Loader.message       = config.Message or "Carregando módulos..."
    Loader.title         = config.Title or state.title or "Lapo Library X"
    Loader.subtitle      = config.Subtitle or ""
    Loader.progress      = 0
    Loader.shownProgress = 0
    Loader.spin          = 0
    Loader.pulse         = 0
    Loader.fade          = 0
    Loader.fadingOut     = false
    Loader.introElapsed  = 0
    Loader.outroElapsed  = 0
    Loader.cardScale     = 0.9
    Loader.accentT       = 0
    Loader.running       = false
    Loader.queue         = {}
    Loader.queueIndex    = 0
    Loader.frameCounter  = 0
    Loader.onDone        = nil
    Loader.frameGap      = config.FrameGap or 2

    -- suprime rebuilds da UI enquanto carrega (evita reconstruir a cada widget)
    state.batchMode = true

    loaderBuild(config)
    Loader.message = config.Message or "Carregando módulos..."
    if Loader.msgTxt then Loader.msgTxt.Text = Loader.message end
    loaderSetAlpha(0)
    Loader.active = true
    loaderLayout()
    loaderStartLoop()
    return self
end

-- atualiza manualmente o progresso (0..1) e opcionalmente a mensagem
function LapoX:SetLoadingProgress(pct, msg)
    if not Loader.active then return self end
    Loader.progress = math.clamp(tonumber(pct) or 0, 0, 1)
    if msg and Loader.msgTxt then
        Loader.message = tostring(msg)
        Loader.msgTxt.Text = Loader.message
    end
    return self
end

function LapoX:SetLoadingMessage(msg)
    if not Loader.active then return self end
    if msg and Loader.msgTxt then
        Loader.message = tostring(msg)
        Loader.msgTxt.Text = Loader.message
    end
    return self
end

-- adiciona uma tarefa à fila de carregamento
-- label: texto mostrado;  fn: função executada nesse passo
function LapoX:QueueLoad(label, fn)
    table.insert(Loader.queue, { label = label, fn = fn })
    return self
end

-- roda a fila: uma tarefa por vez, espalhada em frames (sem pressa)
-- onComplete é chamado depois do fade out
function LapoX:RunLoadQueue(onComplete)
    if not Loader.active then
        if onComplete then pcall(onComplete) end
        return self
    end
    Loader.onDone     = onComplete
    Loader.queueIndex = 0
    Loader.running    = true
    if #Loader.queue == 0 then
        Loader.progress = 1
        loaderBeginFade()
    end
    return self
end

-- encerra a tela de load manualmente (fade out) e chama onComplete
function LapoX:FinishLoading(onComplete)
    if not Loader.active then
        if onComplete then pcall(onComplete) end
        return self
    end
    Loader.progress  = 1
    Loader.onDone    = onComplete
    Loader.running   = false
    task.spawn(function()
        local t0 = tick()
        while Loader.shownProgress < 0.99 and tick() - t0 < 1.2 do
            task.wait()
        end
        loaderBeginFade()
    end)
    return self
end

function LapoX:Init(config)
    config = config or {}
    state.title     = config.Title     or "Lapo Library X"

    local instanceKey = "LapoLibraryInstance_" .. state.title
    if shared[instanceKey] then
        pcall(function() shared[instanceKey]:Destroy() end)
    end
    shared[instanceKey] = self

    state.destroyFlag = false
    if not state.hasDrawing then
        warn("[LapoLibraryX] Drawing API indisponível neste executor — UI não será carregada.")
        return self
    end

    state.toggleKey = config.ToggleKey or "End"
    state.mobile    = detectMobile()
    state.scale     = state.mobile and 0.72 or 1
    updateMetrics()

    local s = state.scale
    if state.mobile then
        local cam = workspace.CurrentCamera
        local viewW = cam and cam.ViewportSize.X or 800
        local viewH = cam and cam.ViewportSize.Y or 450
        local targetW = math.clamp(viewW * 0.7, 450, 650)
        local targetH = math.clamp(viewH * 0.75, 260, 360)
        state.frameSize = Vector2.new(targetW, targetH)
        state.framePos  = Vector2.new((viewW - targetW)/2, (viewH - targetH)/2)
    else
        state.frameSize = Vector2.new(960*s, 600*s)
        state.framePos  = Vector2.new(120, 80)
    end

    local success, err = pcall(function()
        local sgParent = getGuiParent()
        if sgParent then
            local existing = sgParent:FindFirstChild("LapoLibraryX_InputSink")
            if existing then pcall(function() existing:Destroy() end) end

            local sg = Instance.new("ScreenGui")
            sg.Name = "LapoLibraryX_InputSink"
            sg.ResetOnSpawn = false
            sg.Enabled = true
            sg.Parent = sgParent

            local tb = Instance.new("TextBox")
            tb.Name = "Sink"
            tb.Size = UDim2.new(0, 0, 0, 0)
            tb.Position = UDim2.new(0, -1000, 0, -1000)
            tb.BackgroundTransparency = 1
            tb.Text = ""
            tb.ClearTextOnFocus = false
            tb.TextEditable = true
            tb.Active = true
            tb.Parent = sg

            state.sinkTextBox = tb

            local mainFrame = Instance.new("Frame")
            mainFrame.Name = "MainFrame"
            mainFrame.BackgroundTransparency = 1
            mainFrame.BorderSizePixel = 0
            mainFrame.Active = true
            mainFrame.Visible = false
            mainFrame.Parent = sg
            state.mainInputFrame = mainFrame

            local mobileFrame = Instance.new("Frame")
            mobileFrame.Name = "MobileFrame"
            mobileFrame.BackgroundTransparency = 1
            mobileFrame.BorderSizePixel = 0
            mobileFrame.Active = true
            mobileFrame.Visible = false
            mobileFrame.Parent = sg
            state.mobileInputFrame = mobileFrame

            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "DropdownFrame"
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Active = true
            dropdownFrame.Visible = false
            dropdownFrame.Parent = sg
            state.dropdownInputFrame = dropdownFrame
        end
    end)
    if not success then warn("[LapoLibraryX] Input sink setup failed: " .. tostring(err)) end

    if state.sinkTextBox then
        local cText = state.sinkTextBox:GetPropertyChangedSignal("Text"):Connect(function()
            if state.focusedTextBox then
                local w = state.focusedTextBox
                w.value = state.sinkTextBox.Text
                if w.focused or w.value ~= "" then
                    w.valueText.Text  = w.value
                    w.valueText.Color = Theme.Text
                else
                    w.valueText.Text  = w.placeholder
                    w.valueText.Color = Theme.TextMuted
                end
            elseif state.dropdownOpen and state.dropdownWidget and state.dropdownWidget.search then
                local w = state.dropdownWidget
                w.query = state.sinkTextBox.Text
                w:applyFilter()
            end
        end)
        table.insert(state.connections, cText)

        local cFocusLost = state.sinkTextBox.FocusLost:Connect(function(enterPressed)
            if state.focusedTextBox then
                local w = state.focusedTextBox
                w.focused = false
                w.inputBd.Color = Theme.Border
                pcall(w.callback, w.value)
                if w.value ~= "" then
                    w.valueText.Text  = w.value
                    w.valueText.Color = Theme.Text
                else
                    w.valueText.Text  = w.placeholder
                    w.valueText.Color = Theme.TextMuted
                end
                state.focusedTextBox = nil
            elseif state.dropdownOpen and state.dropdownWidget and state.dropdownWidget.search then
                local w = state.dropdownWidget
                if enterPressed then
                    -- Enter confirma o primeiro item filtrado e fecha o dropdown.
                    local optIdx = w.filtered[1]
                    if optIdx then
                        w.selected = optIdx
                        w.selectedText.Text = w.options[optIdx] or "Select"
                        pcall(w.callback, w.selected, w.options[optIdx])
                    end
                    w.open = false
                    state.dropdownOpen = false
                    state.dropdownWidget = nil
                end
                -- Em perda de foco SEM Enter (ex.: clique na caixa de busca ou num
                -- item) NÃO fechamos o dropdown aqui. O fechamento/seleção passa a
                -- ser tratado exclusivamente pelo InputBegan, evitando a corrida de
                -- eventos onde o dropdown fechava antes do clique ser processado
                -- (itens "não selecionáveis") e o clique "atravessava" para o widget
                -- de trás.
            end
        end)
        table.insert(state.connections, cFocusLost)
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
        title   = "Lapo Library X",
        content = (state.mobile and "📱 Mobile" or "🖥 Desktop") .. " — pronto",
        duration= 3
    })

    return self
end

return LapoX
