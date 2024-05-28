```
	type identity : {
	    Name : string
	    Value : Number
	}
	
	Plugin | nil i.plugin
	
	Enum.KeyCode i.key
	
	dictionary i.mouse : {
	    MouseButton1 : identity,
	    MouseButton2 : identity,
	    MouseButton3 : identity,
	    mouse : () -> Mouse,
	    pos : () -> Vector2,
	    delta : (number | Vector2) -> (Vector2)
        target : () -> Instance,
        origin : () -> CFrame
	}
	
	dictionary i.on : {
	    keydown : (keyCode : Enum.KeyCode) -> RBXScriptSignal,
	    keyup : (keyCode : Enum.KeyCode) -> RBXScriptSignal,
	    mousemove : () -> RBXScriptSignal,
	    mousedown : (button : identity) -> RBXScriptSignal,
	    mouseup : (button : identity) -> RBXScriptSignal,
	}
	
	dictionary i.is : {
	    keydown : (keyCode : Enum.KeyCode) -> boolean,
        keyup : (keyCode : Enum.KeyCode) -> boolean,
        mousedown : (button : identity) -> boolean,
        mouseup : (button : identity) -> boolean
	}
	
	function i:GetKeysDown : () -> {Enum.KeyCode},
    function i:GetMouseButtonsDown : () -> {identity},
    
    function i:Keystroke : ( {Enum.Keycode | string} ) -> RBXScriptSignal
```