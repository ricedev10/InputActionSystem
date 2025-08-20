Using Roblox's [Input Action System](https://devforum.roblox.com/t/studio-beta-new-input-action-system/3656214), create [InputContext](https://create.roblox.com/docs/reference/engine/classes/InputContext)(s), [InputAction](https://create.roblox.com/docs/reference/engine/classes/InputAction)(s), and [InputBinding](https://create.roblox.com/docs/reference/engine/classes/InputBinding)(s) with ease with this typecheck-supported module.

# Basic API:

```luau
InputActionSystem.new() -> InputContext
InputActionSystem.InputActionType: {
	Bool: type
	Direction1D: type
	Direction2D: type
} -- list of custom InputActionTypes
InputActionSystem.Priority: {
	High: {Value: number}
	Default: {Value: number}
	Low: {Value: number}
}

InputContext:AddAction() -> InputAction

InputAction:AddBinding() -> InputBinding
```

Example usage (ModuleScript):

```luau
local InputActionSystem = require(path.to.InputActionSystem)

-- create input
local PlayerContext = InputActionSystem.new("PlayerInput", true, InputActionSystem.Priority.Default.Value, false)

-- add actions
local moveDirectionAction = PlayerContext:AddAction("MoveDirection", InputActionSystem.InputActionType.Direction2D)
moveDirectionAction:AddBinding(Enum.KeyCode.W, 1, {
	Up = Enum.KeyCode.W,
	Down = Enum.KeyCode.S,
	Right = Enum.KeyCode.D,
	Left = Enum.KeyCode.A,
})

local jumpAction = PlayerContext:AddAction("JumpAction", InputActionSystem.InputActionType.Bool)
jumpAction:AddBinding(Enum.KeyCode.Space, 1)
jumpAction:AddBinding(Enum.KeyCode.Up, 1)

return {
	Context = PlayerContext,
	MoveDirection = moveDirectionAction,
	JumpAction = jumpAction,
}
```

## Example in context

#### CameraInput.luau

```luau
local InputActionSystem = require(path.to.InputActionSystem)

local CameraInput = InputActionSystem.new("CameraInput", true, InputActionSystem.Priority.Default.Value, true)

local MouseMovementAction = CameraInput:AddAction("MouseMovement", InputActionSystem.InputActionType.Direction2D)

UserInputService.InputChanged:Connect(function(inputObject, gameProcessed)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		MouseMovementAction:Fire(UserInputService:GetMouseDelta())
	end
end)

return {
	MouseMovement = MouseMovementAction,
}
```

#### PlayerControls.luau

```luau
local InputActionSystem = require(path.to.InputActionSystem)

-- create input
local PlayerContext = InputActionSystem.new("PlayerInput", true, InputActionSystem.Priority.Default.Value, false)

-- add actions
local moveDirectionAction = PlayerContext:AddAction("MoveDirection", InputActionSystem.InputActionType.Direction2D)
moveDirectionAction:AddBinding(Enum.KeyCode.W, 1, {
   Up = Enum.KeyCode.W,
   Down = Enum.KeyCode.S,
   Right = Enum.KeyCode.D,
   Left = Enum.KeyCode.A,
})

local jumpAction = PlayerContext:AddAction("JumpAction", InputActionSystem.InputActionType.Bool)
jumpAction:AddBinding(Enum.KeyCode.Space, 1)
jumpAction:AddBinding(Enum.KeyCode.Up, 1)

return {
   Context = PlayerContext,
   MoveDirection = moveDirectionAction,
   JumpAction = jumpAction,
}
```
