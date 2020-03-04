local m_defaultHeight
local m_mainWindowControl
local m_minimizedWindowControl

local m_fragment
local m_minimizedFragment
local m_isFragmentAddedToScenes = false
local m_isMinimizedFragmentAddedToScenes = false

local m_defaultListLength = 3
local m_currentListLength = 0
local m_maxListLength = 10

local m_defaultTabCount = 2
local m_currentTabCount = 0
local m_maxTabCount = 5
local m_lastTab

local function SavePosition()
    local savedAccountVariables = TodoList.SavedAccountVariables
    savedAccountVariables.MainWindowPositionX = m_mainWindowControl:GetLeft()
    savedAccountVariables.MainWindowPositionY = m_mainWindowControl:GetTop()
end

local function SetWindowHeight(height)
    local guiRootHeight = GuiRoot:GetHeight()
    local savedAccountVariables = TodoList.SavedAccountVariables
    height = height + m_defaultHeight

    if m_mainWindowControl:GetTop() + height > guiRootHeight then
        m_mainWindowControl:ClearAnchors()
        m_mainWindowControl:SetAnchor(
            TOPLEFT,
            GuiRoot,
            TOPLEFT,
            savedAccountVariables.MainWindowPositionX,
            guiRootHeight - height
        )
    else
        m_mainWindowControl:ClearAnchors()
        m_mainWindowControl:SetAnchor(
            TOPLEFT,
            GuiRoot,
            TOPLEFT,
            savedAccountVariables.MainWindowPositionX,
            savedAccountVariables.MainWindowPositionY
        )
    end

    m_mainWindowControl:SetHeight(height)
end
TodoList.MainWindow.SetWindowHeight = SetWindowHeight

function TodoList.MainWindow.AddLine()
    local line = CreateControlFromVirtual("$(parent)Item", GJTDL_MainWindowControlList, "Item", m_currentListLength + 1)
    line:SetAnchor(TOPLEFT, GJTDL_MainWindowControlList, TOPLEFT, 35, 40 * m_currentListLength)
    line:SetAnchor(TOPRIGHT, GJTDL_MainWindowControlList, TOPRIGHT, -15, 40 * m_currentListLength)
    m_currentListLength = m_currentListLength + 1
end

function TodoList.MainWindow.AddTab()
    local tab = CreateControlFromVirtual("$(parent)Tab", GJTDL_MainWindowControlSwitcher, "Tab", m_currentTabCount + 1)

    if m_lastTab then
        tab:SetAnchor(LEFT, m_lastTab, RIGHT, 45, 0)
    else
        tab:SetAnchor(LEFT, GJTDL_MainWindowControlSwitcher, LEFT, (40 * m_currentTabCount), 20)
    end

    m_currentTabCount = m_currentTabCount + 1
    m_lastTab = tab
end

function TodoList.MainWindow.ShowTabEditBox(control)
    local tab = control
    local backdrop = control:GetParent():GetChild(1)
    local editbox = control:GetParent():GetChild(1):GetChild(1)

    backdrop:SetHidden(false)
    editbox:SetHidden(false)
    editbox:SetHandler(
        "OnEnter",
        function()
            TodoList.MainWindow.ShowTabButton(tab, true)
        end
    )
    editbox:SetHandler(
        "OnEscape",
        function()
            TodoList.MainWindow.ShowTabButton(tab, false)
        end
    )

    backdrop:SetAnchor(TOPLEFT, m_mainWindowControl, BOTTOMLEFT, 15, 15)
    backdrop:SetAnchor(TOPRIGHT, m_mainWindowControl, BOTTOMRIGHT, -15, 15)
    editbox:SetAnchor(TOPLEFT, m_mainWindowControl, BOTTOMLEFT, 15, 25)
    editbox:SetAnchor(TOPRIGHT, m_mainWindowControl, BOTTOMRIGHT, -15, 25)
    editbox:TakeFocus()
end

function TodoList.MainWindow.ShowTabButton(control, shouldSave)
    local tab = control
    local backdrop = control:GetParent():GetChild(1)
    local editbox = control:GetParent():GetChild(1):GetChild(1)
    local editText = editbox:GetText()
    local tabLabel = tab:GetLabelControl()

    editbox:SetMouseEnabled(false)
    editbox:SetKeyboardEnabled(false)
    backdrop:SetHidden(true)
    editbox:SetHidden(true)

    if shouldSave then
        tab:SetText(editText)
        tab:SetDimensions(tabLabel:GetTextDimensions())
        tabLabel:SetDimensions(tabLabel:GetTextDimensions())
        tabLabel:ClearAnchors()
        -- tabLabel:ClearHandlers()
        tabLabel:SetAnchor(LEFT, tab, RIGHT, 10, 0)
    end
end

function TodoList.MainWindow.Initialize()
    m_mainWindowControl = GJTDL_MainWindowControl
    m_defaultHeight = m_mainWindowControl:GetHeight()

    m_mainWindowControl:ClearAnchors()
    m_mainWindowControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 20)
    m_mainWindowControl:SetHandler("OnMoveStop", SavePosition)

    for i = 1, m_defaultListLength do
        TodoList.MainWindow.AddLine()
    end

    for i = 1, m_defaultTabCount do
        TodoList.MainWindow.AddTab()
    end

    m_fragment = ZO_SimpleSceneFragment:New(m_mainWindowControl)
end
