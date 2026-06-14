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
    keyHeldDown = false,
    notifyId = 0,
    userName = "LapoLapoNaldo",
    userRank = "Lapo Newba",
    userCallback = nil,
    title = "Lapo Hub X",
    toggleKey = "End",
    hoverAnims = {},
    mobileBtn = nil,
    mobileBtnHover = false,
    focusedTextBox = nil,
    sinkTextBox = nil,
    mainInputFrame = nil,
    mobileInputFrame = nil,
    dropdownInputFrame = nil,
}

-- ========== TEMA REFINADO (Synapse X vibes) ==========
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

local function isSubVisible(y, h, cY, cY2)
    return y >= cY and (y + h) <= cY2
end

local function getGuiParent()
    local p = game:GetService("Players").LocalPlayer
    if p then
        local success, pg = pcall(function() return p:FindFirstChildOfClass("PlayerGui") end)
        if success and pg then return pg end
    end
    local cl = pcall(function() return game:GetService("CoreGui") end)
    if cl then
        local success, cg = pcall(function() return game:GetService("CoreGui") end)
        if success and cg then return cg end
    end
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
local drgs           = {}
local tabBgList      = {}
local tabTextList    = {}
local tabAccentList  = {}
local contentDrawings = {}
local widgetList      = {}

local DD_MAX_VIS = 6

local function pool(obj) table.insert(drgs, obj); return obj end
local function cdraw(obj) table.insert(contentDrawings, obj); return obj end

-- ========== ESTRUTURA PRINCIPAL ==========
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
            Color = Theme.TextSub, Size = 16 * s, Font = Font,
            ZIndex = 13, Visible = state.visible
        }))
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

-- ========== WIDGETS ==========
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
            self.callback(self.value)
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
    -- FIX: recalculate maxOffset properly using actual content area height
    local contentH = state.frameSize.Y - (34 * s) -- header height
    state.maxOffset = math.max(0, curY - contentH + 10 * s)
end

-- ========== DROPDOWN GEOMETRY ==========
local function dropdownGeom(w)
    local s      = state.scale
    local SIDE_W = 160 * s
    local cX     = state.framePos.X + SIDE_W + 1
    local cY     = state.framePos.Y + 34 * s
    local cW     = state.frameSize.X - SIDE_W - 1
    local ITEM_H = 32 * s
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
    if state.initialized then
        buildTabs()
        updateLayout()
        rebuildContent()
    end
    return self
end

