--                        __            ___                        
--    __                 /\ \__        /\_ \    __                 
--   /'_`\_  _ __    __  \ \ ,_\  _____\//\ \  /\_\     __   _ __  
--  /'/'_` \/\`'__\/'__`\ \ \ \/ /\ '__`\\ \ \ \/\ \  /'__`\/\`'__\
-- /\ \ \L\ \ \ \//\ \L\.\_\ \ \_\ \ \L\ \\_\ \_\ \ \/\  __/\ \ \/ 
-- \ \ `\__,_\ \_\\ \__/.\_\\ \__\\ \ ,__//\____\\ \_\ \____\\ \_\ 
--  \ `\_____\\/_/ \/__/\/_/ \/__/ \ \ \/ \/____/ \/_/\/____/ \/_/ 
--   `\/_____/                      \ \_\                          
--                                   \/_/                 
-- i (because short names are good?)
-- by ratplier
-- © 2024 Version 3
-- 
-- All rights reserved
--

--!nonstrict


local i = {}

-- services

local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local t = require(script.t)

-- types

export type identity = {
    Name : string,
    Value: number
}

-- local definitons

local events = {}

local function event(...)
    table.insert(events, ...)
    return event
end

-- id maker

local _GET_UNIQUE_ID = function()
    local func = coroutine.create(function() end);
    local str = tostring(func):sub(11, -1);
    coroutine.close(func)
    return str
end

i.plugin = nil

i.opt = {
    ignoregpe = false
}

i.key = Enum.KeyCode
i.mouse = {
    MouseButton1 = {
        Name = "MouseButton1",
        Value = _GET_UNIQUE_ID()
    } :: identity,
    MouseButton2 = {
        Name = "MouseButton2",
        Value = _GET_UNIQUE_ID()
    } :: identity,
    MouseButton3 = {
        Name = "MouseButton3",
        Value = _GET_UNIQUE_ID()
    } :: identity,
    GetMouse = function()
        return if i.plugin then i.plugin:GetMouse() elseif rs:IsClient() then game.Players.LocalPlayer:GetMouse() else nil
    end,
    pos = function()
        local mouse = i.mouse.GetMouse()
        
        if mouse then
            return Vector2.new(mouse.X, mouse.Y)
        end
    end,
    delta = function(delta)
        if typeof(delta) == "number" then
            local prevframe = i.mouse.pos()
            task.wait(delta)
            return i.mouse.pos() - prevframe
        elseif typeof(delta) == "Vector2" then
            return i.mouse.pos() - delta
        end
    end,
    target = function()
        local mouse = i.mouse.GetMouse()
        
        if mouse then
            return mouse.Target
        end
    end,
    origin = function()
        local mouse = i.mouse.GetMouse()

        if mouse then
            return mouse.Origin
        end
    end
}

i.on = {
    keydown = function(key)
        if t.enum(Enum.KeyCode)(key) then
            local e = Instance.new("BindableEvent")
            event(uis.InputBegan:Connect(function(input, gpe)
                if i.opt.ignoregpe then 
                    if gpe then return end
                end
                if input.KeyCode == key then
                    e:Fire()
                end
            end))
            return e.Event
        elseif t.string(key) then
            if Enum.KeyCode[key] then
                local e = Instance.new("BindableEvent")
                event(uis.InputBegan:Connect(function(input, gpe)
                    if i.opt.ignoregpe then 
                        if gpe then return end
                    end
                    if input.KeyCode == Enum.KeyCode[key] then
                        e:Fire()
                    end
                end))
            else
                warn("Given key does not exist")
            end
        end
    end,
    keyup = function(key)
        if t.enum(Enum.KeyCode)(key) then
            local e = Instance.new("BindableEvent")
            event(uis.InputEnded:Connect(function(input, gpe)
                if i.opt.ignoregpe then 
                    if gpe then return end
                end
                if input.KeyCode == key then
                    e:Fire()
                end
            end))
            return e.Event
        elseif t.string(key) then
            if Enum.KeyCode[key] then
                local e = Instance.new("BindableEvent")
                event(uis.InputEnded:Connect(function(input, gpe)
                    if i.opt.ignoregpe then 
                        if gpe then return end
                    end
                    if input.KeyCode == Enum.KeyCode[key] then
                        e:Fire()
                    end
                end))
            else
                warn("Given key does not exist")
            end
        end
    end,
    mousemove = function()
        local e = Instance.new("BindableEvent")
        event(uis.InputChanged:Connect(function(input, gpe)
            if i.opt.ignoregpe then 
                if gpe then return end
            end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                e:Fire(input.Position.X, input.Position.Y, input.Position.Z)
            end
        end))
        return e.Event
    end,
    mousedown = function(button)
        if button ~= i.mouse.MouseButton1 or button ~= i.mouse.MouseButton2 or button ~= i.mouse.MouseButton3 or nil then return end
        local e = Instance.new("BindableEvent")
        event(uis.InputBegan:Connect(function(input, gpe)
            if i.opt.ignoregpe then 
                if gpe then return end
            end
            if input.UserInputType == Enum.UserInputType[button.Name or "MouseButton1"] then
                e:Fire()
            end
        end))
        return e.Event
    end,
    mouseup = function(button)
        if button ~= i.mouse.MouseButton1 or button ~= i.mouse.MouseButton2 or button ~= i.mouse.MouseButton3 or nil then return end
        local e = Instance.new("BindableEvent")
        event(uis.InputEnded:Connect(function(input, gpe)
            if i.opt.ignoregpe then 
                if gpe then return end
            end
            if input.UserInputType == Enum.UserInputType[button.Name or "MouseButton1"] then
                e:Fire()
            end
        end))
        return e.Event
    end,
}

