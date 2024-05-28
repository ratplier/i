# Documentation for i (v3)

> i is a open source module for ease of use in plugins and ingame.

> It was originally made for the intent of keybinds originally but now is used for all the different types of ways to handle input and work with it.

---

`i.key` : a refrence to the `Enum.Keycode` in base roblox.

```lua
local i = require(game.ReplicatedStorage.i)

print(i.key.F) -- Enum.KeyCode.F or prints F
```

- `i.mouse` : a group of various mouse actions to be used in your code

- `i.mouse.MouseButton1` : A virtual refrence to the main click of a mouse

- `i.mouse.MouseButton2` : A virtual refrence to the secondary click of a mouse

- `i.mouse.MouseButton3` : A virtual refrence to the tertiary click of a mouse

- `i.mouse.GetMouse` : Returns the current active mouse, depending on if there is a `i.plugin` or the runcontext is client

```lua
local i = require(game.ReplicatedStorage.i)

i.mouse:GetMouse()
```

- `i.mouse.pos` : Returns the current x and y of the mouse as a `Vector2`

```lua
local i = require(game.ReplicatedStorage.i)

print(i.mouse.pos)
```

- `i.mouse.delta` : Returns the delta between the `i.mouse.pos` and either a `Vector2` or a amount of time

```lua
local i = require(game.ReplicatedStorage.i)

print(i.mouse.delta(Vector2.new(0, 0)))
print(i.mouse.delta(3))
```

- `i.mouse.target` : Returns the object the current mouse is hovering over

```lua
local i = require(game.ReplicatedStorage.i)

print(typeof(i.mouse.target)) -- Instance
```

- `i.mouse.origin` : Returns the CFrame of where the mouse is pointing at in 3D space

```lua
local i = require(game.ReplicatedStorage.i)

print(i.mouse.origin().Position) -- outputs: 3, 3, 3
```

`i.on` : A container for all the functions to recieve events when a button is interacted with

- `i.on.keydown` : Returns an event that fires whenever a key is down

```lua
local i = require(game.ReplicatedStorage.i)

i.on.keydown("c"):Connect(function()
    print("crouch")
end)
```

- `i.on.keyup` : Returns an event that fires whenever a key is lifted

```lua
local i = require(game.ReplicatedStorage.i)

i.on.keyup("c"):Connect(function()
    print("stop crouch")
end)
```

- `i.on.mousemove` : Returns an event that fires whenver the mouse moves

```lua
local i = require(game.ReplicatedStorage.i)

i.on.mousemove():Connect(function()
    print("mousemove")
end)
```

- `i.on.mousedown` : Returns an event that fires whenever the mouse button goes down

```lua
local i = require(game.ReplicatedStorage.i)

i.on.mousedown(i.mouse.MouseButton1):Connect(function()
    print("mouse down")
end)
```

- `i.on.mouseup` : Returns an event that fires whenever the mouse button goes up

    ```lua
    local i = require(game.ReplicatedStorage.i)

    i.on.mouseup(i.mouse.MouseButton1):Connect(function()
        print("mouse up")
    end)
    ```

`i.is` : A container for all the functions to check if a button is interacted with

- `i.is.keydown`: Check if a button is down

    ```lua
    local i = require(game.ReplicatedStorage.i)
    local RunService = game:GetService("RunService")
    
    RunService.RenderStepped:Connect(function()
        if i.is.keydown("c") then
            print("crouching")
        end
    end)
    ```

- `i.is.keyup` : Check if a button is up

    ```lua
    local i = require(game.ReplicatedStorage.i)
    local RunService = game:GetService("RunService")
    
    RunService.RenderStepped:Connect(function()
        if i.is.keyup("c") then
            print("not crouching")
        end
    end)
    ```

- `i.is.mousedown` : Check if a mouse button is down

    ```lua
    local i = require(game.ReplicatedStorage.i)
    local RunService = game:GetService("RunService")
    
    RunService.RenderStepped:Connect(function()
        if i.is.mousedown(i.mouse.MouseButton1) then
            print("dragging")
        end
    end)
    ```

- `i.is.mouseup` : Check if a mouse button is up

    ```lua
    local i = require(game.ReplicatedStorage.i)
    local RunService = game:GetService("RunService")
    
    RunService.RenderStepped:Connect(function()
        if i.is.mouseup(i.mouse.MouseButton1) then
            print("not dragging")
        end
    end)
    ```

`i:GetKeysDown` : A function that gets all the current keys that are down and returns them

```lua
local i = require(game.ReplicatedStorage.i)

while task.wait(1) do
    print(i:GetKeysDown())
end
```

`i:Keystroke` : Takes a table where indexes are keynames, i.keys and/or Enum.KeyCodes and returns a event fired whenever those keys are pressed in that order

```lua
local i = require(game.ReplicatedStorage.i)

i:Keystroke({
    Enum.KeyCode.LeftControl,
    i.key.LeftShift,
    "z"
}):Connect(function()
    print("Mass Undo!")
end)
```

`i.Clear` Frees the memory of all the events made from the library

```lua
local i = require(game.ReplicatedStorage.i)

local event = RunService.RenderStepped:Connect(function()
    if i.is.mousedown(i.mouse.MouseButton1) then
        print("dragging")
    end
end)

task.wait(5)

event:Disconnect()
i.Clear()
```
