-- Lapo Hub X (Syn Version)
-- Synapse X Classic UI Library for Exploits
-- Syntax: LapoHub.<Method>(...)
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
    sliderDragOffsetX = 0,
    dropdownOpen = false,
    dropdownWidget = nil,
    dropdownHover = 1,
    framePos = Vector2.new(100, 80),
    frameSize = Vector2.new(900, 600),
    hasDrawing = pcall(function() return Drawing.new end),
    connections = {},
    initialized = false,
    destroyFlag = false,
    prevTime = 0,
    keyHeldDown = false,
    notifyId = 0,
    userName = "LapoLapoNaldo",
    userRank = "Lapo Newba",
    userPopupOpen = false,
    userCallback = nil
}

local Theme = {
    Background = Color3.fromRGB(26, 26, 46),
    Sidebar = Color3.fromRGB(22, 33, 62),
    Border = Color3.fromRGB(155, 89, 182),
    Accent = Color3.fromRGB(0, 255, 65),
    Text = Color3.fromRGB(224, 224, 224),
    TextSecondary = Color3.fromRGB(127, 140, 141),
    Hover = Color3.fromRGB(45, 45, 94),
    SliderTrack = Color3.fromRGB(44, 62, 80),
    NotifyBg = Color3.fromRGB(13, 13, 26),
    HeaderBg = Color3.fromRGB(18, 18, 36),
    InputBg = Color3.fromRGB(20, 20, 40),
    Danger = Color3.fromRGB(255, 50, 50),
    Surface = Color3.fromRGB(18, 18, 36),
    ScrollBg = Color3.fromRGB(15, 15, 30),
    White = Color3.fromRGB(255, 255, 255)
}

local FontMonospace = Drawing.Fonts.Monospace or Drawing.Fonts.UI

-- ========== HELPERS ==========
local function detectMobile()
    local success, uis = pcall(function() return game:GetService("UserInputService") end)
    if success then
        return uis.TouchEnabled and not uis.KeyboardEnabled
    end
    return false
end

local function makeDrawable(kind, props)
    if not state.hasDrawing then return nil end
    local obj = Drawing.new(kind)
    if props then
        for k, v in pairs(props) do
            if type(obj[k]) ~= "nil" then
                obj[k] = v
            end
        end
    end
    return obj
end

local function createNotify(title, text, duration)
    duration = duration or 4
    state.notifyId = state.notifyId + 1
    local id = state.notifyId
    table.insert(state.notifyList, {
        id = id,
        title = title,
        text = text,
        life = duration,
        maxLife = duration,
        y = -80,
        alpha = 1,
        bg = makeDrawable("Square", {Filled = true, Color = Theme.NotifyBg, Transparency = 1, ZIndex = 9999}),
        titleText = makeDrawable("Text", {Text = title, Color = Theme.Border, Size = 16, Font = FontMonospace, Transparency = 1, ZIndex = 10000}),
        descText = makeDrawable("Text", {Text = text, Color = Theme.Text, Size = 13, Font = FontMonospace, Transparency = 1, ZIndex = 10000}),
        border = makeDrawable("Square", {Filled = false, Color = Theme.Border, Thickness = 2, Transparency = 1, ZIndex = 10001}),
        progress = makeDrawable("Square", {Filled = true, Color = Theme.Border, Transparency = 1, ZIndex = 10002})
    })
    return id
end

local function saveConfig(data)
    local success = pcall(function()
        writefile("LapoHubX_Config.txt", game:GetService("HttpService"):JSONEncode(data))
    end)
    return success
end

local function loadConfig()
    local success, data = pcall(function()
        local content = readfile("LapoHubX_Config.txt")
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    if success and type(data) == "table" then return data end
    return {}
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- ========== DRAWING SYSTEM ==========
local drawingSystem = {}
local frame, header, sidebar, content, closeBtn, minimizeBtn, resizer
local tabBgList = {}
local tabTextList = {}
local drgs = {}
local contentDrawings = {}
local widgetList = {}
local hoverWidget = nil

function drawingSystem:setup()
    local s = state.scale
    local pos = state.framePos
    local sz = state.frameSize

    frame = makeDrawable("Square", {Filled = true, Color = Theme.Background, Transparency = 1, ZIndex = 10, Visible = state.visible})
    table.insert(drgs, frame)

    header = makeDrawable("Square", {Filled = true, Color = Theme.HeaderBg, Transparency = 1, ZIndex = 11, Visible = state.visible})
    table.insert(drgs, header)

    sidebar = makeDrawable("Square", {Filled = true, Color = Theme.Sidebar, Transparency = 1, ZIndex = 11, Visible = state.visible})
    table.insert(drgs, sidebar)

    content = makeDrawable("Square", {Filled = true, Color = Theme.Background, Transparency = 1, ZIndex = 11, Visible = state.visible})
    table.insert(drgs, content)

    closeBtn = makeDrawable("Text", {Text = "✕", Color = Theme.TextSecondary, Size = 20, Font = FontMonospace, ZIndex = 20, Visible = state.visible})
    table.insert(drgs, closeBtn)

    minimizeBtn = makeDrawable("Text", {Text = "─", Color = Theme.TextSecondary, Size = 20, Font = FontMonospace, ZIndex = 20, Visible = state.visible})
    table.insert(drgs, minimizeBtn)

    -- user info footer
    local userBg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 1, ZIndex = 14, Visible = state.visible})
    local userNameTxt = makeDrawable("Text", {Text = state.userName, Color = Theme.Text, Size = 13, Font = FontMonospace, ZIndex = 15, Visible = state.visible})
    local userRankTxt = makeDrawable("Text", {Text = state.userRank, Color = Theme.TextSecondary, Size = 11, Font = FontMonospace, ZIndex = 15, Visible = state.visible})
    table.insert(drgs, userBg)
    table.insert(drgs, userNameTxt)
    table.insert(drgs, userRankTxt)
    state._userBg = userBg
    state._userNameTxt = userNameTxt
    state._userRankTxt = userRankTxt