i.is = {
    keydown = function(key)
        if t.enum(Enum.KeyCode)(key) then
            return uis:IsKeyDown(key)
        elseif t.string(key) then
            if Enum.KeyCode[key] then
                return uis:IsKeyDown(Enum.KeyCode[key])
            else
                warn("Given key does not exist")
            end
        end
    end,
    keyup = function(key)
        if t.enum(Enum.KeyCode)(key) then
            return not uis:IsKeyDown(key)
        elseif t.string(key) then
            if Enum.KeyCode[key] then
                return not uis:IsKeyDown(Enum.KeyCode[key])
            else
                warn("Given key does not exist")
            end
        end
    end,
    mousedown = function(mousebutton)
        local mb: {InputObject} = uis:GetMouseButtonsPressed()
        if mousebutton == i.mouse.MouseButton1 then
            for _,v in ipairs(mb) do
                if v.UserInputType == Enum.UserInputType.MouseButton1 then
                    return true
                end
            end
            return false
        elseif mousebutton == i.mouse.MouseButton2 then
            for _,v in ipairs(mb) do
                if v.UserInputType == Enum.UserInputType.MouseButton2 then
                    return true
                end
            end
            return false
        elseif mousebutton == i.mouse.MouseButton3 then
            for _,v in ipairs(mb) do
                if v.UserInputType == Enum.UserInputType.MouseButton3 then
                    return true
                end
            end
            return false
        end
    end,
    mouseup = function(mousebutton)
        local mb: {InputObject} = uis:GetMouseButtonsPressed()
        if mousebutton == i.mouse.MouseButton1 then
            for _,v in ipairs(mb) do
                if v.UserInputType == Enum.UserInputType.MouseButton1 then
                    return false
                end
            end
            return true
        elseif mousebutton == i.mouse.MouseButton2 then
            for _,v in ipairs(mb) do
                if v.UserInputType == Enum.UserInputType.MouseButton2 then
                    return false
                end
            end
            return true
        elseif mousebutton == i.mouse.MouseButton3 then
            for _,v in ipairs(mb) do
                if v.UserInputType == Enum.UserInputType.MouseButton3 then
                    return true
                end
            end
            return false
        end
    end,
}

--[[**
    Gets all the current keys that are down and returns them    

    @returns A table of the current keys down
**--]]
function i:GetKeysDown()
    local keys = uis:GetKeysPressed()
    local res = {}
    for _,v: InputObject in pairs(keys) do
        table.insert(res, v.KeyCode.Name)
    end
    return res
end

--[[**
    Gets all the current mouse buttons that are down and returns them    

    @returns A table of the current mouse buttons down
**--]]
function i:GetMouseButtonsDown()
    local keys = uis:GetMouseButtonsPressed()
    local res = {}
    for _,v: InputObject in pairs(keys) do
        table.insert(res, i.mouse[v.UserInputType.Name])
    end
    return res
end

--[[**
    Takes a table where indexes are keynames, i.keys and/or Enum.KeyCodes and returns a event fired
    whenever those keys are pressed in that order

    Warning! This function uses for loops and numerical indexes to read the table in order so no 
    non numerical indexes should be in the first parameter

    @param keystroke A table of keynames, i.keys and/or Enum.KeyCodes to be used (in order) as a keystroke

    @returns A RBXScriptSignal that fires whenever the keybind is pressed
**--]]
function i:Keystroke(key)
    assert(t.table(key))

    local e = Instance.new("BindableEvent")
    
    local len = #key
    local last = 0
    
    uis.InputBegan:Connect(function(input, gpe)
        if i.opt.ignoregpe then 
            if gpe then return end
        end
        if input.KeyCode == key[last + 1] then
            last += 1
            if last == len then
                e:Fire()
            end
        else
            last = 0
        end
    end)
    
    uis.InputEnded:Connect(function(_, gpe)
        if i.opt.ignoregpe then 
            if gpe then return end
        end
        last = 0
    end)
    
    event(e)

    return e.Event
end

--[[**
    Frees the memory of all the events made from the library.

    Warning! Does not clear specific items, it clears all items at once!
**--]]
function i.Clear()
    for _,v in pairs(events) do
        if typeof(v) == "Instance" then
            v:Destroy()
        elseif typeof(v) == "RBXScriptConnection" then
            v:Disconnect()
        elseif typeof(v) == "function" then
            event()
        end
    end
end

return function(plugin, ...)
    i.plugin = if typeof(plugin) == "Instance" and plugin:IsA("Plugin") then plugin else nil

    i.extern = {...}

    do
        for _,module in pairs(i.extern) do
            if t.instance("ModuleScript")(module) then
                local data = require(module)
                
                if t.callback(data) then
                    data(plugin, i, t)
                elseif t.table(data) then
                    for k,v in pairs(data) do
                        i[k] = v
                    end
                else
                    i[module.Name] = data
                end
            end
        end
    end

    return i
end