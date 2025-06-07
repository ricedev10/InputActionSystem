Basic API:
```luau
Input.new() -> InputContext
Input.InputActionType: {
	Bool: type
	Direction1D: type
	Direction2D: type
} -- list of custom InputActionTypes
Input.Priority: {
	High: {Value: number}
	Default: {Value: number}
	Low: {Value: number}
}

InputContext:AddAction() -> InputAction

InputAction:AddBinding() -> InputBinding
```

 Example usage (ModuleScript):
 ```luau
local InputSystem = require(Packages.InputSystem)
	
-- create input
local PlayerContext = InputSystem.new("PlayerInput", true, InputSystem.Priority.Default.Value, false)

-- add actions
local moveDirectionAction = PlayerContext:AddAction("MoveDirection", InputSystem.InputActionType.Direction2D)
moveDirectionAction:AddBinding(Enum.KeyCode.W, 1, {
	Up = Enum.KeyCode.W,
	Down = Enum.KeyCode.S,
	Right = Enum.KeyCode.D,
	Left = Enum.KeyCode.A,
})

local jumpAction = PlayerContext:AddAction("JumpAction", InputSystem.InputActionType.Bool)
jumpAction:AddBinding(Enum.KeyCode.Space, 1)

return {
	MoveDirection = moveDirectionAction,
	JumpAction = jumpAction,
}
```