end

function drawingSystem:updateLayout()
    local s = state.scale
    local pos = state.framePos
    local sz = state.frameSize
    local mw, mh = pos.X, pos.Y
    local fw, fh = sz.X, sz.Y
    local headerH = 30 * s
    local sideW = 170 * s
    local footerH = 50 * s

    if state.minimized then
        fh = headerH
    end

    frame.Position = Vector2.new(mw, mh)
    frame.Size = Vector2.new(fw, fh)
    header.Position = Vector2.new(mw, mh)
    header.Size = Vector2.new(fw, headerH)

    sidebar.Position = Vector2.new(mw, mh + headerH)
    sidebar.Size = Vector2.new(sideW, fh - headerH - footerH)

    local cX = mw + sideW
    local cY = mh + headerH
    local cW = fw - sideW
    local cH = fh - headerH
    content.Position = Vector2.new(cX, cY)
    content.Size = Vector2.new(cW, cH)

    closeBtn.Position = Vector2.new(mw + fw - 28 * s, mh + 5 * s)
    minimizeBtn.Position = Vector2.new(mw + fw - 52 * s, mh + 5 * s)

    local tabStartY = mh + headerH + 4 * s
    for i, tabBg in ipairs(tabBgList) do
        local tabY = tabStartY + (i - 1) * 40 * s
        tabBg.Position = Vector2.new(mw + 4 * s, tabY)
        tabBg.Size = Vector2.new(sideW - 8 * s, 36 * s)
        tabBg.Color = i == state.currentTab and Theme.Border or Color3.new(0,0,0)
        tabBg.Transparency = i == state.currentTab and 0.15 or 0
    end
    for i, tabTxt in ipairs(tabTextList) do
        local tabY = tabStartY + (i - 1) * 40 * s
        tabTxt.Position = Vector2.new(mw + 20 * s, tabY + 9 * s)
        tabTxt.Color = i == state.currentTab and Theme.Accent or Theme.TextSecondary
        tabTxt.Size = 13 * s
    end

    -- user footer
    local userBg = state._userBg
    local userNameTxt = state._userNameTxt
    local userRankTxt = state._userRankTxt
    if userBg then
        userBg.Position = Vector2.new(mw, mh + fh - footerH)
        userBg.Size = Vector2.new(sideW, footerH)
        userBg.Visible = state.visible
    end
    if userNameTxt then
        userNameTxt.Position = Vector2.new(mw + 10 * s, mh + fh - footerH + 8 * s)
        userNameTxt.Visible = state.visible
    end
    if userRankTxt then
        userRankTxt.Position = Vector2.new(mw + 10 * s, mh + fh - footerH + 26 * s)
        userRankTxt.Visible = state.visible
    end
end

