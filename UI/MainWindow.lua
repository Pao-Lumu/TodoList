local m_defaultHeight
local m_mainWindowControl
local m_minimizedWindowControl

local m_fragment
local m_minimizedFragment
local m_isFragmentAddedToScenes = false
local m_isMinimizedFragmentAddedToScenes = false
local m_defaultListLength = 3
local m_currentListLength = 0
local m_defaultTabCount = 1
local m_currentTabCount = 0


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

function TodoList.MainWindow.AddNewLine()
    local dynamicControl =
        CreateControlFromVirtual("$(parent)Item", GJTDL_MainWindowControlList, "Item", m_currentListLength + 1)
    -- dynamicControl:ClearAnchors()
    dynamicControl:SetAnchor(TOPLEFT, GJTDL_MainWindowControlList, TOPLEFT, 35, 40 * m_currentListLength)
    dynamicControl:SetAnchor(TOPRIGHT, GJTDL_MainWindowControlList, TOPRIGHT, -15, 40 * m_currentListLength)
    m_currentListLength = m_currentListLength + 1
end

function TodoList.MainWindow.Initialize()
    m_mainWindowControl = GJTDL_MainWindowControl
    m_defaultHeight = m_mainWindowControl:GetHeight()

    m_mainWindowControl:ClearAnchors()
    m_mainWindowControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 20)
    m_mainWindowControl:SetHandler("OnMoveStop", SavePosition)
    -- m_mainWindowControl:SetNormalFontColor(0)

    for i = 1, m_defaultListLength do
        TodoList.MainWindow.AddNewLine()
    end

    m_fragment = ZO_SimpleSceneFragment:New(m_mainWindowControl)
end
