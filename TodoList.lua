local m_name = "TodoList"
local m_savedAccountVariables
local m_savedLocalVariables
local m_mainWindow = {}
local m_listItems = {}
local m_listTabs = {}

TodoList = {
    GetName = function()
        return m_name
    end,
    MainWindow = m_mainWindow,
    Items = m_listItems,
    Tabs = m_listTabs
}

function TodoList:Initialize()
    zo_callLater(
        function()
            m_mainWindow.Initialize()
        end,
        2000
    )
    d("Todo List Loaded sucessfully!")
end

function TodoList.OnAddOnLoaded(event, addonName)
    if addonName ~= m_name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(m_name, EVENT_ADD_ON_LOADED)

    m_savedAccountVariables = LibSavedVars
        :NewCharacterSettings("GJTDL_vars", "Characters", {})
        :AddAccountWideToggle("GJTDL_vars", "Account")
        :MigrateFromAccountWide({name = "GJTDL_vars"})

    TodoList.SavedAccountVariables = m_savedAccountVariables
    TodoList.SavedLocalVariables = m_savedLocalVariables
    TodoList:Initialize()
end

EVENT_MANAGER:RegisterForEvent(m_name, EVENT_ADD_ON_LOADED, TodoList.OnAddOnLoaded)