function LapoHub:AddButton(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Button", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    return handle
end

function LapoHub:AddToggle(tabIdx, cfg)
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

function LapoHub:AddSlider(tabIdx, cfg)
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

function LapoHub:AddDropdown(tabIdx, cfg)
    cfg = cfg or {}
    addWidget(tabIdx, "Dropdown", cfg)
    local handle = { _tabIdx = resolveTab(tabIdx) }
    function handle:Set(valOrOptions)
        if type(valOrOptions) == "table" then
            cfg.options = valOrOptions
            for _, w in ipairs(widgetList) do
                if w.desc and w.desc.props == cfg and w.type == "Dropdown" then
                    w.options = valOrOptions
                    w.filtered = valOrOptions
                    w.selected = 1
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

function LapoHub:AddTextBox(tabIdx, cfg)
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

function LapoHub:AddLabel(tabIdx, cfg)
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

function LapoHub:AddParagraph(tabIdx, cfg)
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

function LapoHub:AddSeparator(tabIdx)
    addWidget(tabIdx, "Separator", {})
    return self
end

function LapoHub:Notify(cfg)
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
        id=id, title=cfg.title or "Lapo Hub X",
        text=rawText, life=cfg.duration or 4,
        maxLife=cfg.duration or 4, alpha=1, slideY=0,
        notifH=notifH,
        lineDrawings=lineDrawings,
        lineH=LINE_H,
        titleH=TITLE_H,
        bg      = make("Square", {Filled=true, Color=Theme.BgDeep,     Transparency=1,   ZIndex=9990}),
        accent  = make("Square", {Filled=true, Color=Theme.Accent,     Transparency=1,   ZIndex=9991}),
        border  = make("Square", {Filled=false,Color=Theme.Border,     Thickness=1, Transparency=1, ZIndex=9992}),
        titleT  = make("Text",   {Text=cfg.title or "Lapo Hub X", Color=Theme.Text,  Size=17*s, Font=Font, ZIndex=9993}),
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
    pcall(function() game:GetService("ContextActionService"):UnbindAction("LapoHubX_MouseSink") end)
    local sgParent = getGuiParent()
    if sgParent then
        local existing = sgParent:FindFirstChild("LapoHubX_InputSink")
        if existing then pcall(function() existing:Destroy() end) end
    end
    for _, d in ipairs(drgs)            do pcall(function() d:Remove() end) end
    for _, d in ipairs(contentDrawings) do pcall(function() d:Remove() end) end
    for _, n in ipairs(state.notifyList) do
        pcall(function() n.bg:Remove(); n.accent:Remove(); n.border:Remove(); n.titleT:Remove(); n.bar:Remove(); if n.lineDrawings then for _, ld in ipairs(n.lineDrawings) do pcall(function() ld:Remove() end) end end end)
    end
    for _, c in ipairs(state.connections) do pcall(function() c:Disconnect() end) end
    drgs, contentDrawings, tabBgList, tabTextList, tabAccentList = {},{},{},{},{}
    state.connections, widgetList, state.notifyList = {},{},{}
    state.initialized = false
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

    -- Check if mouse is inside UI frame (accounting for minimize)
    local headerH = 34 * s
    local actualHeight = state.minimized and headerH or fh
    local insideUI = inRect(px, py, mw, mh, fw, actualHeight)

    -- Check if mouse is inside mobile button
    local insideMobile = false
    if state.mobile and ui and ui.mobileBtn then
        local BS = 44 * s
        local BX = mw + fw + 8 * s
        local BY = mh + 4 * s
        insideMobile = inRect(px, py, BX, BY, BS, BS)
    end

    -- Check if mouse is inside any active notification
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

    -- If a dropdown is open, its popup might be drawn outside the main UI bounds
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

-- ========== INPUT ==========
local function setupInput()
    local uis    = game:GetService("UserInputService")
    local runSvc = game:GetService("RunService")
    local cas    = game:GetService("ContextActionService")

    local function mp() return uis:GetMouseLocation() end

    -- Bind ContextActionService mouse/wheel/touch sink to prevent input bleeding to the game
    pcall(function()
        cas:BindActionAtPriority(
            "LapoHubX_MouseSink",
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
            LapoHub:ToggleVisibility()
        end
    end)
    local c2 = uis.InputEnded:Connect(function(inp)
        if inp.KeyCode == toggleKeyCode then state.keyHeldDown = false end
    end)
    table.insert(state.connections, c1)
    table.insert(state.connections, c2)

    local function activateWidget(w, px, py, s, cX, cY, cW, cH, cY2)
        if w.type == "Button" then
            w.callback()
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
            if w.search and state.sinkTextBox then
                state.sinkTextBox.Text = ""
                state.sinkTextBox.Position = UDim2.new(0, px - 5, 0, py - 5)
                state.sinkTextBox.Size = UDim2.new(0, 10, 0, 10)
                task.defer(function()
                    state.sinkTextBox:CaptureFocus()
                end)
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
        -- Allow mouse click / touch even if game processed (gpe is true),
        -- since overlay drawing UI is not tracked by game engine's CoreGui.
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
                LapoHub:ToggleVisibility()
                return
            end
        end

        if not state.visible then return end

        -- Handle TextBox defocus if clicked outside
        if state.focusedTextBox then
            local w = state.focusedTextBox
            local wy = cY + w.y - state.contentOffset
            local insideTextBox = inRect(px, py, cX + 10*s, wy, cW - 20*s, w.h) and py >= cY and py <= cY2
            if not insideTextBox then
                w.focused = false
                w.inputBd.Color = Theme.Border
                if w.value ~= "" then
                    w.valueText.Color = Theme.Text
                    w.callback(w.value)
                else
                    w.valueText.Text = w.placeholder
                    w.valueText.Color = Theme.TextMuted
                end
                if state.sinkTextBox then
                    state.sinkTextBox:ReleaseFocus()
                end
                state.focusedTextBox = nil
            end
        end

        if state.dropdownOpen and state.dropdownWidget then
            local w = state.dropdownWidget
            local g = dropdownGeom(w)
            local inSearch = w.search and inRect(px,py, g.popX, g.popY, g.popW, g.searchH) and py >= cY and py <= cY2
            local inItems  = inRect(px,py, g.popX, g.popY + g.searchH, g.popW, g.visN * g.ITEM_H) and py >= cY and py <= cY2
            if inSearch then
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
                        w.callback(w.selected, w.options[optIdx])
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
                local wy = g.cY + w.y - state.contentOffset
                if inRect(px,py, g.cX + 10*s, wy, g.cW - 20*s, w.h) then return end
            end
        end

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
                elseif state.pressedDropdownItemIndex then
                    local w = state.dropdownWidget
                    if w then
                        local g = dropdownGeom(w)
                        local slot = state.pressedDropdownItemIndex
                        local optIdx = w.filtered[w.scroll + slot + 1]
                        if optIdx then
                            w.selected = optIdx
                            w.selectedText.Text = w.options[optIdx] or "Select"
                            w.callback(w.selected, w.options[optIdx])
                        end
                        w.open = false; state.dropdownOpen = false; state.dropdownWidget = nil
                        if state.sinkTextBox then
                            state.sinkTextBox:ReleaseFocus()
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
                    local ss = state.scale
                    local padding = 10 * ss
                    local totalH = padding
                    for _, w in ipairs(widgetList) do
                        totalH = totalH + w.h + 5*ss
                    end
                    local contentAreaH = state.frameSize.Y - 34*ss
                    state.maxOffset = math.max(0, totalH - contentAreaH + 10*ss)
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
            local ss = state.scale
            local padding = 10 * ss
            local totalH = padding
            for _, w in ipairs(widgetList) do
                totalH = totalH + w.h + 5*ss
            end
            local contentAreaH = state.frameSize.Y - 34*ss
            state.maxOffset = math.max(0, totalH - contentAreaH + 10*ss)
            state.contentOffset = math.clamp(state.contentOffset - delta*32, 0, state.maxOffset)
        end
    end)
    table.insert(state.connections, c6)

    local function keyToChar(inp)
        local kc = inp.KeyCode
        local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift)
        if kc >= Enum.KeyCode.A and kc <= Enum.KeyCode.Z then
            local ch = string.char(string.byte("A") + (kc.Value - 8))
            if not shift then ch = string.lower(ch) end
            return ch
        elseif kc >= Enum.KeyCode.One and kc <= Enum.KeyCode.Zero then
            return tostring((kc.Value - 9) % 10)
        elseif kc == Enum.KeyCode.Space then
            return " "
        end
        return ""
    end

    local c7 = uis.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if state.sinkTextBox then return end -- Use native textbox sink instead

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
                    w.callback(w.selected, w.options[optIdx])
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
                    w.callback(w.value)
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
end