-- ========== WIDGET SYSTEM ==========
local function createWidget(type, props)
    local bg, label, extra
    local s = state.scale

    if type == "Button" then
        bg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 1, ZIndex = 15})
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.Text, Size = 16 * s, Font = FontMonospace, ZIndex = 16})
        table.insert(contentDrawings, bg)
        table.insert(contentDrawings, label)
        return {
            type = "Button",
            bg = bg,
            label = label,
            text = props.text or "Button",
            callback = props.callback or function() end,
            hovering = false,
            y = 0, h = 44 * s,
            destroy = function()
                bg:Remove()
                label:Remove()
            end,
            updateText = function(self, newText)
                self.text = newText
                self.label.Text = newText
            end
        }
    elseif type == "Toggle" then
        local checked = props.default or false
        bg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 1, ZIndex = 15})
        local checkBg = makeDrawable("Square", {Filled = true, Color = checked and Theme.Accent or Theme.SliderTrack, Transparency = 1, ZIndex = 16})
        local checkMark = makeDrawable("Text", {Text = checked and "✓" or "", Color = Theme.Background, Size = 16 * s, Font = FontMonospace, ZIndex = 17})
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.Text, Size = 16 * s, Font = FontMonospace, ZIndex = 16})
        table.insert(contentDrawings, bg)
        table.insert(contentDrawings, checkBg)
        table.insert(contentDrawings, checkMark)
        table.insert(contentDrawings, label)
        return {
            type = "Toggle",
            bg = bg,
            checkBg = checkBg,
            checkMark = checkMark,
            label = label,
            text = props.text or "Toggle",
            value = checked,
            callback = props.callback or function() end,
            y = 0, h = 44 * s,
            toggle = function(self)
                self.value = not self.value
                self.checkBg.Color = self.value and Theme.Accent or Theme.SliderTrack
                self.checkMark.Text = self.value and "✓" or ""
                self.callback(self.value)
            end,
            destroy = function()
                bg:Remove()
                checkBg:Remove()
                checkMark:Remove()
                label:Remove()
            end
        }
    elseif type == "Slider" then
        local min = props.min or 0
        local max = props.max or 100
        local val = props.default or math.floor((min + max) / 2)
        bg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 1, ZIndex = 15})
        local track = makeDrawable("Square", {Filled = true, Color = Theme.SliderTrack, Transparency = 1, ZIndex = 16})
        local fill = makeDrawable("Square", {Filled = true, Color = Theme.Accent, Transparency = 1, ZIndex = 17})
        local thumb = makeDrawable("Square", {Filled = true, Color = Theme.Border, Transparency = 1, ZIndex = 18})
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.Text, Size = 16 * s, Font = FontMonospace, ZIndex = 16})
        local valText = makeDrawable("Text", {Text = tostring(val), Color = Theme.TextSecondary, Size = 14 * s, Font = FontMonospace, ZIndex = 17})
        table.insert(contentDrawings, bg)
        table.insert(contentDrawings, track)
        table.insert(contentDrawings, fill)
        table.insert(contentDrawings, thumb)
        table.insert(contentDrawings, label)
        table.insert(contentDrawings, valText)
        return {
            type = "Slider",
            bg = bg, track = track, fill = fill, thumb = thumb,
            label = label, valText = valText,
            text = props.text or "Slider",
            min = min, max = max, value = val,
            callback = props.callback or function() end,
            y = 0, h = 60 * s,
            isDragging = false,
            updateValue = function(self, v)
                self.value = math.clamp(v, self.min, self.max)
                self.valText.Text = tostring(math.floor(self.value))
                self.callback(self.value)
            end,
            destroy = function()
                bg:Remove()
                track:Remove()
                fill:Remove()
                thumb:Remove()
                label:Remove()
                valText:Remove()
            end
        }
    elseif type == "Dropdown" then
        local options = props.options or {}
        bg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 1, ZIndex = 15})
        local display = makeDrawable("Square", {Filled = true, Color = Theme.SliderTrack, Transparency = 1, ZIndex = 16})
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.Text, Size = 16 * s, Font = FontMonospace, ZIndex = 16})
        local selectedText = makeDrawable("Text", {Text = options[props.default] or options[1] or "Select", Color = Theme.TextSecondary, Size = 14 * s, Font = FontMonospace, ZIndex = 17})
        local arrow = makeDrawable("Text", {Text = "▼", Color = Theme.TextSecondary, Size = 14 * s, Font = FontMonospace, ZIndex = 17})
        local popupBg = makeDrawable("Square", {Filled = true, Color = Theme.NotifyBg, Transparency = 1, ZIndex = 20})
        local popupDraws = {}
        table.insert(contentDrawings, bg)
        table.insert(contentDrawings, display)
        table.insert(contentDrawings, label)
        table.insert(contentDrawings, selectedText)
        table.insert(contentDrawings, arrow)
        table.insert(contentDrawings, popupBg)
        return {
            type = "Dropdown",
            bg = bg, display = display,
            label = label, selectedText = selectedText, arrow = arrow,
            popupBg = popupBg, popupDraws = popupDraws,
            text = props.text or "Dropdown",
            options = options,
            selected = props.default or 1,
            callback = props.callback or function() end,
            open = false,
            hoverIdx = 1,
            y = 0, h = 50 * s,
            destroy = function()
                bg:Remove()
                display:Remove()
                label:Remove()
                selectedText:Remove()
                arrow:Remove()
                popupBg:Remove()
                for _, d in ipairs(popupDraws) do
                    d:Remove()
                end
            end
        }
    elseif type == "TextBox" then
        bg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 1, ZIndex = 15})
        local inputBg = makeDrawable("Square", {Filled = true, Color = Theme.InputBg, Transparency = 1, ZIndex = 16})
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.Text, Size = 16 * s, Font = FontMonospace, ZIndex = 16})
        local cursor = makeDrawable("Text", {Text = "|", Color = Theme.Accent, Size = 16 * s, Font = FontMonospace, ZIndex = 18})
        local valueText = makeDrawable("Text", {Text = props.placeholder or "Type here...", Color = Theme.TextSecondary, Size = 14 * s, Font = FontMonospace, ZIndex = 17})
        table.insert(contentDrawings, bg)
        table.insert(contentDrawings, inputBg)
        table.insert(contentDrawings, label)
        table.insert(contentDrawings, cursor)
        table.insert(contentDrawings, valueText)
        return {
            type = "TextBox",
            bg = bg, inputBg = inputBg,
            label = label, cursor = cursor, valueText = valueText,
            text = props.text or "TextBox",
            placeholder = props.placeholder or "Type here...",
            callback = props.callback or function() end,
            value = "",
            focused = false,
            cursorVis = true,
            y = 0, h = 62 * s,
            destroy = function()
                bg:Remove()
                inputBg:Remove()
                label:Remove()
                cursor:Remove()
                valueText:Remove()
            end
        }
    elseif type == "Label" then
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.Text, Size = 16 * s, Font = FontMonospace, ZIndex = 16})
        table.insert(contentDrawings, label)
        return {
            type = "Label",
            label = label,
            text = props.text or "",
            y = 0, h = 28 * s,
            destroy = function()
                label:Remove()
            end
        }
    elseif type == "Paragraph" then
        label = makeDrawable("Text", {Text = props.text or "", Color = Theme.TextSecondary, Size = 13 * s, Font = FontMonospace, ZIndex = 16})
        table.insert(contentDrawings, label)
        return {
            type = "Paragraph",
            label = label,
            text = props.text or "",
            y = 0, h = (props.text and #props.text > 50) and 60 * s or 28 * s,
            destroy = function()
                label:Remove()
            end
        }
    end
    return nil
end

-- ========== TAB SYSTEM ==========
function LapoHub:AddTab(name, icon)
    if not state.initialized then
        table.insert(state.tabs, {name = name, icon = icon or "", widgets = {}})
        return
    end
    table.insert(state.tabs, {name = name, icon = icon or "", widgets = {}})
    self:Init({Title = state.title, ToggleKey = state.toggleKey})
    return self
end

local function rebuildContent()
    for _, d in ipairs(contentDrawings) do
        pcall(function() d:Remove() end)
    end
    contentDrawings = {}
    widgetList = {}
    state.contentOffset = 0
    state.maxOffset = 0

    if #state.tabs == 0 then return end
    local tab = state.tabs[state.currentTab]
    if not tab then return end

    local s = state.scale
    local padding = 12 * s
    local currentY = padding

    for _, wdesc in ipairs(tab.widgets) do
        local w = createWidget(wdesc.type, wdesc.props)
        if w then
            w.desc = wdesc
            w.y = currentY
            widgetList[#widgetList + 1] = w
            currentY = currentY + w.h + 6 * s
        end
    end

    state.maxOffset = math.max(0, currentY - (state.frameSize.Y - 80 * s))
end

-- ========== WIDGET ADDERS ==========
local function resolveTab(tabIdx)
    if type(tabIdx) == "string" then
        for i, t in ipairs(state.tabs) do
            if t.name == tabIdx then return i end
        end
        return state.currentTab
    end
    if tabIdx > #state.tabs then tabIdx = #state.tabs end
    if tabIdx < 1 then tabIdx = 1 end
    return tabIdx
end

local function addWidgetToTab(tabIdx, type, props)
    tabIdx = resolveTab(tabIdx or state.currentTab)
    local tab = state.tabs[tabIdx]
    if not tab then return end
    table.insert(tab.widgets, {type = type, props = props})
    if state.initialized then
        rebuildContent()
    end
end

function LapoHub:AddButton(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "Button", config)
    return self
end

function LapoHub:AddToggle(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "Toggle", config)
    return self
end

function LapoHub:AddSlider(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "Slider", config)
    return self
end

function LapoHub:AddDropdown(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "Dropdown", config)
    return self
end

function LapoHub:AddTextBox(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "TextBox", config)
    return self
end

function LapoHub:AddLabel(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "Label", config)
    return self
end

function LapoHub:AddParagraph(tabIdx, config)
    addWidgetToTab(tabIdx or state.currentTab, "Paragraph", config)
    return self
end

-- ========== NOTIFY ==========
function LapoHub:Notify(config)
    config = config or {}
    createNotify(config.title or "Lapo Hub X (Syn Version)", config.content or "", config.duration)
    return self
end

-- ========== SET USER ==========
function LapoHub:SetUser(name, rank)
    state.userName = name or state.userName
    state.userRank = rank or state.userRank
    if state._userNameTxt then
        state._userNameTxt.Text = state.userName
    end
    if state._userRankTxt then
        state._userRankTxt.Text = state.userRank
    end
    return self
end

function LapoHub:SetUserCallback(cb)
    state.userCallback = cb
    return self
end

-- ========== TOGGLE VISIBILITY ==========
function LapoHub:ToggleVisibility()
    state.visible = not state.visible
    for _, d in ipairs(drgs) do
        d.Visible = state.visible
    end
    for _, d in ipairs(contentDrawings) do
        d.Visible = state.visible
    end
    for _, tb in ipairs(tabBgList) do tb.Visible = state.visible end
    for _, tt in ipairs(tabTextList) do tt.Visible = state.visible end
    return self
end

-- ========== DESTROY ==========
function LapoHub:Destroy()
    state.destroyFlag = true
    for _, d in ipairs(drgs) do
        pcall(function() d:Remove() end)
    end
    for _, d in ipairs(contentDrawings) do
        pcall(function() d:Remove() end)
    end
    for _, tb in ipairs(tabBgList) do pcall(function() tb:Remove() end) end
    for _, tt in ipairs(tabTextList) do pcall(function() tt:Remove() end) end
    for _, conn in ipairs(state.connections) do
        pcall(function() conn:Disconnect() end)
    end
    drgs = {}
    contentDrawings = {}
    tabBgList = {}
    tabTextList = {}
    state.connections = {}
    widgetList = {}
    state.initialized = false
    return self
end

-- ========== INPUT SYSTEM ==========
local function setupInput()
    local uis = game:GetService("UserInputService")
    local runSvc = game:GetService("RunService")
    local ts = game:GetService("TweenService")

    local function getMousePos()
        return uis:GetMouseLocation()
    end

    local keyConn = uis.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.End and not state.keyHeldDown then
            state.keyHeldDown = true
            LapoHub:ToggleVisibility()
            return
        end
        if input.KeyCode == Enum.KeyCode.Return then
            return
        end
    end)
    table.insert(state.connections, keyConn)

    local keyEndConn = uis.InputEnded:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.End then
            state.keyHeldDown = false
        end
    end)
    table.insert(state.connections, keyEndConn)

    local mouseDownConn = uis.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
           input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not state.visible then return end
        local mp = getMousePos()
        local px, py = mp.X, mp.Y
        local mx, my = state.framePos.X, state.framePos.Y
        local sz = state.frameSize
        local s = state.scale
        local sideW = 170 * s

        if px >= mx and px <= mx + sz.X and py >= my and py <= my + 30 * s then
            local closeX = mx + sz.X - 30 * s
            local minX = mx + sz.X - 55 * s
            if px >= closeX - 15 * s and px <= closeX + 15 * s and py >= my + 5 * s and py <= my + 35 * s then
                LapoHub:Destroy()
                return
            end
            if px >= minX - 15 * s and px <= minX + 15 * s and py >= my + 5 * s and py <= my + 35 * s then
                state.minimized = not state.minimized
                if not state.minimized then
                    state.frameSize = Vector2.new(sz.X, 600 * s)
                end
                return
            end
            state.isDragging = true
            state.dragOffset = Vector2.new(px - mx, py - my)
            return
        end

        local tabStartY = my + 30 * s + 4 * s
        for i = 1, #state.tabs do
            local tabY = tabStartY + (i - 1) * 40 * s
            if px >= mx + 4 * s and px <= mx + sideW - 4 * s and py >= tabY and py <= tabY + 36 * s then
                state.currentTab = i
                rebuildContent()
                return
            end
        end

        -- user footer click
        local footerH = 50 * s
        if px >= mx and px <= mx + sideW and py >= my + sz.Y - footerH and py <= my + sz.Y then
            if state.userCallback then
                state.userCallback(state.userName, state.userRank)
            end
            return
        end

        local cX = mx + sideW
        local cY = my + 30 * s
        local cW = sz.X - sideW
        local cH = state.minimized and 0 or (sz.Y - 30 * s)
        if px >= cX and px <= cX + cW and py >= cY and py <= cY + cH then
            local relY = py - cY + state.contentOffset
            for _, w in ipairs(widgetList) do
                local wy = cY + w.y - state.contentOffset
                local wh = w.h
                if relY >= w.y and relY <= w.y + wh then
                    if w.type == "Button" then
                        w.callback()
                        return
                    elseif w.type == "Toggle" then
                        w:toggle()
                        return
                    elseif w.type == "Slider" then
                        state.isSliding = true
                        state.slidingWidget = w
                        w.isDragging = true
                        local trackX = cX + 12 * s
                        local trackW = cW - 24 * s
                        local ratio = math.clamp((px - trackX) / trackW, 0, 1)
                        local val = w.min + ratio * (w.max - w.min)
                        w:updateValue(val)
                        return
                    elseif w.type == "Dropdown" then
                        if not w.open then
                            w.open = true
                            state.dropdownOpen = true
                            state.dropdownWidget = w
                            w.hoverIdx = 1
                            for _, d in ipairs(w.popupDraws) do d:Remove() end
                            w.popupDraws = {}
                            for idx, opt in ipairs(w.options) do
                                local optBg = makeDrawable("Square", {Filled = true, Color = Theme.Surface, Transparency = 0.1, ZIndex = 21})
                                local optTxt = makeDrawable("Text", {Text = opt, Color = Theme.Text, Size = 14 * s, Font = FontMonospace, ZIndex = 22})
                                table.insert(w.popupDraws, optBg)
                                table.insert(w.popupDraws, optTxt)
                                table.insert(contentDrawings, optBg)
                                table.insert(contentDrawings, optTxt)
                            end
                        else
                            w.open = false
                            state.dropdownOpen = false
                            state.dropdownWidget = nil
                            for _, d in ipairs(w.popupDraws) do
                                pcall(function() d:Remove() end)
                            end
                            w.popupDraws = {}
                        end
                        return
                    elseif w.type == "TextBox" then
                        w.focused = true
                        w.valueText.Text = w.value or ""
                        w.valueText.Color = Theme.Text
                        return
                    end
                end
            end
        end

        for _, w in ipairs(widgetList) do
            if w.type == "TextBox" and w.focused then
                w.focused = false
                if w.value and #w.value > 0 then
                    w.valueText.Text = w.value
                    w.valueText.Color = Theme.Text
                    w.callback(w.value)
                else
                    w.valueText.Text = w.placeholder
                    w.valueText.Color = Theme.TextSecondary
                end
            end
            if w.type == "Dropdown" and w.open then
                w.open = false
                state.dropdownOpen = false
                state.dropdownWidget = nil
                for _, d in ipairs(w.popupDraws) do
                    pcall(function() d:Remove() end)
                end
                w.popupDraws = {}
            end
        end
    end)
    table.insert(state.connections, mouseDownConn)

    local mouseUpConn = uis.InputEnded:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            state.isDragging = false
            if state.slidingWidget then
                state.slidingWidget.isDragging = false
            end
            state.isSliding = false
            state.slidingWidget = nil
        end
    end)
    table.insert(state.connections, mouseUpConn)

    local mouseMoveConn = uis.InputChanged:Connect(function(input, gpe)
        if not state.visible then return end
        local mp = getMousePos()
        local px, py = mp.X, mp.Y
        local s = state.scale

        if state.isDragging then
            state.framePos = Vector2.new(px - state.dragOffset.X, py - state.dragOffset.Y)
            return
        end

        if state.isSliding and state.slidingWidget then
            local w = state.slidingWidget
            local sideW = 170 * s
            local cX = state.framePos.X + sideW
            local cW = state.frameSize.X - sideW
            local trackX = cX + 12 * s
            local trackW = cW - 24 * s
            local ratio = math.clamp((px - trackX) / trackW, 0, 1)
            local val = w.min + ratio * (w.max - w.min)
            w:updateValue(val)
            return
        end

        if state.initialized then
            local sideW = 170 * s
            local cX = state.framePos.X + sideW
            local cY = state.framePos.Y + 30 * s
            local cW = state.frameSize.X - sideW
            local cH = state.frameSize.Y - 30 * s
            if px >= cX and px <= cX + cW and py >= cY and py <= cY + cH then
                if state.dropdownOpen and state.dropdownWidget then
                    local dw = state.dropdownWidget
                    local itemH = 36 * s
                    local popY = cY + dw.y - state.contentOffset + dw.h
                    local popX = cX + 8 * s
                    local popW = cW - 16 * s
                    local popH = #dw.options * itemH
                    if px >= popX and px <= popX + popW and py >= popY and py <= popY + popH then
                        local idx = math.floor((py - popY) / itemH) + 1
                        idx = math.clamp(idx, 1, #dw.options)
                        dw.hoverIdx = idx
                        for i, d in ipairs(dw.popupDraws) do
                            if i % 2 == 1 then
                                local optIdx = math.floor((i - 1) / 2) + 1
                                d.Color = optIdx == idx and Theme.Hover or Theme.Surface
                            end
                        end
                    end
                end
            end
        end
    end)
    table.insert(state.connections, mouseMoveConn)

    local scrollConn = uis.InputChanged:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if not state.visible then return end
            local s = state.scale
            local sideW = 170 * s
            local cX = state.framePos.X + sideW
            local cY = state.framePos.Y + 30 * s
            local cW = state.frameSize.X - sideW
            local cH = state.frameSize.Y - 30 * s
            local mp = getMousePos()
            local px, py = mp.X, mp.Y
            if px >= cX and px <= cX + cW and py >= cY and py <= cY + cH then
                local delta = input.Position.Z * 30
                state.contentOffset = math.clamp(state.contentOffset + delta, 0, state.maxOffset)
            end
        end
    end)
    table.insert(state.connections, scrollConn)

    local textInputConn = uis.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for _, w in ipairs(widgetList) do
            if w.type == "TextBox" and w.focused then
                if input.KeyCode == Enum.KeyCode.Backspace then
                    w.value = string.sub(w.value or "", 1, -2)
                    w.valueText.Text = w.value or ""
                    return
                end
                if input.KeyCode == Enum.KeyCode.Return then
                    w.focused = false
                    w.callback(w.value)
                    if w.value and #w.value > 0 then
                        w.valueText.Text = w.value
                        w.valueText.Color = Theme.Text
                    else
                        w.valueText.Text = w.placeholder
                        w.valueText.Color = Theme.TextSecondary
                    end
                    return
                end
                local char = ""
                if input.KeyCode >= Enum.KeyCode.A and input.KeyCode <= Enum.KeyCode.Z then
                    char = string.char(string.byte("A") + (input.KeyCode.Value - 8))
                    local shift = uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift)
                    if not shift then char = string.lower(char) end
                elseif input.KeyCode >= Enum.KeyCode.One and input.KeyCode <= Enum.KeyCode.Zero then
                    local num = (input.KeyCode.Value - 9) % 10
                    char = tostring(num)
                elseif input.KeyCode == Enum.KeyCode.Space then
                    char = " "
                end
                if char and #char > 0 then
                    w.value = (w.value or "") .. char
                    w.valueText.Text = w.value
                    w.valueText.Color = Theme.Text
                end
                return
            end
        end
    end)
    table.insert(state.connections, textInputConn)
