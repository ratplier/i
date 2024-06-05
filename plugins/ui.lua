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

local _secret = {
    events = {},
    locked = {},
    snap = {},
    limit = {},
}

i = {}
t = {}

local ui = {}

local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")

local misc = {}

function misc:Distance(v1, v2)
    local dist = (v1 - v2).Magnitude

    return dist
end

function misc:FindIn(t, i)
    for i,v in t do
        if v == i then
            return v
        end
    end
end

function misc:Udim2ToVector2(udim2: UDim2)
    local mouse = i.mouse:GetMouse()
    
    local x = mouse.ViewSizeX
    local y = mouse.ViewSizeY
    
    local resx = udim2.X.Offset + (x * udim2.X.Scale)
    local resy = udim2.Y.Offset + (x * udim2.Y.Scale)
    
    return Vector2.new(resx, resy)
end

function ui:SetDrag(bool: boolean)
    if bool == true then
        if _secret.events[self].uidrag ~= nil then return end
        _secret.events[self].uidrag = {}
        local events = _secret.events[self].uidrag
        local function event(...)
            for _,event in {...} do
                table.insert(events, event)
            end
        end
        
        local state = 0
        
        local gui = self.ui
        local mouse = self.mouse
        
        local isdown = false
        local ishover = false
        local dragging = false
        
        local dragStart
        local startPos
        local dragSpeed = 0.05

        local function getpos()
            return Vector2.new(mouse.X, mouse.Y)
        end
        
        event(mouse.Button1Down:Connect(function()
            if not state then return end
            isdown = true
            dragStart = getpos()
            startPos = gui.Position
        end))
        
        event(mouse.Button1Up:Connect(function()
            if not state then return end
            isdown = false
        end))
        
        event(mouse.Move:Connect(function()
            if not state then return end
            if dragging then
                local delta = getpos() - dragStart
                local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                ts:Create(gui, TweenInfo.new(dragSpeed), {Position = position}):Play()
            end
        end))
        
        event(rs.RenderStepped:Connect(function()
            if not state then return end
            local isinbounds
            if gui.AbsolutePosition.X <= mouse.X and gui.AbsolutePosition.X + gui.AbsoluteSize.X >= mouse.X then
                if gui.AbsolutePosition.Y <= mouse.Y and gui.AbsolutePosition.Y + gui.AbsoluteSize.Y >= mouse.Y then
                    isinbounds = true
                else
                    isinbounds = false
                end
            else
                isinbounds = false
            end
            if dragging then
                isinbounds = true
            end
            if isdown and isinbounds then
                dragging = true
            else
                dragging = false
            end
        end))
        
        event(function()
            state = nil
            isdown = nil
            gui = nil
            mouse = nil
        end)
        
    elseif bool == false then
        if _secret.events[self].uidrag then
            for i,v in ipairs(_secret.events[self].uidrag) do
                if t.callback(v) then
                    v()
                elseif t.RBXScriptConnection(v) then
                    v:Disconnect()
                end
            end
        end
    end
end

function ui:GetPosition()
    return self.ui.AbsolutePosition
end

function ui:GetSize()
    return self.ui.AbsoluteSize
end

function ui:LockXAxis(pos)
    if _secret.locked[self] ~= nil then return end
    
    _secret.locked[self] = {}
    _secret.locked[self].X = {}
    local events = _secret.locked[self].X
    local function event(...)
        for _,event in {...} do
            table.insert(events, event)
        end
    end
    
    local gui = self.ui
    local mouse = self.mouse
    pos = pos or UDim.new(0, mouse.X)
    
    event(rs.RenderStepped:Connect(function()
        gui.Position = UDim2.new(pos, gui.Position.Y)
    end))
end

function ui:LockYAxis(pos)
    if _secret.locked[self] ~= nil then return end

    _secret.locked[self] = {}
    _secret.locked[self].Y = {}
    local events = _secret.locked[self].Y
    local function event(...)
        for _,event in {...} do
            table.insert(events, event)
        end
    end

    local gui = self.ui
    local mouse = self.mouse
    pos = pos or UDim.new(0, mouse.X)

    event(rs.RenderStepped:Connect(function()
        gui.Position = UDim2.new(gui.Position.X, pos)
    end))
end

function ui:UnlockXAxis()
    for i,v in pairs(_secret.locked[self].X) do
        print(typeof(v))
        if t.callback(v) then
            v()
        elseif t.RBXScriptConnection(v) then
            v:Disconnect()
        end
    end
end

function ui:UnlockYAxis()
    for i,v in pairs(_secret.locked[self].Y) do
        if t.callback(v) then
            v()
        elseif t.RBXScriptConnection(v) then
            v:Disconnect()
        end
    end
end

function ui:Snap(bool, pos, dist)
    if bool then
        if _secret.snap[self] ~= nil then return end

        _secret.snap[self] = {}
        local events = _secret.snap[self]
        local function event(...)
            for _,event in {...} do
                table.insert(events, event)
            end
        end
        
        local gui = self.ui
        
        event(rs.RenderStepped:Connect(function()
            local mag = misc:Distance(misc:Udim2ToVector2(gui.Position), misc:Udim2ToVector2(pos))
            
            if mag <= dist then
                gui.Position = pos
            end
        end))
    else
        if _secret.snap[self] == nil then return end
        
        for i,v in pairs(_secret.snap[self]) do
            if t.callback(v) then
                v()
            elseif t.RBXScriptConnection(v) then
                v:Disconnect()
            end
        end
        
        _secret.snap[self] = nil
    end
end

function ui:LimitX(bool, min, max)
    if bool then
        if _secret.limit[self] ~= nil then return end

        _secret.limit[self] = {}
        local events = _secret.limit[self]
        local function event(...)
            for _,event in {...} do
                table.insert(events, event)
            end
        end
        
        local ui = self.ui
        
        event(rs.RenderStepped:Connect(function()
            if min then
                if ui.AbsolutePosition.X < min then
                    ui.Position = UDim2.fromOffset(min, ui.AbsolutePosition.Y)
                end
            end
            
            if max then
                if ui.AbsolutePosition.X > max then
                    ui.Position = UDim2.fromOffset(max, ui.AbsolutePosition.Y)
                end
            end
        end))
    end
    
end

local ret

return function(plugin, _i, _t)
    i = _i()
    t = _t
    return = {
        add = function(obj: GuiObject)
            if t.Instance(obj) and obj:IsA("GuiObject") then
                local self = setmetatable({}, {__index = ui})
                
                self.ui = obj
                self.mouse = i.mouse:GetMouse()
                --self.time
                
                _secret.events[self] = {}
                
                table.freeze(self)
                
                return self
            end
        end,
        clear = function(ui)
            
        end,
    }
end