-- ========== RENDER LOOP ==========
local function startRenderLoop()
    local runSvc = game:GetService("RunService")
    local conn
    conn = runSvc.RenderStepped:Connect(function(dt)
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

        -- ---- notificações ----------------------------------------
        local toRm = {}
        local screenW = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1280
        local screenH = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 720
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

        local ss    = state.scale
        local pos   = state.framePos
        local sz    = state.frameSize
        local mw,mh = pos.X, pos.Y
        local fw,fh = sz.X, sz.Y
        local HEADER_H = 34*ss
        local SIDE_W   = 160*ss
        local FOOTER_H = 52*ss

        if state.minimized then fh = HEADER_H end

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
                tabTextList[i].Position = Vector2.new(mw+22*ss, tabY+(TAB_H-16*ss)/2)
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
            local cY2 = cY + cH
            local PAD = 10*ss

            for _, w in ipairs(widgetList) do
                -- FIX: use absolute screen position for clipping check
                local wy  = cY + w.y - state.contentOffset
                local wh  = w.h
                -- only show if widget overlaps the content area vertically
                local vis = (wy + wh > cY) and (wy < cY2)

                local function setVis(obj, v) if obj then obj.Visible = v end end
                local function hide(...)
                    for _, o in ipairs({...}) do setVis(o,false) end
                end

                if not vis then
                    hide(w.bg, w.label, w.border)
                    if w.type=="Button"    then hide(w.bar) end
                    if w.type=="Toggle"    then hide(w.trackBg,w.trackBd,w.knob) end
                    if w.type=="Slider"    then hide(w.track,w.fill,w.thumb,w.thumbGl,w.valText) end
                    if w.type=="Dropdown"  then hide(w.dispBg,w.dispBd,w.selectedText,w.arrow,w.popupBg,w.popupBd,w.searchBg,w.searchBd,w.searchIc,w.searchTx) for _,it in ipairs(w.itemDraws) do setVis(it.bg,false); setVis(it.txt,false) end end
                    if w.type=="TextBox"   then hide(w.inputBg,w.inputBd,w.valueText,w.cursor) end
                    if w.type=="Separator" then hide(w.line) end
                else
                    local wW = cW - PAD*2

                    if w.type == "Separator" then
                        renderClippedSquare(w.line, cX+PAD, wy+w.h/2, wW, 1, cY, cY2)

                    elseif w.type == "Label" then
                        w.label.Visible = isSubVisible(wy+4*ss, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD, wy+4*ss)
                        w.label.Text = truncateText(w.text, wW - 16*ss, 17*ss)

                    elseif w.type == "Paragraph" then
                        w.label.Visible = isSubVisible(wy+4*ss, 15*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD, wy+4*ss)
                        w.label.Text = truncateText(w.text, wW - 16*ss, 15*ss)

                    elseif w.type == "Button" then
                        local mpos = game:GetService("UserInputService"):GetMouseLocation()
                        local hovering = mpos.X>=cX+PAD and mpos.X<=cX+PAD+wW and mpos.Y>=wy and mpos.Y<=wy+wh
                        w.hoverT = lerp(w.hoverT or 0, hovering and 1 or 0, dt*10)
                        local t  = w.hoverT

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        w.bg.Color = lerpColor(Theme.BgWidget, Theme.BgPanel, t)

                        renderClippedSquare(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = lerpColor(Theme.Border, Theme.Accent, t)

                        renderClippedSquare(w.bar, cX+PAD, wy+4*ss, 3*ss, wh-8*ss, cY, cY2)
                        w.bar.Color = Theme.Accent
                        w.bar.Transparency = t

                        w.label.Visible = isSubVisible(wy+(wh-17*ss)/2, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+14*ss, wy+(wh-17*ss)/2)
                        w.label.Size = 17*ss
                        w.label.Text = truncateText(w.text, wW - 24*ss, 17*ss)
                        w.label.Color = lerpColor(Theme.Text, Theme.AccentGlow, t*0.5)

                    elseif w.type == "Toggle" then
                        local TRACK_W = 36*ss
                        local TRACK_H = 18*ss
                        local tX      = cX+PAD+wW-TRACK_W-8*ss
                        local tY      = wy+(wh-TRACK_H)/2
                        local knobSz  = TRACK_H - 4*ss
                        local knobX   = w.value and (tX+TRACK_W-knobSz-2*ss) or (tX+2*ss)

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        renderClippedSquare(w.border, cX+PAD, wy, wW, wh, cY, cY2)

                        renderClippedSquare(w.trackBg, tX, tY, TRACK_W, TRACK_H, cY, cY2)
                        renderClippedSquare(w.trackBd, tX, tY, TRACK_W, TRACK_H, cY, cY2)

                        renderClippedSquare(w.knob, knobX, tY+2*ss, knobSz, knobSz, cY, cY2)

                        w.label.Visible = isSubVisible(wy+(wh-17*ss)/2, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+(wh-17*ss)/2)
                        w.label.Size = 17*ss
                        w.label.Text = truncateText(w.text, wW - TRACK_W - 24*ss, 17*ss)

                    elseif w.type == "Slider" then
                        local trkX = cX+PAD+10*ss
                        local trkW = wW-20*ss
                        local trkH = 5*ss
                        local trkY = wy+wh-16*ss
                        local ratio= (w.value-w.min)/(w.max-w.min)

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        renderClippedSquare(w.border, cX+PAD, wy, wW, wh, cY, cY2)

                        w.label.Visible = isSubVisible(wy+6*ss, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+6*ss)
                        w.label.Size = 17*ss
                        w.label.Text = truncateText(w.text, wW - 60*ss, 17*ss)

                        w.valText.Visible = isSubVisible(wy+6*ss, 15*ss, cY, cY2)
                        w.valText.Position = Vector2.new(cX+PAD+wW-45*ss, wy+6*ss)
                        w.valText.Size = 15*ss
                        w.valText.Text = tostring(math.floor(w.value))

                        renderClippedSquare(w.track, trkX, trkY, trkW, trkH, cY, cY2)
                        renderClippedSquare(w.fill, trkX, trkY, trkW*ratio, trkH, cY, cY2)

                        local thumbSz = 12*ss
                        local thumbX  = trkX + trkW*ratio - thumbSz/2
                        renderClippedSquare(w.thumb, thumbX, trkY - (thumbSz-trkH)/2, thumbSz, thumbSz, cY, cY2)
                        renderClippedSquare(w.thumbGl, thumbX-1, trkY-(thumbSz-trkH)/2-1, thumbSz+2, thumbSz+2, cY, cY2)

                    elseif w.type == "Dropdown" then
                        local DISPW = 150*ss
                        local dispX = cX+PAD+wW-DISPW-8*ss
                        local dispH = wh - 16*ss

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        renderClippedSquare(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = w.open and Theme.Accent or Theme.Border

                        w.label.Visible = isSubVisible(wy+(wh-17*ss)/2, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+(wh-17*ss)/2)
                        w.label.Size = 17*ss
                        w.label.Text = truncateText(w.text, wW - DISPW - 24*ss, 17*ss)

                        renderClippedSquare(w.dispBg, dispX, wy+8*ss, DISPW, dispH, cY, cY2)
                        renderClippedSquare(w.dispBd, dispX, wy+8*ss, DISPW, dispH, cY, cY2)

                        w.selectedText.Visible = isSubVisible(wy+(wh-16*ss)/2, 16*ss, cY, cY2)
                        w.selectedText.Position = Vector2.new(dispX+8*ss, wy+(wh-16*ss)/2)
                        w.selectedText.Size = 16*ss
                        w.selectedText.Text = truncateText(w.options[w.selected] or "Select", DISPW-24*ss, 16*ss)

                        w.arrow.Visible = isSubVisible(wy+(wh-16*ss)/2, 16*ss, cY, cY2)
                        w.arrow.Position = Vector2.new(dispX+DISPW-16*ss, wy+(wh-16*ss)/2)
                        w.arrow.Size = 16*ss
                        w.arrow.Text = w.open and "▴" or "▾"

                        if w.open then
                            local g = dropdownGeom(w)
                            renderClippedSquare(w.popupBg, g.popX, g.popY, g.popW, g.popH, cY, cY2)
                            renderClippedSquare(w.popupBd, g.popX, g.popY, g.popW, g.popH, cY, cY2)

                            if w.search then
                                renderClippedSquare(w.searchBg, g.popX, g.popY, g.popW, g.searchH, cY, cY2)
                                renderClippedSquare(w.searchBd, g.popX, g.popY, g.popW, g.searchH, cY, cY2)

                                w.searchIc.Visible = isSubVisible(g.popY+(g.searchH-17*ss)/2, 17*ss, cY, cY2)
                                w.searchIc.Position = Vector2.new(g.popX+7*ss,  g.popY+(g.searchH-17*ss)/2)
                                w.searchIc.Size     = 17*ss

                                w.searchTx.Visible = isSubVisible(g.popY+(g.searchH-16*ss)/2, 16*ss, cY, cY2)
                                w.searchTx.Position = Vector2.new(g.popX+22*ss, g.popY+(g.searchH-16*ss)/2)
                                w.searchTx.Size     = 16*ss
                                local queryStr = w.query ~= "" and w.query or "Pesquisar..."
                                w.searchTx.Text = truncateText(queryStr, g.popW - 30*ss, 16*ss)
                                w.searchTx.Color = w.query ~= "" and Theme.Text or Theme.TextMuted
                            else
                                hide(w.searchBg, w.searchBd, w.searchIc, w.searchTx)
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
                                    slot.txt.Text     = truncateText(tostring(w.options[optIdx]), g.popW - 20*ss, 16*ss)
                                    slot.txt.Color    = (hovered or selected) and Theme.Text or Theme.TextSub
                                else
                                    hide(slot.bg, slot.txt)
                                end
                            end
                        else
                            hide(w.popupBg, w.popupBd, w.searchBg, w.searchBd, w.searchIc, w.searchTx)
                            for _, slot in ipairs(w.itemDraws) do
                                hide(slot.bg, slot.txt)
                            end
                        end

                    elseif w.type == "TextBox" then
                        local inputY = wy+28*ss
                        local inputH = wh-34*ss

                        renderClippedSquare(w.bg, cX+PAD, wy, wW, wh, cY, cY2)
                        renderClippedSquare(w.border, cX+PAD, wy, wW, wh, cY, cY2)
                        w.border.Color = w.focused and Theme.Accent or Theme.Border

                        w.label.Visible = isSubVisible(wy+6*ss, 17*ss, cY, cY2)
                        w.label.Position = Vector2.new(cX+PAD+10*ss, wy+6*ss)
                        w.label.Size = 17*ss
                        w.label.Text = truncateText(w.text, wW - 16*ss, 17*ss)

                        renderClippedSquare(w.inputBg, cX+PAD+8*ss, inputY, wW-16*ss, inputH, cY, cY2)
                        renderClippedSquare(w.inputBd, cX+PAD+8*ss, inputY, wW-16*ss, inputH, cY, cY2)

                        local txtX = cX+PAD+14*ss
                        local txtY = inputY+(inputH-16*ss)/2
                        w.valueText.Visible = isSubVisible(txtY, 16*ss, cY, cY2)
                        w.valueText.Position = Vector2.new(txtX, txtY)
                        w.valueText.Size = 16*ss
                        local valStr = (w.focused or w.value ~= "") and w.value or w.placeholder
                        w.valueText.Text = truncateText(valStr, wW - 32*ss, 16*ss)
                        w.valueText.Color = (w.focused or w.value ~= "") and Theme.Text or Theme.TextMuted
                        
                        local cursorText = w.focused and w.value or valStr
                        local cursorX = txtX + (#cursorText) * 7*ss
                        w.cursor.Visible = w.focused and (math.floor(tick()*2)%2==0) and isSubVisible(txtY-1, 18*ss, cY, cY2)
                        w.cursor.Position = Vector2.new(cursorX, txtY-1)
                        w.cursor.Size = 18*ss
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
                    w.valueText,w.cursor,w.bar,w.line,
                    w.searchBg,w.searchBd,w.searchIc,w.searchTx}) do
                    if o then pcall(function() o.Visible=false end) end
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

-- ========== INIT ==========
function LapoHub:Init(config)
    config = config or {}
    state.title     = config.Title     or "Lapo Hub X"
    
    local instanceKey = "LapoHubInstance_" .. state.title
    if shared[instanceKey] then
        pcall(function() shared[instanceKey]:Destroy() end)
    end
    shared[instanceKey] = self

    state.toggleKey = config.ToggleKey or "End"
    state.mobile    = detectMobile()
    state.scale     = state.mobile and 0.72 or 1

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

    -- Setup text sink TextBox before building structure and setting up input
    local success, err = pcall(function()
        local sgParent = getGuiParent()
        if sgParent then
            local existing = sgParent:FindFirstChild("LapoHubX_InputSink")
            if existing then pcall(function() existing:Destroy() end) end

            local sg = Instance.new("ScreenGui")
            sg.Name = "LapoHubX_InputSink"
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
                w.callback(w.value)
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
                    local optIdx = w.filtered[1]
                    if optIdx then
                        w.selected = optIdx
                        w.selectedText.Text = w.options[optIdx] or "Select"
                        w.callback(w.selected, w.options[optIdx])
                    end
                end
                w.open = false
                state.dropdownOpen = false
                state.dropdownWidget = nil
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
        title   = "Lapo Hub X",
        content = (state.mobile and "📱 Mobile" or "🖥 Desktop") .. " — pronto",
        duration= 3
    })

    return self
end

return LapoHub
