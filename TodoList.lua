local m_name = "TodoList"
local m_savedAccountVariables
local m_savedLocalVariables
local m_mainWindow = {}
local m_listItems = {}
local m_listTabs = {}

-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
TodoList = {
    GetName = function()
        return m_name
    end,
    MainWindow = m_mainWindow,
    Items = m_listItems,
    Tabs = m_listTabs
}

-- Next we create a function that will initialize our addon
function TodoList:Initialize()
    zo_callLater(
        function()
            d("Hello Tamriel!")
        end,
        2000
    )
    m_mainWindow.Initialize()
end

function TodoList.OnAddOnLoaded(event, addonName)
    if addonName ~= m_name then
        return
    end
    EVENT_MANAGER:UnregisterForEvent(m_name, EVENT_ADD_ON_LOADED)

    -- m_savedAccountVariables = ZO_SavedVars:NewAccountWide("GJTodoListVariables", 1, nil, TodoList.AccountVariables)
    -- m_savedLocalVariables = ZO_SavedVars:NewCharacterIdSettings("GJTodoListVariables", 2, nil, TodoList.LocalVariables)

    m_savedAccountVariables = LibSavedVars
        :NewCharacterSettings("GJTDL_vars", "Characters", {})
        :AddAccountWideToggle("GJTDL_vars", "Account")
        :MigrateFromAccountWide({name = "GJTDL_vars"})

    TodoList.SavedAccountVariables = m_savedAccountVariables
    TodoList.SavedLocalVariables = m_savedLocalVariables
    TodoList:Initialize()
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(m_name, EVENT_ADD_ON_LOADED, TodoList.OnAddOnLoaded)