end

-- ========== RENDER LOOP ==========
local function startRenderLoop()
    local runSvc = game:GetService("RunService")
    local conn = runSvc.RenderStepped:Connect(function(dt)
        if state.destroyFlag then
            conn:Disconnect()
            return
        end
        if not state.visible then
            local toRemove = {}
            for i, n in ipairs(state.notifyList) do
                n.life = n.life - dt
                if n.life <= 0 then
                    n.alpha = math.max(0, n.alpha - dt * 2)
                    if n.alpha <= 0 then
                        table.insert(toRemove, i)
                    end
                end
            end
            for i = #toRemove, 1, -1 do
                local idx = toRemove[i]
                local n = state.notifyList[idx]
                pcall(function()
                    n.bg:Remove()
                    n.titleText:Remove()
                    n.descText:Remove()
                    n.border:Remove()
                    n.progress:Remove()
                end)
                table.remove(state.notifyList, idx)
            end
            return
        end

        local s = state.scale
        local pos = state.framePos
        local sz = state.frameSize
        local headerH = 30 * s
        local sideW = 170 * s
        local footerH = 50 * s

        local mw, mh = pos.X, pos.Y
        local fw, fh = sz.X, sz.Y
        if state.minimized then fh = headerH end

        frame.Position = Vector2.new(mw, mh)
        frame.Size = Vector2.new(fw, fh)
        frame.Visible = true

        header.Position = Vector2.new(mw, mh)
        header.Size = Vector2.new(fw, headerH)

        sidebar.Position = Vector2.new(mw, mh + headerH)
        sidebar.Size = Vector2.new(sideW, fh - headerH - footerH)

        local cX = mw + sideW
        local cY = mh + headerH
        local cW = fw - sideW
        local cH = fh - headerH

        content.Position = Vector2.new(cX, cY)
        content.Size = Vector2.new(cW, cH)

        closeBtn.Position = Vector2.new(mw + fw - 28 * s, mh + 5 * s)
        minimizeBtn.Position = Vector2.new(mw + fw - 52 * s, mh + 5 * s)

        local tabStartY = mh + headerH + 4 * s
        for i, tabBg in ipairs(tabBgList) do
            local tabY = tabStartY + (i - 1) * 40 * s
            tabBg.Position = Vector2.new(mw + 4 * s, tabY)
            tabBg.Size = Vector2.new(sideW - 8 * s, 36 * s)
            tabBg.Color = i == state.currentTab and Theme.Border or Color3.new(0, 0, 0)
            tabBg.Transparency = i == state.currentTab and 0.15 or 0
            tabBg.Visible = true
        end
        for i, tabTxt in ipairs(tabTextList) do
            local tabY = tabStartY + (i - 1) * 40 * s
            tabTxt.Position = Vector2.new(mw + 20 * s, tabY + 9 * s)
            tabTxt.Color = i == state.currentTab and Theme.Accent or Theme.TextSecondary
            tabTxt.Size = 13 * s
            tabTxt.Visible = true
        end

        if not state.minimized then
            -- user footer
            local uBg = state._userBg
            local uName = state._userNameTxt
            local uRank = state._userRankTxt
            if uBg then
                uBg.Position = Vector2.new(mw, mh + fh - footerH)
                uBg.Size = Vector2.new(sideW, footerH)
                uBg.Visible = true
            end
            if uName then
                uName.Position = Vector2.new(mw + 10 * s, mh + fh - footerH + 8 * s)
                uName.Visible = true
            end
            if uRank then
                uRank.Position = Vector2.new(mw + 10 * s, mh + fh - footerH + 26 * s)
                uRank.Visible = true
            end
        else
            local uBg = state._userBg
            local uName = state._userNameTxt
            local uRank = state._userRankTxt
            if uBg then uBg.Visible = false end
            if uName then uName.Visible = false end
            if uRank then uRank.Visible = false end
        end

        if not state.minimized then
            for _, w in ipairs(widgetList) do
                local wy = cY + w.y - state.contentOffset
                local wh = w.h
                local visible = wy + wh > cY and wy < cY + cH
                if not visible then
                    if w.bg then w.bg.Visible = false end
                    if w.label then w.label.Visible = false end
                    if w.type == "Toggle" then
                        if w.checkBg then w.checkBg.Visible = false end
                        if w.checkMark then w.checkMark.Visible = false end
                    elseif w.type == "Slider" then
                        if w.track then w.track.Visible = false end
                        if w.fill then w.fill.Visible = false end
                        if w.thumb then w.thumb.Visible = false end
                        if w.valText then w.valText.Visible = false end
                    elseif w.type == "Dropdown" then
                        if w.display then w.display.Visible = false end
                        if w.selectedText then w.selectedText.Visible = false end
                        if w.arrow then w.arrow.Visible = false end
                        if w.popupBg then w.popupBg.Visible = false end
                        for _, d in ipairs(w.popupDraws) do
                            d.Visible = false
                        end
                    elseif w.type == "TextBox" then
                        if w.inputBg then w.inputBg.Visible = false end
                        if w.cursor then w.cursor.Visible = false end
                        if w.valueText then w.valueText.Visible = false end
                    end
                else
                    local paddingX = 12 * s
                    local widgetW = cW - paddingX * 2

                    if w.type == "Button" then
                        w.bg.Position = Vector2.new(cX + paddingX, wy)
                        w.bg.Size = Vector2.new(widgetW, wh)
                        w.bg.Color = w.hovering and Theme.Hover or Theme.Surface
                        w.bg.Visible = true
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + (wh - 16 * s) / 2)
                        w.label.Text = w.text
                        w.label.Visible = true
                    elseif w.type == "Toggle" then
                        w.bg.Position = Vector2.new(cX + paddingX, wy)
                        w.bg.Size = Vector2.new(widgetW, wh)
                        w.bg.Visible = true
                        local checkSize = 20 * s
                        local checkX = cX + paddingX + widgetW - checkSize - 8 * s
                        local checkY = wy + (wh - checkSize) / 2
                        w.checkBg.Position = Vector2.new(checkX, checkY)
                        w.checkBg.Size = Vector2.new(checkSize, checkSize)
                        w.checkBg.Visible = true
                        w.checkMark.Position = Vector2.new(checkX + 2 * s, checkY - 2 * s)
                        w.checkMark.Visible = true
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + (wh - 16 * s) / 2)
                        w.label.Text = w.text
                        w.label.Visible = true
                    elseif w.type == "Slider" then
                        w.bg.Position = Vector2.new(cX + paddingX, wy)
                        w.bg.Size = Vector2.new(widgetW, wh)
                        w.bg.Visible = true
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + 4 * s)
                        w.label.Text = w.text
                        w.label.Visible = true
                        local trackY = wy + wh - 14 * s
                        local trackH = 6 * s
                        w.track.Position = Vector2.new(cX + paddingX + 10 * s, trackY)
                        w.track.Size = Vector2.new(widgetW - 20 * s, trackH)
                        w.track.Visible = true
                        local ratio = (w.value - w.min) / (w.max - w.min)
                        w.fill.Position = Vector2.new(cX + paddingX + 10 * s, trackY)
                        w.fill.Size = Vector2.new((widgetW - 20 * s) * ratio, trackH)
                        w.fill.Visible = true
                        w.thumb.Position = Vector2.new(cX + paddingX + 10 * s + (widgetW - 20 * s) * ratio - 4 * s, trackY - 4 * s)
                        w.thumb.Size = Vector2.new(14 * s, 14 * s)
                        w.thumb.Visible = true
                        w.valText.Position = Vector2.new(cX + paddingX + widgetW - 50 * s, wy + 4 * s)
                        w.valText.Text = tostring(math.floor(w.value))
                        w.valText.Visible = true
                    elseif w.type == "Dropdown" then
                        w.bg.Position = Vector2.new(cX + paddingX, wy)
                        w.bg.Size = Vector2.new(widgetW, wh)
                        w.bg.Visible = true
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + (wh - 16 * s) / 2)
                        w.label.Text = w.text
                        w.label.Visible = true
                        local dispW = 160 * s
                        local dispX = cX + paddingX + widgetW - dispW - 8 * s
                        w.display.Position = Vector2.new(dispX, wy + 8 * s)
                        w.display.Size = Vector2.new(dispW, wh - 16 * s)
                        w.display.Visible = true
                        w.selectedText.Position = Vector2.new(dispX + 6 * s, wy + (wh - 14 * s) / 2)
                        w.selectedText.Text = w.options[w.selected] or "Select"
                        w.selectedText.Visible = true
                        w.arrow.Position = Vector2.new(dispX + dispW - 20 * s, wy + (wh - 14 * s) / 2)
                        w.arrow.Text = w.open and "▲" or "▼"
                        w.arrow.Visible = true
                        w.popupBg.Visible = w.open
                        if w.open then
                            local itemH = 36 * s
                            local popY = wy + wh
                            local popH = #w.options * itemH
                            w.popupBg.Position = Vector2.new(dispX, popY)
                            w.popupBg.Size = Vector2.new(dispW, popH)
                            w.popupBg.Color = Theme.NotifyBg
                            for i, d in ipairs(w.popupDraws) do
                                d.Visible = true
                                if i % 2 == 1 then
                                    local optIdx = math.floor((i - 1) / 2) + 1
                                    local optY = popY + (optIdx - 1) * itemH
                                    d.Position = Vector2.new(dispX, optY)
                                    d.Size = Vector2.new(dispW, itemH)
                                    d.Color = optIdx == w.hoverIdx and Theme.Hover or Theme.Surface
                                else
                                    local optIdx = math.floor((i - 2) / 2) + 1
                                    local optY = popY + (optIdx - 1) * itemH
                                    d.Position = Vector2.new(dispX + 8 * s, optY + (itemH - 14 * s) / 2)
                                    d.Text = w.options[optIdx] or ""
                                end
                            end
                        end
                    elseif w.type == "TextBox" then
                        w.bg.Position = Vector2.new(cX + paddingX, wy)
                        w.bg.Size = Vector2.new(widgetW, wh)
                        w.bg.Visible = true
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + 4 * s)
                        w.label.Text = w.text
                        w.label.Visible = true
                        local inputY = wy + 28 * s
                        local inputH = wh - 34 * s
                        w.inputBg.Position = Vector2.new(cX + paddingX + 10 * s, inputY)
                        w.inputBg.Size = Vector2.new(widgetW - 20 * s, inputH)
                        w.inputBg.Visible = true
                        local textX = cX + paddingX + 16 * s
                        local textY = inputY + (inputH - 14 * s) / 2
                        w.valueText.Position = Vector2.new(textX, textY)
                        if w.focused then
                            w.valueText.Text = w.value or ""
                            w.valueText.Color = Theme.Text
                        end
                        w.valueText.Visible = true
                        w.cursor.Position = Vector2.new(textX + (#(w.valueText.Text) * 8), textY)
                        w.cursor.Visible = w.focused and (math.floor(tick() * 2) % 2 == 0)
                    elseif w.type == "Label" then
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + 4 * s)
                        w.label.Visible = true
                    elseif w.type == "Paragraph" then
                        w.label.Position = Vector2.new(cX + paddingX + 10 * s, wy + 4 * s)
                        w.label.Visible = true
                    end
                end
            end
        else
            for _, w in ipairs(widgetList) do
                if w.bg then w.bg.Visible = false end
                if w.label then w.label.Visible = false end
                if w.type == "Toggle" then
                    if w.checkBg then w.checkBg.Visible = false end
                    if w.checkMark then w.checkMark.Visible = false end
                elseif w.type == "Slider" then
                    if w.track then w.track.Visible = false end
                    if w.fill then w.fill.Visible = false end
                    if w.thumb then w.thumb.Visible = false end
                    if w.valText then w.valText.Visible = false end
                elseif w.type == "Dropdown" then
                    if w.display then w.display.Visible = false end
                    if w.selectedText then w.selectedText.Visible = false end
                    if w.arrow then w.arrow.Visible = false end
                elseif w.type == "TextBox" then
                    if w.inputBg then w.inputBg.Visible = false end
                    if w.cursor then w.cursor.Visible = false end
                    if w.valueText then w.valueText.Visible = false end
                end
            end
        end

        local notifStartX = mw + fw - 350 * s
        local notifStartY = mh + fh - 20 * s
        local toRemove = {}
        for i, n in ipairs(state.notifyList) do
            n.life = n.life - dt

            if n.life > n.maxLife - 0.3 then
                n.y = lerp(-80, 0, (n.maxLife - n.life) / 0.3)
            elseif n.life <= 0 then
                n.alpha = math.max(0, n.alpha - dt * 3)
            end

            local ny = notifStartY - (#state.notifyList - i) * 90 * s + n.y
            local nw = 330 * s
            local nh = 80 * s
            n.bg.Position = Vector2.new(notifStartX, ny)
            n.bg.Size = Vector2.new(nw, nh)
            n.bg.Transparency = 0.1 * n.alpha
            n.bg.Visible = n.alpha > 0

            n.titleText.Position = Vector2.new(notifStartX + 12 * s, ny + 8 * s)
            n.titleText.Transparency = n.alpha > 0 and 0 or 1
            n.titleText.Visible = n.alpha > 0

            n.descText.Position = Vector2.new(notifStartX + 12 * s, ny + 32 * s)
            n.descText.Transparency = n.alpha > 0 and 0 or 1
            n.descText.Visible = n.alpha > 0

            n.border.Position = Vector2.new(notifStartX, ny)
            n.border.Size = Vector2.new(nw, nh)
            n.border.Transparency = 0.8 * n.alpha
            n.border.Visible = n.alpha > 0

            local progress = math.max(0, n.life / n.maxLife)
            n.progress.Position = Vector2.new(notifStartX, ny + nh - 3 * s)
            n.progress.Size = Vector2.new(nw * progress, 3 * s)
            n.progress.Transparency = 0.6 * n.alpha
            n.progress.Visible = n.alpha > 0

            if n.alpha <= 0 then
                table.insert(toRemove, i)
            end
        end
        for i = #toRemove, 1, -1 do
            local idx = toRemove[i]
            local n = state.notifyList[idx]
            pcall(function()
                n.bg:Remove()
                n.titleText:Remove()
                n.descText:Remove()
                n.border:Remove()
                n.progress:Remove()
            end)
            table.remove(state.notifyList, idx)
        end
    end)
    table.insert(state.connections, conn)
end

-- ========== INIT ==========
function LapoHub:Init(config)
    config = config or {}
    state.title = config.Title or "Lapo Hub X (Syn Version)"
    state.toggleKey = config.ToggleKey or "End"
    state.mobile = detectMobile()
    state.scale = state.mobile and 0.65 or 1

    local s = state.scale
    if state.mobile then
        state.frameSize = Vector2.new(480 * s, 600 * s)
        state.framePos = Vector2.new(20, 40)
    else
        state.frameSize = Vector2.new(820 * s, 520 * s)
        state.framePos = Vector2.new(100, 80)
    end

    drawingSystem:setup()

    local s = state.scale
    local sideW = 170 * s
    for i, tab in ipairs(state.tabs) do
        local bg = makeDrawable("Square", {Filled = true, Color = Color3.new(0,0,0), Transparency = 0, ZIndex = 12, Visible = true})
        local txt = makeDrawable("Text", {Text = (tab.icon or "") .. "  " .. (tab.name or ""), Color = Theme.TextSecondary, Size = 13 * s, Font = FontMonospace, ZIndex = 13, Visible = true})
        table.insert(tabBgList, bg)
        table.insert(tabTextList, txt)
        table.insert(drgs, bg)
        table.insert(drgs, txt)
    end

    state.initialized = true

    rebuildContent()

    setupInput()

    startRenderLoop()

    local saved = loadConfig()
    if saved.currentTab then
        state.currentTab = math.clamp(saved.currentTab, 1, #state.tabs)
        rebuildContent()
    end

    createNotify("Lapo Hub X (Syn Version)", "Library loaded — " .. (state.mobile and "Mobile" or "Desktop") .. " mode", 3)

    return self
end

return LapoHub
