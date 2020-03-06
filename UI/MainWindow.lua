local m_defaultHeight = 500
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

local function AddLine()
    local line = CreateControlFromVirtual("$(parent)Item", GJTDL_MainWindowControlList, "GJTDL_ListItem", m_currentListLength + 1)
    line:SetAnchor(TOPLEFT, GJTDL_MainWindowControlList, TOPLEFT, 35, 40 * m_currentListLength)
    line:SetAnchor(TOPRIGHT, GJTDL_MainWindowControlList, TOPRIGHT, -15, 40 * m_currentListLength)
    m_currentListLength = m_currentListLength + 1
end

local function AddTab()
    local tab = CreateControlFromVirtual("$(parent)Tab", GJTDL_MainWindowControlSwitcher, "GJTDL_ListTab", m_currentTabCount + 1)
    tab:SetAnchor(LEFT, GJTDL_MainWindowControlSwitcher, LEFT, 10, 40 * m_currentTabCount)
    d(m_currentTabCount)
    tab:SetText("Tab " .. (m_currentTabCount + 1))
    m_currentTabCount = m_currentTabCount + 1
end

function ToggleCompletion(button)
    ZO_CheckButton_OnClicked(button)
    local checked = ZO_CheckButton_IsChecked(button)
    button:GetParent():GetNamedChild("$(parent)")
    if checked then
        d("Checked!")

    else
        d("Unchecked!")
    end
end

local function ShowTabEditBox(self, control)
    local tab = control
    local editbox = control:GetParent().GetNamedChild(control:GetParent() .. "Edit")
    tab:SetEnabled(false):SetHidden(true)
    editbox:SetHidden(false):SetMouseEnabled(true):SetKeyboardEnabled(true):SetText(tab:GetText()):TakeFocus()
end

local function ShowTabButton(self, shouldSave)
    local tab = control:GetParent().GetNamedChild(control:GetParent() .. "Button")
    local editbox = control

    editbox:SetMouseEnabled(false):SetKeyboardEnabled(false):SetHidden(true)
    tab:SetHidden(false):SetEnabled(true)

    if shouldSave then
        tab:SetText(editbox:GetText())
    end
end

function TodoList.MainWindow.Initialize()
    m_mainWindowControl = GJTDL_MainWindowControl
    -- m_defaultHeight = m_mainWindowControl:GetHeight()

    m_mainWindowControl:ClearAnchors()
    m_mainWindowControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 20)
    m_mainWindowControl:SetHandler("OnMoveStop", SavePosition)

    for i = 1, m_defaultListLength do
        AddLine()
    end

    for i = 1, m_defaultTabCount do
        AddTab()
    end

    m_fragment = ZO_SimpleSceneFragment:New(m_mainWindowControl)
end
